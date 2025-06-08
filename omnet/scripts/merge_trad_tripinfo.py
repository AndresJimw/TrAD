import os
import pandas as pd

# === Paths reales según tu estructura ===
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
OMNET_DIR = os.path.join(BASE_DIR, 'results')
SUMO_DIR = os.path.abspath(os.path.join(BASE_DIR, '..', 'sumo', 'output'))

trad_path = os.path.join(OMNET_DIR, "summary_trad_metrics.csv")
trip_path = os.path.join(SUMO_DIR, "summary_tripinfo_type2.csv")
output_path = os.path.join(OMNET_DIR, "summary_trad_type2.csv")

# === Leer CSVs ===
df_trad = pd.read_csv(trad_path)
df_trip = pd.read_csv(trip_path)

# === Extraer escenario como entero
df_trad["scenario"] = df_trad["file"].str.extract(r"TrAD-type2_(\d+)").astype(int)
df_trip["scenario"] = df_trip["file"].str.extract(r"tripinfo_type2_(\d+)").astype(int)

# === Agrupar df_trip por escenario (por si hay repeticiones)
df_trip_clean = df_trip.groupby("scenario", as_index=False).mean(numeric_only=True)

# === Merge
df_merged = pd.merge(df_trad, df_trip_clean, on="scenario")

# === Reordenar columnas
columnas_finales = [
    "scenario", "total_nodes", "messages_received_unique", "pdr_ratio_beacon",
    "dissemination_time_beacon", "dissemination_distance_beacon",
    "norm_mac_load_beacon", "cbr_avg", "cbr_max",
    "completed_trips", "avg_duration", "avg_routeLength", "avg_waitingTime", "avg_timeLoss"
]
columnas_disponibles = [col for col in columnas_finales if col in df_merged.columns]
df_merged = df_merged[columnas_disponibles]

# === Guardar limpio
df_merged.sort_values("scenario", inplace=True)
df_merged.to_csv(output_path, index=False)

print(f"[✓] Consolidado limpio exportado como {output_path}")
