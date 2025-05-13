import xml.etree.ElementTree as ET
import os

input_dir = r"D:\TrAD-Quito\sumo\input"

with open(os.path.join(input_dir, "roi_edges.txt"), "r") as f:
    roi_edges = set(line.strip() for line in f if line.strip())

for density in [40, 60, 80, 100, 120, 140, 160]:
    input_file = os.path.join(input_dir, f"simon_bolivar_type2_{density}_filtered.trips.xml")
    if not os.path.exists(input_file):
        continue

    tree = ET.parse(input_file)
    root = tree.getroot()

    total = 0
    conflicts = 0
    for trip in root.findall("trip"):
        total += 1
        if trip.attrib["from"] in roi_edges or trip.attrib["to"] in roi_edges:
            conflicts += 1
            if conflicts <= 5:
                print(f"[CONFLICTO] {trip.attrib['id']} usa edge prohibido: from={trip.attrib['from']}, to={trip.attrib['to']}")

    print(f"[{density}] {total - conflicts}/{total} viajes sin conflicto")
