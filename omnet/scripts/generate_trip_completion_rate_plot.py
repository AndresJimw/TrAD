# generate_trip_completion_rate_plot.py — Versión corregida sin leyenda confusa

import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.ticker import MaxNLocator

# === Configuración de rutas ===
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
RESULTS_DIR = os.path.join(BASE_DIR, 'results')
INPUT_CSV = os.path.join(RESULTS_DIR, 'summary_trad_type2.csv')
PLOT_OUTPUT = os.path.join(RESULTS_DIR, 'scalability_plots_trad', 'trip_completion_rate.png')

# === Cargar datos ===
df = pd.read_csv(INPUT_CSV)
df['scenario'] = df['scenario'].astype(int)
df = df.sort_values("scenario")

# === Calcular tasa de completitud de viajes (%)
df["trip_completion_rate"] = 100 * df["completed_trips"] / df["total_nodes"]

# === Estilo profesional
sns.set_context("paper", font_scale=1.4)
sns.set_style("whitegrid")
plt.rcParams["font.family"] = "sans-serif"
plt.rcParams["font.sans-serif"] = ["DejaVu Sans", "Arial"]

# === Crear gráfica sin leyenda
fig, ax = plt.subplots(figsize=(8, 5))
sns.barplot(x='scenario', y='trip_completion_rate', data=df, ax=ax, palette='crest')

# Etiquetas y título
ax.set_title("Trip Completion Rate by Scenario")
ax.set_xlabel("Total Vehicles")
ax.set_ylabel("Completion Rate (%)")
ax.yaxis.set_major_locator(MaxNLocator(nbins='auto', integer=True))

# No mostrar leyenda
ax.get_legend().remove() if ax.get_legend() else None

plt.grid(True)
plt.tight_layout()
fig.savefig(PLOT_OUTPUT, dpi=300)
plt.close(fig)

print(f"[✓] Gráfica corregida generada: {PLOT_OUTPUT}")
