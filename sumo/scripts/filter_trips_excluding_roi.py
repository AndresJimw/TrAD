import xml.etree.ElementTree as ET
import os

# Ruta base del proyecto
input_dir = r"D:\TrAD-Quito\sumo\input"
roi_edges_file = os.path.join(input_dir, "roi_edges.txt")

# Cargar lista de edges del ROI
with open(roi_edges_file, "r", encoding="utf-8") as f:
    excluded_edges = set(line.strip() for line in f if line.strip())

# Densidades realistas
densities = [500, 1000, 2500, 5000]

for density in densities:
    input_file = os.path.join(input_dir, f"trips_type2_{density}.trips.xml")
    output_file = os.path.join(input_dir, f"trips_type2_{density}_filtered.trips.xml")

    if not os.path.exists(input_file):
        print(f"[{density}] ERROR: No se encontró el archivo {input_file}")
        continue

    # Cargar XML y procesar trips
    tree = ET.parse(input_file)
    root = tree.getroot()

    trips = list(root.findall("trip"))
    total = len(trips)
    removed = 0

    for trip in trips:
        from_edge = trip.attrib.get("from", "")
        to_edge = trip.attrib.get("to", "")
        if from_edge in excluded_edges or to_edge in excluded_edges:
            root.remove(trip)
            removed += 1

    tree.write(output_file, encoding="UTF-8", xml_declaration=True)
    print(f"[{density}] Guardado: {output_file} - {total - removed}/{total} viajes válidos")
