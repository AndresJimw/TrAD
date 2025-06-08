import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# === Configuración de rutas ===
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
RESULTS_DIR = os.path.join(BASE_DIR, 'results')
INPUT_CSV = os.path.join(RESULTS_DIR, 'summary_trad_type2.csv')
SCATTER_PLOTS_DIR = os.path.join(RESULTS_DIR, 'scatter_plots_trad')

os.makedirs(SCATTER_PLOTS_DIR, exist_ok=True)

# === Cargar datos ===
df = pd.read_csv(INPUT_CSV)
df['scenario'] = df['scenario'].astype(int)
df = df.sort_values("scenario")

# Convertir PDR a porcentaje (si no está ya en %)
if df['pdr_ratio_beacon'].max() <= 1.0:
    df['pdr_ratio_beacon'] *= 100

# === Estilo profesional ===
sns.set_context("paper", font_scale=1.4)
sns.set_style("whitegrid")
plt.rcParams["font.family"] = "sans-serif"
plt.rcParams["font.sans-serif"] = ["DejaVu Sans", "Arial"]

# === 1. PDR vs Time Loss (obligatoria) ===
fig, ax = plt.subplots(figsize=(8, 5))
sns.scatterplot(
    data=df, x='pdr_ratio_beacon', y='avg_timeLoss', hue='scenario',
    palette='viridis', s=100, ax=ax
)
ax.set_title('PDR vs Average Time Loss')
ax.set_xlabel('Packet Delivery Ratio (%)')
ax.set_ylabel('Average Time Loss (s)')
plt.legend(title='Scenario Size')
plt.grid(True)
plt.tight_layout()
fig.savefig(os.path.join(SCATTER_PLOTS_DIR, 'pdr_vs_timeLoss.png'), dpi=300)
plt.close(fig)

# === 2. CBR vs Waiting Time (opcional) ===
fig, ax = plt.subplots(figsize=(8, 5))
sns.scatterplot(
    data=df, x='cbr_avg', y='avg_waitingTime', hue='scenario',
    palette='plasma', s=100, ax=ax
)
ax.set_title('Channel Busy Ratio vs Waiting Time')
ax.set_xlabel('Average Channel Busy Ratio')
ax.set_ylabel('Average Waiting Time (s)')
plt.legend(title='Scenario Size')
plt.grid(True)
plt.tight_layout()
fig.savefig(os.path.join(SCATTER_PLOTS_DIR, 'cbr_vs_waitingTime.png'), dpi=300)
plt.close(fig)

# === Final ===
print("✅ Gráficas de dispersión generadas:")
print(f"📌 {SCATTER_PLOTS_DIR}/pdr_vs_timeLoss.png")
print(f"📌 {SCATTER_PLOTS_DIR}/cbr_vs_waitingTime.png")
