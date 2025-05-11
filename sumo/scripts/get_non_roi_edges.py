import os
import sys
sys.path.append(r"D:\sumo-1.18.0\tools")

from sumolib.net import readNet

# Rutas
net_path = r"D:\TrAD-Quito\sumo\input\simon_bolivar.net.xml"
roi_edges_path = r"D:\TrAD-Quito\sumo\input\roi_edges.txt"
output_path = r"D:\TrAD-Quito\sumo\input\roi_excluded_edges.txt"

# Cargar red
net = readNet(net_path)

# Leer edges del ROI
with open(roi_edges_path, "r") as f:
    roi_edges = set(line.strip() for line in f)

# Obtener todos los edges
all_edges = set(edge.getID() for edge in net.getEdges())

# Filtrar los que no están en el ROI
excluded_edges = all_edges - roi_edges

# Guardar en archivo
with open(output_path, "w") as f:
    for edge_id in sorted(excluded_edges):
        f.write(edge_id + "\n")

print(f"✅ Generado archivo con {len(excluded_edges)} edges fuera del ROI.")
print(f"📄 Guardado en: {output_path}")
