import os

config_dir = r"D:\TrAD-Quito\sumo\config"

for file in os.listdir(config_dir):
    if file.endswith(".sumocfg"):
        path = os.path.join(config_dir, file)
        with open(path, "r", encoding="utf-8") as f:
            content = f.read()

        # Si hay una coma antes del source_node, la eliminamos también
        new_content = content.replace(
            ',..\\input\\source_node.add.xml', ''
        ).replace(
            ',../input/source_node.add.xml', ''
        ).replace(
            ',input/source_node.add.xml', ''
        ).replace(
            '..\\input\\source_node.add.xml', ''
        ).replace(
            '../input/source_node.add.xml', ''
        ).replace(
            'input/source_node.add.xml', ''
        )

        if new_content != content:
            with open(path, "w", encoding="utf-8") as f:
                f.write(new_content)
            print(f"[✔] Eliminada referencia en: {file}")
        else:
            print(f"[✓] Ya estaba limpio: {file}")
