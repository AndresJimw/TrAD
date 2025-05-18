@echo off
setlocal enabledelayedexpansion

REM ==========================================
REM GENERADOR DE TRIPS TYPE 1 (DENTRO DEL ROI)
REM Densidades: 1000–10000 veh/km²
REM Salida: trips_type1_<vehiculos_aprox>.trips.xml
REM ==========================================

set PYTHON=python
set SCRIPT=D:\TrAD-Quito\sumo\scripts\generate_trips_roi.py
set OUTPUT_DIR=D:\TrAD-Quito\sumo\input

for %%D in (1000 3000 6000 10000) do (
    set "NAME="

    if %%D==1000  set NAME=83
    if %%D==3000  set NAME=250
    if %%D==6000  set NAME=500
    if %%D==10000 set NAME=830

    REM Reexpandir NAME
    setlocal enabledelayedexpansion
    echo Generando trips_type1_!NAME!.trips.xml con densidad %%D veh/km2...
    %PYTHON% %SCRIPT% --density %%D --output %OUTPUT_DIR%\trips_type1_!NAME!.trips.xml
    endlocal
)

echo -----------------------------------------
echo Todos los trips fueron generados.
pause
