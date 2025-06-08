# analyze_trad_results.py — ANÁLISIS DE ESCALABILIDAD Y CORRELACIÓN MEJORADO PARA PUBLICACIÓN

import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.ticker import MaxNLocator, FuncFormatter

# === Configuración de rutas ===
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
RESULTS_DIR = os.path.join(BASE_DIR, 'results')
INPUT_CSV = os.path.join(RESULTS_DIR, 'summary_trad_type2.csv')
CORR_PLOT = os.path.join(RESULTS_DIR, 'correlation_heatmap_trad.png')
SCALABILITY_PLOTS_DIR = os.path.join(RESULTS_DIR, 'scalability_plots_trad')
CORR_CSV = os.path.join(RESULTS_DIR, 'correlation_matrix_trad.csv')

os.makedirs(SCALABILITY_PLOTS_DIR, exist_ok=True)

# === Cargar datos combinados (movilidad + red) ===
df = pd.read_csv(INPUT_CSV)
df['scenario'] = df['scenario'].astype(int)
df = df.sort_values("scenario")

# Convertir PDR a porcentaje (si no lo está)
if df["pdr_ratio_beacon"].max() <= 1.0:
    df["pdr_ratio_beacon"] *= 100

# === Estilo profesional para paper ===
sns.set_context("paper", font_scale=1.4)
sns.set_style("whitegrid")
plt.rcParams["font.family"] = "sans-serif"
plt.rcParams["font.sans-serif"] = ["DejaVu Sans", "Arial"]

# === Diccionario de etiquetas con unidades para los ejes ===
metric_labels = {
    'messages_received_unique': 'Unique Messages Received',
    'pdr_ratio_beacon': 'Packet Delivery Ratio (%)',
    'dissemination_time_beacon': 'Dissemination Time (s)',
    'dissemination_distance_beacon': 'Dissemination Distance (m)',
    'cbr_avg': 'Average Channel Busy Ratio',
    'cbr_max': 'Maximum Channel Busy Ratio',
    'avg_timeLoss': 'Average Time Loss (s)',
    'avg_waitingTime': 'Average Waiting Time (s)',
    'avg_duration': 'Average Trip Duration (s)',
    'completed_trips': 'Completed Trips'
}

# === Gráficas de escalabilidad por métrica ===
for metric in metric_labels:
    if metric in df.columns:
        fig, ax = plt.subplots(figsize=(8, 5))
        sns.lineplot(x='scenario', y=metric, data=df, marker='o', linewidth=2.5, ax=ax)

        ax.set_title(f'{metric_labels[metric]} vs Total Vehicles')
        ax.set_xlabel('Total Vehicles')

        # Y-label con unidades y formato
        ax.set_ylabel(metric_labels[metric])

        # Eje X entero
        ax.xaxis.set_major_locator(MaxNLocator(integer=True))

        # Mostrar % si aplica
        if 'Ratio (%)' in metric_labels[metric]:
            ax.yaxis.set_major_formatter(FuncFormatter(lambda y, _: f'{y:.0f}%'))

        plt.grid(True)
        plt.tight_layout()

        # Guardar imagen
        fig.savefig(os.path.join(SCALABILITY_PLOTS_DIR, f'{metric}_scalability.png'),
                    dpi=300, bbox_inches='tight')
        plt.close(fig)

# === Matriz de correlación ===
corr_cols = [
    'pdr_ratio_beacon', 'dissemination_time_beacon', 'dissemination_distance_beacon',
    'cbr_avg', 'cbr_max', 'avg_timeLoss', 'avg_duration', 'avg_waitingTime'
]
available = [c for c in corr_cols if c in df.columns]
corr = df[available].corr(method='pearson')
corr.to_csv(CORR_CSV)

# === Heatmap de correlaciones ===
fig, ax = plt.subplots(figsize=(10, 8))
sns.heatmap(corr, annot=True, cmap='coolwarm', fmt=".2f",
            linewidths=0.6, cbar_kws={'shrink': 0.8}, square=True, ax=ax)
ax.set_title("Correlation Matrix: Network vs. Mobility Metrics (TrAD)")
plt.xticks(rotation=45, ha='right')
plt.yticks(rotation=0)
plt.tight_layout()
fig.savefig(CORR_PLOT, dpi=300, bbox_inches='tight')
plt.close(fig)

# === Mensajes finales ===
print("[✓] Análisis completo.")
print(f"📊 Matriz de correlación: {CORR_CSV}")
print(f"🔥 Heatmap guardado: {CORR_PLOT}")
print(f"📈 Gráficas en: {SCALABILITY_PLOTS_DIR}")
