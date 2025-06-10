import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# === Rutas ===
INPUT_CSV = r"D:\TrAD-Quito\omnet\results\TrAD_metrics_clean.csv"
OUTPUT_DIR = r"D:\TrAD-Quito\omnet\results\analyze_trad_extra"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# === Cargar y validar CSV ===
df = pd.read_csv(INPUT_CSV)

if "run" not in df.columns or "node" not in df.columns:
    raise ValueError("CSV debe tener columnas 'run' y 'node'")

# === Columnas clave ===
metricas_deseadas = [
    "pdr_ratio_beacon",
    "dissemination_time_beacon",
    "dissemination_distance_beacon",
    "dissemination_speed_beacon",
    "norm_mac_load_beacon",
    "cbr_avg",
    "cbr_max",
    "generatedWSMs",
    "receivedWSMs",
    "messages_received_unique"
]

# === Filtrar columnas válidas ===
columnas_presentes = [col for col in metricas_deseadas if col in df.columns]
df = df[["run", "node"] + columnas_presentes]

# === Agrupar por escenario y promediar ===
df_summary = df.groupby("run", as_index=False).mean(numeric_only=True)
df_summary = df_summary.rename(columns={"run": "scenario"})
df_summary = df_summary.sort_values("scenario")

# === Guardar CSV limpio resumido ===
df_summary.to_csv(os.path.join(OUTPUT_DIR, "summary_trad_filtered.csv"), index=False)

# === Estilo visual ===
sns.set_context("paper", font_scale=1.4)
sns.set_style("whitegrid")
plt.rcParams["font.family"] = "sans-serif"
plt.rcParams["font.sans-serif"] = ["Arial", "DejaVu Sans"]

# === Matriz de correlación ===
corr = df_summary[columnas_presentes].corr(method='pearson')
corr_file = os.path.join(OUTPUT_DIR, "correlation_matrix.csv")
corr.to_csv(corr_file)

# === Heatmap ===
plt.figure(figsize=(10, 8))
sns.heatmap(corr, annot=True, fmt=".2f", cmap="coolwarm", square=True, cbar_kws={'shrink': 0.8})
plt.title("Correlation Matrix: TrAD Metrics")
plt.xticks(rotation=45, ha="right")
plt.tight_layout()
plt.savefig(os.path.join(OUTPUT_DIR, "correlation_heatmap.png"), dpi=300)
plt.close()

# === Gráficas de dispersión ===
scatter_pairs = [
    ("pdr_ratio_beacon", "dissemination_time_beacon"),
    ("pdr_ratio_beacon", "dissemination_speed_beacon"),
    ("cbr_avg", "pdr_ratio_beacon"),
    ("norm_mac_load_beacon", "dissemination_time_beacon"),
    ("receivedWSMs", "generatedWSMs"),
]

for x, y in scatter_pairs:
    if x in df_summary.columns and y in df_summary.columns:
        plt.figure(figsize=(8, 5))
        sns.scatterplot(data=df_summary, x=x, y=y, hue="scenario", palette="viridis", s=100)
        plt.title(f"{y} vs {x}")
        plt.xlabel(x)
        plt.ylabel(y)
        plt.grid(True)
        plt.tight_layout()
        plt.savefig(os.path.join(OUTPUT_DIR, f"{y}_vs_{x}.png"), dpi=300)
        plt.close()

print("✅ Análisis completado. Resultados guardados en:", OUTPUT_DIR)
