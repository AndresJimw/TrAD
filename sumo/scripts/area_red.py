from sumolib import net

# Ruta al archivo .net.xml
net_file = r"D:\TrAD-Quito\sumo\input\simon_bolivar.net.xml"

# Cargar red
network = net.readNet(net_file)

# Desempacar bounding box correctamente
(minX, minY), (maxX, maxY) = network.getBBoxXY()

# Calcular área (en m² y luego km²)
area_m2 = (maxX - minX) * (maxY - minY)
area_km2 = area_m2 / 1_000_000

print(f"Area estimada de la red: {area_km2:.3f} km2")
