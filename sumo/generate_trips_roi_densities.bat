@echo off
REM Ejecuta generate_trips_roi.py con diferentes densidades para ROI (type1)
REM Asegúrate de tener Python y SUMO configurados

set PYTHON=python
set SCRIPT=D:\TrAD-Quito\sumo\scripts\generate_trips_roi.py

set NET=D:\TrAD-Quito\sumo\input\simon_bolivar.net.xml
set EDGES=D:\TrAD-Quito\sumo\input\roi_edges.txt
set INPUT_DIR=D:\TrAD-Quito\sumo\input

echo Generando trips ROI para distintas densidades...

%PYTHON% %SCRIPT% --vehicles 40 --output %INPUT_DIR%\simon_bolivar_roi_40.trips.xml --begin 0 --end 3600
%PYTHON% %SCRIPT% --vehicles 60 --output %INPUT_DIR%\simon_bolivar_roi_60.trips.xml --begin 0 --end 3600
%PYTHON% %SCRIPT% --vehicles 80 --output %INPUT_DIR%\simon_bolivar_roi_80.trips.xml --begin 0 --end 3600
%PYTHON% %SCRIPT% --vehicles 100 --output %INPUT_DIR%\simon_bolivar_roi_100.trips.xml --begin 0 --end 3600
%PYTHON% %SCRIPT% --vehicles 120 --output %INPUT_DIR%\simon_bolivar_roi_120.trips.xml --begin 0 --end 3600
%PYTHON% %SCRIPT% --vehicles 140 --output %INPUT_DIR%\simon_bolivar_roi_140.trips.xml --begin 0 --end 3600
%PYTHON% %SCRIPT% --vehicles 160 --output %INPUT_DIR%\simon_bolivar_roi_160.trips.xml --begin 0 --end 3600

echo Finalizado.
pause
