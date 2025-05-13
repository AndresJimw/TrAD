@echo off
setlocal

set SUMO_GUI=sumo-gui
set CONFIG_DIR=D:\TrAD-Quito\sumo\config

echo Ejecutando simulaciones GUI tipo 2 filtradas...

for %%D in (40 60 80 100 120 140 160) do (
    echo.
    echo ===============================
    echo Ejecutando densidad %%D filtrada...
    echo ===============================
    %SUMO_GUI% -c "%CONFIG_DIR%\simon_bolivar_type2_%%D_filtered.sumocfg"
)

echo.
echo Simulaciones GUI tipo 2 filtradas completadas.
pause
