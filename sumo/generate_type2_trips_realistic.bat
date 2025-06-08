@echo off
setlocal enabledelayedexpansion

REM ==============================================================
REM GENERA TRIPS TYPE 2 REALISTAS USANDO INSERTION DENSITY AJUSTADA
REM PARA SIMULAR CARGA VEHICULAR DE ESCENARIOS TYPE 1
REM AHORA CON 10 ESCENARIOS: 1000 A 10000 VEHÍCULOS
REM ==============================================================

set PYTHON=python
set SUMO_TOOLS=D:\sumo-1.18.0\tools
set SCRIPT=%SUMO_TOOLS%\randomTrips.py
set NET=D:\TrAD-Quito\sumo\input\simon_bolivar.net.xml
set OUTPUT_DIR=D:\TrAD-Quito\sumo\input
set DURATION=3600
set SEED=42

echo.
echo Area de red: 28.01 km2
echo Duracion: %DURATION% segundos
echo Semilla fija: %SEED%
echo.

REM Densidades ajustadas para 1000–10000 vehículos (empírico/interpolado)
for %%D in (3 6 9 12 15 18 21 24 27 30) do (
    if %%D==3  set NAME=1000
    if %%D==6  set NAME=2000
    if %%D==9  set NAME=3000
    if %%D==12 set NAME=4000
    if %%D==15 set NAME=5000
    if %%D==18 set NAME=6000
    if %%D==21 set NAME=7000
    if %%D==24 set NAME=8000
    if %%D==27 set NAME=9000
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
echo Generacion de todos los trips type 2 completada.
pause
