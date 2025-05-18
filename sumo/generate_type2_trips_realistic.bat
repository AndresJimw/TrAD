@echo off
setlocal enabledelayedexpansion

REM ==============================================================
REM GENERA TRIPS TYPE 2 REALISTAS USANDO INSERTION DENSITY AJUSTADA
REM PARA SIMULAR MISMA CARGA VEHICULAR QUE LOS ESCENARIOS TYPE 1
REM ==============================================================

set PYTHON=python
set SUMO_TOOLS=D:\sumo-1.18.0\tools
set SCRIPT=%SUMO_TOOLS%\randomTrips.py
set NET=D:\TrAD-Quito\sumo\input\simon_bolivar.net.xml
set OUTPUT_DIR=D:\TrAD-Quito\sumo\input
set DURATION=3600
set SEED=42

echo.
echo Area de red: 40.19 km2
echo Duracion: %DURATION% segundos
echo Semilla fija: %SEED%
echo.

REM Densidades reales usadas para simular magnitudes equivalentes a las nominales
for %%D in (3 9 18 30) do (
    if %%D==3  set NAME=1000
    if %%D==9  set NAME=3000
    if %%D==18 set NAME=6000
    if %%D==30 set NAME=10000

    echo Generando trips_type2_!NAME!.trips.xml con densidad ajustada %%D veh/km2...

    %PYTHON% "%SCRIPT%" ^
        -n "%NET%" ^
        -o "%OUTPUT_DIR%\trips_type2_!NAME!.trips.xml" ^
        --insertion-density %%D ^
        --fringe-factor 3 ^
        --validate ^
        --seed %SEED% ^
        -b 0 -e %DURATION%
)

echo.
echo Generacion de trips type 2 completada.
pause
