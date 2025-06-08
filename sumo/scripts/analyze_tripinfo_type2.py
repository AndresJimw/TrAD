import os
import xml.etree.ElementTree as ET
import pandas as pd

# Directorio base
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
OUTPUT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'sumo', 'output'))
OUTPUT_CSV = os.path.join(OUTPUT_DIR, 'summary_tripinfo_type2.csv')

# Buscar archivos válidos
tripinfo_files = sorted([
    f for f in os.listdir(OUTPUT_DIR)
    if f.startswith('tripinfo_type2_') and f.endswith('.xml') and f.replace('tripinfo_type2_', '').replace('.xml', '').isdigit()
])

datos = []

for file in tripinfo_files:
    path = os.path.join(OUTPUT_DIR, file)
    
    try:
        tree = ET.parse(path)
        root = tree.getroot()
    except ET.ParseError as e:
        print(f"[ERROR] No se pudo parsear {file}: {e}")
        continue

    durations = []
    route_lengths = []
    waiting_times = []
    time_losses = []

    for trip in root.findall('tripinfo'):
        try:
            durations.append(float(trip.attrib['duration']))
            route_lengths.append(float(trip.attrib['routeLength']))
            waiting_times.append(float(trip.attrib['waitingTime']))
            time_losses.append(float(trip.attrib['timeLoss']))
        except KeyError as e:
            print(f"[WARN] Atributo faltante en {file}: {e}")
            continue

    if durations:
        datos.append({
            'file': file,
            'completed_trips': len(durations),
            'avg_duration': round(sum(durations) / len(durations), 2),
            'avg_routeLength': round(sum(route_lengths) / len(route_lengths), 2),
            'avg_waitingTime': round(sum(waiting_times) / len(waiting_times), 2),
            'avg_timeLoss': round(sum(time_losses) / len(time_losses), 2),
        })
    else:
        print(f"[INFO] No se encontraron viajes en {file}")

# Exportar CSV si hay datos
if datos:
    df = pd.DataFrame(datos)
    df.sort_values('file', inplace=True)
    df.to_csv(OUTPUT_CSV, index=False)
    print(f"Resumen generado correctamente en: {OUTPUT_CSV}")
else:
    print("No se generó resumen. No hay datos válidos.")
