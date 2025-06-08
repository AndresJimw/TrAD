import os
import re
import pandas as pd

# Carpeta donde están los resultados .sca
resultados_dir = r"D:\TrAD-Quito\omnet\results"
archivo_salida = os.path.join(resultados_dir, "TrAD_summary.csv")

# Métricas que deseas extraer desde los .sca
metricas_deseadas = [
    "generatedWSMs", "receivedWSMs", "generatedBSMs", "receivedBSMs",
    "cbr_avg", "cbr_max", "beacon_count", "simtime_total", "messages_received_unique",
    "pdr_ratio_beacon", "norm_mac_load_beacon", "dissemination_time_beacon",
    "dissemination_distance_beacon", "dissemination_speed_beacon"
]

# Expresión para capturar líneas tipo scalar
patron_scalar = re.compile(r'^scalar\s+(?P<module>[^\s]+)\s+(?P<metric>[\w\-]+)\s+(?P<valor>[-+]?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)?)')

# Recoger resultados
resultados = []

# Leer archivos TrAD-type2_*.sca
for nombre_archivo in os.listdir(resultados_dir):
    if nombre_archivo.startswith("TrAD-type2_") and nombre_archivo.endswith(".sca"):
        ruta_archivo = os.path.join(resultados_dir, nombre_archivo)
        run_id = nombre_archivo.split("TrAD-type2_")[-1].split(".")[0]

        with open(ruta_archivo, "r", encoding="utf-8") as archivo:
            for linea in archivo:
                if linea.startswith("scalar"):
                    match = patron_scalar.match(linea.strip())
                    if match:
                        modulo = match.group("module")
                        metrica = match.group("metric")
                        valor = float(match.group("valor"))

                        if any(metrica.startswith(m) for m in metricas_deseadas):
                            nodo = -1
                            nodo_match = re.search(r'node\[(\d+)\]', modulo)
                            if nodo_match:
                                nodo = int(nodo_match.group(1))
                            resultados.append((run_id, nodo, metrica, valor))

# Crear DataFrame
df = pd.DataFrame(resultados, columns=["run", "node", "metric", "value"])

# Guardar en formato largo
df.to_csv(archivo_salida, index=False)
print(f"✅ Exportado a: {archivo_salida} ({len(df)} registros)")
