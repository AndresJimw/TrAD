import xml.etree.ElementTree as ET
import os

input_dir = r"D:\TrAD-Quito\sumo\input"
roi_file = os.path.join(input_dir, "roi_edges.txt")

# Leer edges prohibidos
with open(roi_file, "r") as f:
    roi_edges = set(line.strip() for line in f if line.strip())

# Densidades usadas
densities = [500, 1000, 2500, 5000]

for density in densities:
    input_file = os.path.join(input_dir, f"routes_type2_{density}.rou.xml")
    output_file = os.path.join(input_dir, f"routes_type2_{density}_filtered.rou.xml")

    tree = ET.parse(input_file)
    root = tree.getroot()

    total = 0
    removed = 0

    for vehicle in list(root.findall("vehicle")):
        total += 1
        route = vehicle.find("route")

        # Soporte para routeDistribution
        if route is None:
            rd = vehicle.find("routeDistribution")
            if rd is not None:
                route = rd.find("route")

        if route is not None:
            edges = route.get("edges", "").split()
            if any(e in roi_edges for e in edges):
                root.remove(vehicle)
                removed += 1

    tree.write(output_file, encoding="UTF-8", xml_declaration=True)
    print(f"[{density}] Guardado: {output_file} - {total - removed}/{total} rutas válidas")
