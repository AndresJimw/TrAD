import xml.etree.ElementTree as ET
import os

input_dir = r"D:\TrAD-Quito\sumo\input"

# Cargar edges prohibidos (ROI)
with open(os.path.join(input_dir, "roi_edges.txt"), "r") as f:
    roi_edges = set(line.strip() for line in f if line.strip())

for density in [40, 60, 80, 100, 120, 140, 160]:
    input_file = os.path.join(input_dir, f"simon_bolivar_type2_{density}_filtered.rou.xml")
    output_file = os.path.join(input_dir, f"simon_bolivar_type2_{density}_final.rou.xml")

    tree = ET.parse(input_file)
    root = tree.getroot()

    routes = root.findall("vehicle")
    total = len(routes)
    removed = 0

    for vehicle in routes:
        route = vehicle.find("route")
        if route is None:
            continue
        edges = route.attrib.get("edges", "").split()
        if any(edge in roi_edges for edge in edges):
            root.remove(vehicle)
            removed += 1

    tree.write(output_file, encoding="UTF-8")
    print(f"[{density}] Guardado: {output_file} - {total - removed}/{total} rutas válidas")
