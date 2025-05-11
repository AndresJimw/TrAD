@echo off
setlocal enabledelayedexpansion

REM Directorios base
set INPUT_DIR=input
set CONFIG_DIR=config
set TOOLS_DIR=D:\sumo-1.18.0\tools

REM Densidades a procesar
set DENSITIES=40 60 80 100 120 140 160

echo Generando archivos .sumocfg para rutas tipo 2...

for %%D in (%DENSITIES%) do (
    echo.
    echo ============================
    echo Generando configuración para densidad %%D...
    echo ============================

    REM Definir nombres de archivo directamente en línea sin set
    echo 🔄 Generando viajes para densidad %%D...
    python "!TOOLS_DIR!\randomTrips.py" ^
        -n "%INPUT_DIR%\simon_bolivar.net.xml" ^
        -o "%INPUT_DIR%\simon_bolivar_type2_%%D.trips.xml" ^
        --prefix type2_%%D ^
        --trip-attributes "departLane='best' departSpeed='max' departPos='random'" ^
        --validate ^
        --fringe-factor 3 ^
        --insertion-density %%D ^
        --seed %%D

    echo 🛣️ Convirtiendo trips a rutas...
    duarouter -n "%INPUT_DIR%\simon_bolivar.net.xml" ^
              -r "%INPUT_DIR%\simon_bolivar_type2_%%D.trips.xml" ^
              -o "%INPUT_DIR%\simon_bolivar_type2_%%D.rou.xml"

    echo 📄 Creando archivo de configuración .sumocfg...
    (
        echo ^<configuration^>
        echo     ^<input^>
        echo         ^<net-file value="..\%INPUT_DIR%\simon_bolivar.net.xml"/^>
        echo         ^<route-files value="..\%INPUT_DIR%\simon_bolivar_type2_%%D.rou.xml"/^>
        echo         ^<additional-files value="..\%INPUT_DIR%\roi_simon_bolivar.add.xml,..\%INPUT_DIR%\source_node.add.xml"/^>
        echo     ^</input^>
        echo     ^<time^>
        echo         ^<begin value="0"/^>
        echo         ^<end value="3600"/^>
        echo     ^</time^>
        echo ^</configuration^>
    ) > "%CONFIG_DIR%\simon_bolivar_type2_%%D.sumocfg"

    echo ✔️ Densidad %%D procesada.
)

echo.
echo ✅ Todos los archivos .sumocfg tipo 2 han sido generados correctamente.
endlocal
pause
