import os

# Ruta al directorio de configuraciones
config_dir = r"D:\TrAD-Quito\sumo\config"

for file_name in os.listdir(config_dir):
    if file_name.startswith("simon_bolivar_type1_") and file_name.endswith(".sumocfg"):
        file_path = os.path.join(config_dir, file_name)

        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Buscar línea actual de additional-files
        original_line = '<additional-files value="..\\input\\roi_simon_bolivar.add.xml" />'
        corrected_line = '<additional-files value="..\\input\\vehicles.add.xml,..\\input\\roi_simon_bolivar.add.xml" />'

        if original_line in content:
            updated_content = content.replace(original_line, corrected_line)
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(updated_content)
            print(f"[✔] Corregido: {file_name}")
        else:
            print(f"[✓] Ya corregido o formato diferente: {file_name}")
