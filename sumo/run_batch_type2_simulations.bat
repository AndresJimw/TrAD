@echo off
setlocal enabledelayedexpansion

REM ==========================================================
REM EJECUTOR POR LOTES DE SIMULACIONES TYPE 2 (MODO CONSOLA)
REM Ejecuta todas las simulaciones type 2 por número de vehículos
REM Salida: tripinfo_type2_%%D.xml en la carpeta /output
REM ==========================================================

set PROJECT_ROOT=D:\TrAD-Quito
set CONFIG_DIR=%PROJECT_ROOT%\sumo\config
set OUTPUT_DIR=%PROJECT_ROOT%\sumo\output
set SUMO=sumo

REM Números aproximados de vehículos en toda la red
set VEHICLE_COUNTS=1000 3000 6000 10000

cd /d %CONFIG_DIR%

for %%D in (%VEHICLE_COUNTS%) do (
    echo.
    echo ================================
    echo Ejecutando simulación TYPE 2 - %%D vehiculos...
    echo ================================

    set CFG_FILE=simon_bolivar_type2_%%D.sumocfg

    if exist !CFG_FILE! (
        %SUMO% -c !CFG_FILE!
        echo Simulación completada: %%D vehiculos
    ) else (
        echo Error: No se encontró el archivo !CFG_FILE!
    )
)

echo.
echo Todas las simulaciones TYPE 2 por lotes han finalizado.
pause
