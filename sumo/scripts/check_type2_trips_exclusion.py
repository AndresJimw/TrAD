import os
import xml.etree.ElementTree as ET

# Rutas del proyecto
input_dir = r"D:\TrAD-Quito\sumo\input"
excluded_edges_file = os.path.join(input_dir, "roi_excluded_edges.txt")

# Leer edges que deben ser excluidos
with open(excluded_edges_file, "r") as f:
    excluded_edges = set(line.strip() for line in f if line.strip())

# Revisar cada archivo .trips.xml tipo 2
for density in [40, 60, 80, 100, 120, 140, 160]:
    trip_file = os.path.join(input_dir, f"simon_bolivar_type2_{density}.trips.xml")
    print(f"\nVerificando densidad {density}...")

    if not os.path.exists(trip_file):
        print(f"[ERROR] No existe {trip_file}")
        continue

    tree = ET.parse(trip_file)
    root = tree.getroot()
    conflict_found = False

    for trip in root.findall("trip"):
        from_edge = trip.get("from")
        to_edge = trip.get("to")
        if from_edge in excluded_edges or to_edge in excluded_edges:
            print(f"[CONFLICTO] Trip {trip.get('id')} usa edge prohibido: from={from_edge}, to={to_edge}")
            conflict_found = True

    if not conflict_found:
        print("✔ No se encontraron trips con edges del ROI.")
