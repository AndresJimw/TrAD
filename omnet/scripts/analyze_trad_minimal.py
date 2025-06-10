import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.ticker import MaxNLocator

# === Configuración ===
INPUT_CSV = r"D:\TrAD-Quito\omnet\results\TrAD_summary.csv"
PLOTS_DIR = r"D:\TrAD-Quito\omnet\results\plots_trad_comparativo"

os.makedirs(PLOTS_DIR, exist_ok=True)

# === Cargar archivo largo ===
df = pd.read_csv(INPUT_CSV)

# === Verificar columnas necesarias ===
required = {"run", "node", "metric", "value"}
if not required.issubset(df.columns):
    raise ValueError("❌ El CSV no contiene las columnas necesarias: run, node, metric, value")

# === Pivot a formato ancho ===
df_wide = df.pivot_table(index=["run", "node"], columns="metric", values="value").reset_index()

# === Agrupar por escenario (run) y calcular promedio
df_summary = df_wide.groupby("run", as_index=False).mean(numeric_only=True)
df_summary = df_summary.rename(columns={"run": "scenario"})
df_summary = df_summary.sort_values("scenario")

# === Métricas a graficar
metricas = {
    "pdr_ratio_beacon": "PDR (%)",
    "dissemination_time_beacon": "Dissemination Time (s)",
    "dissemination_distance_beacon": "Dissemination Distance (m)",
    "dissemination_speed_beacon": "Dissemination Speed (m/s)",
    "norm_mac_load_beacon": "Normalized MAC Load",
    "cbr_avg": "Average CBR",
    "cbr_max": "Maximum CBR",
    "generatedWSMs": "Generated WSMs",
    "receivedWSMs": "Received WSMs",
    "messages_received_unique": "Unique Messages Received"
}

# === Estilo gráfico
sns.set_context("paper", font_scale=1.4)
sns.set_style("whitegrid")
plt.rcParams["font.family"] = "sans-serif"
plt.rcParams["font.sans-serif"] = ["Arial", "DejaVu Sans"]

# === Generar gráficas
for metrica, etiqueta in metricas.items():
    if metrica not in df_summary.columns:
        continue

    plt.figure(figsize=(8, 5))
    sns.barplot(x="scenario", y=metrica, data=df_summary, palette="viridis", ci=None)

    plt.title(f"{etiqueta} by Scenario", fontsize=16)
    plt.xlabel("Scenario (Total Vehicles)", fontsize=13)
    plt.ylabel(etiqueta, fontsize=13)
    plt.grid(True)
    plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))
    plt.tight_layout()

    # Guardar
    out_file = os.path.join(PLOTS_DIR, f"{metrica}_comparativo.png")
    plt.savefig(out_file, dpi=300)
    plt.close()

print(f"✅ Gráficas guardadas en: {PLOTS_DIR}")
