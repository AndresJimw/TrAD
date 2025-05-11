import os
import random
import xml.etree.ElementTree as ET
import sys

# Agregar path de sumolib (usando el directorio donde sí está)
sys.path.append(r"D:\sumo-1.18.0\tools")

from sumolib.net import readNet

# === Parámetros configurables ===
NET_FILE = r"D:\TrAD-Quito\sumo\input\simon_bolivar.net.xml"
ROI_EDGES_FILE = r"D:\TrAD-Quito\sumo\input\roi_edges.txt"
OUTPUT_TRIPS_FILE = r"D:\TrAD-Quito\sumo\input\simon_bolivar_roi.trips.xml"
NUMBER_OF_VEHICLES = 500
BEGIN_TIME = 0
END_TIME = 300
TYPE = "veh_passenger"

# Leer edges del ROI
with open(ROI_EDGES_FILE, 'r') as f:
    raw_edges = [line.strip() for line in f if line.strip()]
if not raw_edges:
    raise Exception("❌ El archivo roi_edges.txt está vacío.")

# Cargar red
print("✅ Cargando red SUMO...")
net = readNet(NET_FILE)

# Validar edges que existan y sean usables (saltando errores de lanes o restricciones extrañas)
# Validar edges que existan, no sean especiales y tengan carriles válidos
# Validar edges que existan y sean usables
print("🔍 Validando edges del ROI...")
roi_edges = []
for edge_id in raw_edges:
    try:
        edge = net.getEdge(edge_id)
        if edge.isSpecial():
            print(f"⛔ Edge especial: {edge_id}")
            continue
        if edge.getLaneNumber() == 0:
            print(f"⛔ Sin carriles: {edge_id}")
            continue

        lanes = edge.getLanes()
        is_valid = False
        for lane in lanes:
            allow = getattr(lane, 'allow', '')  # puede ser cadena vacía
            if not allow or 'passenger' in allow:
                is_valid = True
                break

        if is_valid:
            roi_edges.append(edge_id)
        else:
            print(f"⛔ Edge no válido (no permite passenger): {edge_id}")

    except Exception as e:
        print(f"⛔ Error accediendo a edge {edge_id}: {e}")



if not roi_edges:
    raise Exception("❌ Ningún edge del ROI es utilizable en la red.")

# Generar trips válidos
print("🚗 Generando trips válidos...")
valid_trips = []
attempts = 0
max_attempts = NUMBER_OF_VEHICLES * 10

while len(valid_trips) < NUMBER_OF_VEHICLES and attempts < max_attempts:
    from_edge = to_edge = random.choice(roi_edges)
    while to_edge == from_edge:
        to_edge = random.choice(roi_edges)
    try:
        path, _ = net.getShortestPath(net.getEdge(from_edge), net.getEdge(to_edge))
        if path and len(path) > 1:
            valid_trips.append((from_edge, to_edge))
    except Exception:
        pass
    attempts += 1

if not valid_trips:
    raise Exception("❌ No se pudieron generar rutas válidas.")

# Guardar trips
interval = (END_TIME - BEGIN_TIME) / len(valid_trips)
root = ET.Element('trips')
for i, (from_edge, to_edge) in enumerate(valid_trips):
    depart_time = round(BEGIN_TIME + i * interval, 2)
    ET.SubElement(root, 'trip', {
        'id': f'roi_trip_{i}',
        'type': TYPE,
        'depart': str(depart_time),
        'from': from_edge,
        'to': to_edge
    })

tree = ET.ElementTree(root)
tree.write(OUTPUT_TRIPS_FILE, encoding='UTF-8', xml_declaration=True)

print(f"✅ Generado {len(valid_trips)} trips válidos.")
print(f"📄 Guardado en: {OUTPUT_TRIPS_FILE}")
