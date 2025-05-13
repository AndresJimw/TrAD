import os

config_dir = r"D:\TrAD-Quito\sumo\config"

for file_name in os.listdir(config_dir):
    if file_name.endswith(".bak"):
        file_path = os.path.join(config_dir, file_name)
        os.remove(file_path)
        print(f"[🗑️] Eliminado: {file_name}")
