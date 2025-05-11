import xml.etree.ElementTree as ET
from shapely.geometry import Polygon, LineString

# === Paths ===
edge_file = r"D:\TrAD-Quito\sumo\input\simon_bolivar_plain.edg.xml"
roi_file = r"D:\TrAD-Quito\sumo\input\roi_simon_bolivar.add.xml"
output_file = r"D:\TrAD-Quito\sumo\input\roi_edges.txt"

# === Leer el polígono del ROI ===
roi_tree = ET.parse(roi_file)
roi_root = roi_tree.getroot()
roi_polygons = []

for poly in roi_root.findall(".//poly"):
    shape = poly.get("shape")
    if shape:
        points = [tuple(map(float, p.split(","))) for p in shape.strip().split()]
        roi_polygons.append(Polygon(points))

if not roi_polygons:
    raise ValueError("No se encontró ningún polígono válido en el archivo ROI.")

# === Leer los edges y comparar ===
edge_tree = ET.parse(edge_file)
edge_root = edge_tree.getroot()
edges_inside_roi = []
total_checked = 0

for edge in edge_root.findall("edge"):
    edge_id = edge.get("id")
    if edge_id.startswith(":"):
        continue  # omitir conexiones internas
    shape = edge.get("shape")
    if not shape:
        continue
    total_checked += 1
    points = [tuple(map(float, p.split(","))) for p in shape.strip().split()]
    line = LineString(points)

    for roi in roi_polygons:
        if line.intersects(roi):
            edges_inside_roi.append(edge_id)
            break

# === Guardar resultado ===
with open(output_file, "w") as f:
    for eid in edges_inside_roi:
        f.write(f"{eid}\n")

print(f"ROI definido con {len(roi_polygons)} polígono(s).")
print(f"Total de edges revisados: {total_checked}")
print(f"Total de edges dentro del ROI: {len(edges_inside_roi)}")
print(f"Archivo guardado en: {output_file}")
