import os
import re
import pandas as pd

# Ruta al directorio de resultados
RESULTS_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'results'))
FILE_SALIDA = os.path.join(RESULTS_DIR, "summary_trad_metrics.csv")

# Métricas clave (pdr_ratio_beacon se calcula aparte)
METRICAS_OBJETIVO = [
    "messages_received_unique",
    "dissemination_time_beacon",
    "dissemination_distance_beacon",
    "cbr_avg",
    "cbr_max"
]

# Regex para scalar lines
PATRON_SCALAR = re.compile(r'^scalar\s+(?P<module>[^\s]+)\s+(?P<metric>[\w\-]+)\s+(?P<value>[-+]?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)?)')

# Procesar todos los .sca
datos = []

for file in os.listdir(RESULTS_DIR):
    if file.startswith("TrAD-type2_") and file.endswith(".sca"):
        ruta = os.path.join(RESULTS_DIR, file)
        row = {"file": file}

        match_nodos = re.search(r'TrAD-type2_(\d+)', file)
        total_nodos = int(match_nodos.group(1)) if match_nodos else None
        row["total_nodes"] = total_nodos

        nodos_con_recepcion = set()

        with open(ruta, "r", encoding="utf-8") as f:
            for linea in f:
                if linea.startswith("scalar"):
                    match = PATRON_SCALAR.match(linea.strip())
                    if match:
                        modulo = match.group("module")
                        metrica = match.group("metric")
                        valor = float(match.group("value"))

                        for objetivo in METRICAS_OBJETIVO:
                            if metrica.startswith(objetivo):
                                row[objetivo] = row.get(objetivo, 0.0) + valor

                        # Detectar nodos con mensajes recibidos
                        if metrica == "messages_received_unique" and valor > 0:
                            nodo_match = re.search(r'node\[(\d+)\]', modulo)
                            if nodo_match:
                                nodo_id = int(nodo_match.group(1))
                                nodos_con_recepcion.add(nodo_id)

        if total_nodos:
            row["pdr_ratio_beacon"] = len(nodos_con_recepcion) / total_nodos
        else:
            row["pdr_ratio_beacon"] = None

        datos.append(row)

# Guardar CSV
df = pd.DataFrame(datos)
df.sort_values('file', inplace=True)
df.to_csv(FILE_SALIDA, index=False)

print(f"[✓] Resultados TrAD exportados a {FILE_SALIDA}")