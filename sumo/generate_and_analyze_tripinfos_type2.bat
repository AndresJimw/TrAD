@echo off
setlocal enabledelayedexpansion

REM ================================
REM Ejecuta simulaciones SUMO y analiza resultados
REM ================================
set SUMO=D:\sumo-1.18.0\bin\sumo.exe
set CONFIG_DIR=config
set OUTPUT_DIR=output
set PYTHON=python
set ANALYSIS_SCRIPT=scripts\analyze_tripinfo_type2.py

echo Generando archivos tripinfo_type2_XXXX.xml...

%SUMO% -c %CONFIG_DIR%\simon_bolivar_type2_1000.sumocfg --summary-output %OUTPUT_DIR%\tripinfo_type2_1000.xml
%SUMO% -c %CONFIG_DIR%\simon_bolivar_type2_3000.sumocfg --summary-output %OUTPUT_DIR%\tripinfo_type2_3000.xml
%SUMO% -c %CONFIG_DIR%\simon_bolivar_type2_6000.sumocfg --summary-output %OUTPUT_DIR%\tripinfo_type2_6000.xml
%SUMO% -c %CONFIG_DIR%\simon_bolivar_type2_10000.sumocfg --summary-output %OUTPUT_DIR%\tripinfo_type2_10000.xml

echo.
echo Simulaciones completadas. Iniciando análisis con Python...

%PYTHON% %ANALYSIS_SCRIPT%

echo.
echo Proceso terminado. Revisa los resultados en la carpeta output.
pause
