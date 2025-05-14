@echo off
REM ==========================================
REM GENERADOR DE TRIPS TYPE 1 (DENTRO DEL ROI)
REM Densidades: 500–5000 veh/km²
REM Salida: trips_type1_<densidad>.trips.xml
REM ==========================================

set PYTHON=python
set SCRIPT=D:\TrAD-Quito\sumo\scripts\generate_trips_roi.py
set OUTPUT_DIR=D:\TrAD-Quito\sumo\input

for %%D in (500 1000 2500 5000) do (
    echo -----------------------------------------
    echo Generando trips para densidad %%D veh/km2...
    %PYTHON% %SCRIPT% --density %%D --output %OUTPUT_DIR%\trips_type1_%%D.trips.xml
)
echo -----------------------------------------
echo Todos los trips fueron generados.
pause
