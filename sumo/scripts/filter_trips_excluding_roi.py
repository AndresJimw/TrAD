import xml.etree.ElementTree as ET
import os

# Ruta base del proyecto
input_dir = r"D:\TrAD-Quito\sumo\input"

# Cargar lista de edges prohibidos (ROI)
with open(os.path.join(input_dir, "roi_edges.txt"), "r") as f:
    excluded_edges = set(line.strip() for line in f if line.strip())

# Buscar todos los .trips.xml tipo 2
for density in [40, 60, 80, 100, 120, 140, 160]:
    input_file = os.path.join(input_dir, f"simon_bolivar_type2_{density}.trips.xml")
    output_file = os.path.join(input_dir, f"simon_bolivar_type2_{density}_filtered.trips.xml")

    tree = ET.parse(input_file)
    root = tree.getroot()

    trips = root.findall("trip")
    total = len(trips)
    removed = 0

    for trip in trips:
        if trip.attrib["from"] in excluded_edges or trip.attrib["to"] in excluded_edges:
            root.remove(trip)
            removed += 1

    tree.write(output_file, encoding="UTF-8")
    print(f"[{density}] Guardado: {output_file} - {total-removed}/{total} viajes válidos")
