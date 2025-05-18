import os
import random
import xml.etree.ElementTree as ET
import sys
import argparse
import xml.dom.minidom

# Agregar path de sumolib
sys.path.append(r"D:\sumo-1.18.0\tools")
from sumolib.net import readNet

# Argumentos
parser = argparse.ArgumentParser()
parser.add_argument("--vehicles", type=int, help="Cantidad de vehículos a generar (prioridad sobre density)")
parser.add_argument("--density", type=float, help="Densidad en vehículos por km2 (veh/km2)")
parser.add_argument("--output", type=str, default=r"D:\TrAD-Quito\sumo\input\simon_bolivar_roi.trips.xml", help="Ruta del archivo .trips.xml de salida")
parser.add_argument("--begin", type=int, default=0, help="Tiempo de inicio de simulación (segundos)")
parser.add_argument("--end", type=int, default=3600, help="Tiempo de fin de simulación (segundos)")
args = parser.parse_args()

# Parámetros base
NET_FILE = r"D:\TrAD-Quito\sumo\input\simon_bolivar.net.xml"
ROI_EDGES_FILE = r"D:\TrAD-Quito\sumo\input\roi_edges.txt"
OUTPUT_TRIPS_FILE = args.output
BEGIN_TIME = args.begin
END_TIME = args.end
TYPE = "veh_passenger"
ROI_AREA_KM2 = 0.083

# Determinar número de vehículos
if args.vehicles is not None:
    NUMBER_OF_VEHICLES = args.vehicles
elif args.density is not None:
    NUMBER_OF_VEHICLES = int(args.density * ROI_AREA_KM2)
    print(f"Usando densidad de {args.density} veh/km² en área {ROI_AREA_KM2} km² → {NUMBER_OF_VEHICLES} vehículos")
else:
    NUMBER_OF_VEHICLES = 500 
    print(f"Usando valor por defecto: {NUMBER_OF_VEHICLES} vehículos")

# Leer edges del ROI
with open(ROI_EDGES_FILE, 'r') as f:
    raw_edges = [line.strip() for line in f if line.strip()]
if not raw_edges:
    raise Exception("El archivo roi_edges.txt está vacío.")

# Cargar red
print("Cargando red SUMO...")
net = readNet(NET_FILE)

# Validar edges del ROI
print("Validando edges del ROI...")
roi_edges = []
for edge_id in raw_edges:
    try:
        edge = net.getEdge(edge_id)
        if edge.isSpecial():
            print(f"Edge especial omitido: {edge_id}")
            continue
        if edge.getLaneNumber() == 0:
            print(f"Edge sin carriles omitido: {edge_id}")
            continue

        lanes = edge.getLanes()
        is_valid = False
        for lane in lanes:
            allow = getattr(lane, 'allow', '')
            if not allow or 'passenger' in allow:
                is_valid = True
                break

        if is_valid:
            roi_edges.append(edge_id)
        else:
            print(f"Edge omitido (no permite passenger): {edge_id}")

    except Exception as e:
        print(f"Error accediendo a edge {edge_id}: {e}")

if not roi_edges:
    raise Exception("Ningún edge del ROI es utilizable en la red.")

# Generar trips válidos
print("Generando trips válidos...")
valid_trips = []
attempts = 0
max_attempts = NUMBER_OF_VEHICLES * 50

print(f"Intentando generar {NUMBER_OF_VEHICLES} trips válidos... (máx. {max_attempts} intentos)")

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

if len(valid_trips) < NUMBER_OF_VEHICLES:
    print(f"[ADVERTENCIA] Solo se pudieron generar {len(valid_trips)} trips de los {NUMBER_OF_VEHICLES} requeridos.")
else:
    print(f"Se generaron correctamente los {len(valid_trips)} trips requeridos.")

if len(valid_trips) == 0:
    raise Exception("No se generaron trips válidos. No se puede construir el archivo .trips.xml.")

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

rough_string = ET.tostring(root, 'utf-8')
reparsed = xml.dom.minidom.parseString(rough_string)
pretty_xml = reparsed.toprettyxml(indent="  ")

with open(OUTPUT_TRIPS_FILE, "w", encoding="utf-8") as f:
    f.write(pretty_xml)

print(f"Total edges válidos en el ROI: {len(roi_edges)}")
print(f"Generado {len(valid_trips)} trips válidos.")
print(f"Guardado en: {OUTPUT_TRIPS_FILE}")
