import os
import pandas as pd

# Rutas
OMNET_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'results'))
SUMO_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'sumo', 'output'))

ARCHIVO_TRAD = os.path.join(OMNET_DIR, "summary_trad_metrics.csv")
ARCHIVO_SUMO = os.path.join(SUMO_DIR, "summary_tripinfo_type2.csv")
ARCHIVO_COMBINADO = os.path.join(OMNET_DIR, "summary_trad_vs_mobility.csv")

# Cargar archivos
df_trad = pd.read_csv(ARCHIVO_TRAD)
df_sumo = pd.read_csv(ARCHIVO_SUMO)

# Verifica que existe la columna 'file' en ambos
if 'file' not in df_trad.columns or 'file' not in df_sumo.columns:
    raise ValueError("Falta la columna 'file' en uno de los archivos CSV.")

# Extraer número de escenario
df_trad["scenario"] = df_trad["file"].str.extract(r"(\d+)")
df_sumo["scenario"] = df_sumo["file"].str.extract(r"(\d+)")

# Fusionar por escenario
df_merged = pd.merge(df_sumo, df_trad, on="scenario", suffixes=('_sumo', '_trad'))

# Eliminar columnas redundantes
df_merged = df_merged.drop(columns=["file_sumo", "file_trad"])

# Ordenar por número de escenario
df_merged = df_merged.sort_values(by="scenario")

# Guardar CSV combinado
df_merged.to_csv(ARCHIVO_COMBINADO, index=False)

print(f"[✓] Resultados combinados guardados en: {ARCHIVO_COMBINADO}")
