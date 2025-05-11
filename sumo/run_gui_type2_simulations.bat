@echo off
setlocal enabledelayedexpansion

REM Ruta a SUMO-GUI
set SUMO_GUI="D:\sumo-1.18.0\bin\sumo-gui.exe"

REM Directorio donde están los archivos .sumocfg
set CONFIG_DIR=config

REM Densidades a simular
set DENSITIES=40 60 80 100 120 140 160

echo Iniciando simulaciones en SUMO-GUI para rutas tipo 2...

for %%D in (%DENSITIES%) do (
    echo.
    echo ▶ Simulación tipo 2 con densidad %%D...
    start "" %SUMO_GUI% -c %CONFIG_DIR%\simon_bolivar_type2_%%D.sumocfg
    timeout /t 2 >nul
)

echo.
echo Todas las simulaciones fueron lanzadas en SUMO-GUI.
endlocal
pause
