@echo off
cd /d D:\TrAD-Quito\sumo
echo Iniciando simulaciones visuales con sumo-gui...

for %%D in (40 60 80 100 120 140 160) do (
    echo 🔍 Ejecutando simulación para densidad %%D...
    "%SUMO_HOME%\bin\sumo-gui.exe" -c config\simon_bolivar_%%D.sumocfg
)

echo Todas las simulaciones fueron ejecutadas.
pause
