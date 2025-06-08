from sumolib import net
from shapely.geometry import Point, MultiPoint, mapping
import json

# Ruta al archivo .net.xml
net_file = r"D:\TrAD-Quito\sumo\input\simon_bolivar.net.xml"
output_geojson = r"D:\TrAD-Quito\sumo\output\convex_hull.geojson"

# Cargar red
network = net.readNet(net_file)

# Filtrar solo nodos que están conectados a edges
used_nodes = set()
for edge in network.getEdges():
    used_nodes.add(edge.getFromNode())
    used_nodes.add(edge.getToNode())

# Obtener coordenadas
node_coords = [node.getCoord() for node in used_nodes]
points = MultiPoint([Point(x, y) for x, y in node_coords])

# Calcular convex hull
convex_hull = points.convex_hull
area_km2 = convex_hull.area / 1_000_000

print(f"Área del convex hull de la red (solo nodos usados): {area_km2:.3f} km²")

# Guardar como GeoJSON
geojson_dict = {
    "type": "FeatureCollection",
    "features": [{
        "type": "Feature",
        "geometry": mapping(convex_hull),
        "properties": {
            "area_km2": round(area_km2, 3)
        }
    }]
}

with open(output_geojson, "w", encoding="utf-8") as f:
    json.dump(geojson_dict, f, indent=2)

print(f"Convex hull guardado como GeoJSON en: {output_geojson}")
