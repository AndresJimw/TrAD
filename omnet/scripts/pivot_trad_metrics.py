import pandas as pd
import os

# Ruta del archivo generado
input_path = r"D:\TrAD-Quito\omnet\results\TrAD_summary.csv"
output_path = r"D:\TrAD-Quito\omnet\results\TrAD_metrics_clean.csv"

# Cargar
df = pd.read_csv(input_path)

# Validar columnas mínimas
required = {"run", "node", "metric", "value"}
if not required.issubset(df.columns):
    raise ValueError("Faltan columnas necesarias en el CSV")

# Pivot: convertir a formato ancho
df_wide = df.pivot_table(index=["run", "node"], columns="metric", values="value").reset_index()

# Guardar CSV limpio
df_wide.to_csv(output_path, index=False)

# Resumen rápido
print(df_wide.describe())
print(f"\n✅ CSV limpio exportado a: {output_path}")
