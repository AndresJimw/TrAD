import os
import pandas as pd
import matplotlib.pyplot as plt

# Ruta al archivo combinado
FILE = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'results', 'summary_trad_vs_mobility.csv'))
df = pd.read_csv(FILE)

# Asegúrate de que scenario sea numérico para ordenarlo bien
df["scenario"] = df["scenario"].astype(int)
df = df.sort_values("scenario")

# Ejemplo: comparar PDR con avg_timeLoss
plt.figure()
plt.plot(df["scenario"], df["pdr_ratio_beacon"], label="PDR (beacon)")
plt.plot(df["scenario"], df["avg_timeLoss"], label="Avg Time Loss", linestyle='--')
plt.xlabel("Scenario Size (vehicles)")
plt.legend()
plt.title("PDR vs Avg Time Loss")
plt.grid(True)
plt.tight_layout()
plt.show()
