import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.ticker import MaxNLocator

# === Path configuration ===
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
RESULTS_DIR = os.path.join(BASE_DIR, 'results')
INPUT_CSV = os.path.join(RESULTS_DIR, 'summary_trad_type2.csv')
CORR_PLOT = os.path.join(RESULTS_DIR, 'correlation_heatmap.png')
SCALABILITY_PLOTS_DIR = os.path.join(RESULTS_DIR, 'scalability_plots')
CORR_CSV = os.path.join(RESULTS_DIR, 'correlation_matrix.csv')

os.makedirs(SCALABILITY_PLOTS_DIR, exist_ok=True)

# === Load data ===
df = pd.read_csv(INPUT_CSV)
df['scenario'] = df['scenario'].astype(int)

# === Estilo global ===
sns.set_context("paper", font_scale=1.4)
sns.set_style("whitegrid")
plt.rcParams["font.family"] = "sans-serif"
plt.rcParams["font.sans-serif"] = ["DejaVu Sans", "Arial"]

# === Etiquetas con unidades para paper ===
label_map = {
    'messages_received_unique': 'Messages Received (count)',
    'pdr_ratio_beacon': 'PDR Ratio (%)',
    'dissemination_time_beacon': 'Dissemination Time (s)',
    'dissemination_distance_beacon': 'Dissemination Distance (m)',
    'norm_mac_load_beacon': 'Normalized MAC Load',
    'cbr_avg': 'Average CBR (0-1)',
    'cbr_max': 'Maximum CBR (0-1)',
    'avg_timeLoss': 'Average Time Loss (s)',
    'avg_waitingTime': 'Average Waiting Time (s)',
    'avg_duration': 'Average Duration (s)',
    'completed_trips': 'Completed Trips (count)',
}

# === Scalability plots ===
metrics = list(label_map.keys())

for metric in metrics:
    if metric in df.columns:
        fig, ax = plt.subplots(figsize=(8, 5))
        sns.lineplot(
            x='total_nodes', y=metric, data=df,
            marker='o', linewidth=2.5, markersize=8, ax=ax
        )
        ax.set_title(f'Scalability of {label_map[metric]}', fontsize=15)
        ax.set_xlabel('Total Vehicles', fontsize=13)
        ax.set_ylabel(label_map[metric], fontsize=13)
        ax.xaxis.set_major_locator(MaxNLocator(integer=True))
        ax.yaxis.set_major_locator(MaxNLocator(nbins='auto'))
        plt.tight_layout()
        fig.savefig(
            os.path.join(SCALABILITY_PLOTS_DIR, f'{metric}_scalability.png'),
            dpi=300, bbox_inches='tight'
        )
        plt.close(fig)

# === Correlation matrix ===
corr_cols = [
    'pdr_ratio_beacon', 'dissemination_time_beacon', 'dissemination_distance_beacon',
    'norm_mac_load_beacon', 'cbr_avg',
    'avg_timeLoss', 'avg_duration', 'avg_waitingTime'
]
available = [c for c in corr_cols if c in df.columns]
corr = df[available].corr(method='pearson')
corr.to_csv(CORR_CSV)

# === Heatmap
fig, ax = plt.subplots(figsize=(10, 8))
sns.heatmap(
    corr, annot=True, cmap='coolwarm', fmt=".2f",
    linewidths=0.6, cbar_kws={'shrink': 0.8}, square=True, ax=ax
)
ax.set_title("Correlation Matrix: Traffic vs. Network Performance", fontsize=16)
plt.xticks(rotation=45, ha='right')
plt.yticks(rotation=0)
plt.tight_layout()
fig.savefig(CORR_PLOT, dpi=300, bbox_inches='tight')
plt.close(fig)

print("[✓] Analysis complete.")
print(f"📊 Correlation matrix saved to: {CORR_CSV}")
print(f"🔥 Heatmap saved to: {CORR_PLOT}")
print(f"📈 Scalability plots saved to: {SCALABILITY_PLOTS_DIR}")
