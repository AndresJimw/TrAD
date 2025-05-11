import os
import xml.etree.ElementTree as ET
import csv

densities = [40, 60, 80, 100, 120, 140, 160]
output_dir = "sumo/output"
csv_output = os.path.join(output_dir, "summary_tripinfo_type1.csv")

def analyze_tripinfo(file_path):
    tree = ET.parse(file_path)
    root = tree.getroot()

    trips = root.findall("tripinfo")
    total_trips = len(trips)
    total_duration = sum(float(t.get("duration", 0)) for t in trips)
    avg_duration = total_duration / total_trips if total_trips > 0 else 0

    return total_trips, avg_duration

with open(csv_output, mode="w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(["Density", "Trips", "Avg Duration"])

    for d in densities:
        xml_file = os.path.join(output_dir, f"tripinfo_type1_{d}.xml")
        if os.path.exists(xml_file):
            trips, avg_dur = analyze_tripinfo(xml_file)
            writer.writerow([d, trips, round(avg_dur, 2)])
        else:
            writer.writerow([d, "File not found", "N/A"])

print(f"[✅] Analysis complete. Results saved in: {csv_output}")
