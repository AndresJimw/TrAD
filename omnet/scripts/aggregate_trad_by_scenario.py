import pandas as pd
import os

input_path = r"D:\TrAD-Quito\omnet\results\TrAD_metrics_clean.csv"
output_path = r"D:\TrAD-Quito\omnet\results\summary_trad_metrics.csv"

df = pd.read_csv(input_path)

# FILTRAR: solo nodos reales
df = df[df['node'] >= 0].copy()

# Agrupar por escenario
df["scenario"] = df["run"].astype(int)
df_summary = df.groupby("scenario", as_index=False).mean(numeric_only=True)

# Guardar
df_summary.to_csv(output_path, index=False)
print(f"✅ Métricas por escenario (filtradas) exportadas a: {output_path}")
