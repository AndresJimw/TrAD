@echo off
setlocal enabledelayedexpansion

REM ==========================================================
REM EJECUTOR POR LOTES DE SIMULACIONES TYPE 1 (MODO CONSOLA)
REM Ejecuta todas las simulaciones type 1 por cantidad vehicular
REM Salida: tripinfo_type1_%%D.xml en la carpeta /output
REM ==========================================================

set PROJECT_ROOT=D:\TrAD-Quito
set CONFIG_DIR=%PROJECT_ROOT%\sumo\config
set OUTPUT_DIR=%PROJECT_ROOT%\sumo\output
set SUMO=sumo

REM Vehículos aproximados en el ROI
set VEHICLE_COUNTS=83 250 500 830

cd /d %CONFIG_DIR%

for %%D in (%VEHICLE_COUNTS%) do (
    echo.
    echo ================================
    echo Ejecutando simulación TYPE 1 - %%D vehiculos...
    echo ================================

    set CFG_FILE=simon_bolivar_type1_%%D.sumocfg

    if exist !CFG_FILE! (
        %SUMO% -c !CFG_FILE!
        echo Simulación completada: %%D vehiculos
    ) else (
        echo Error: No se encontró el archivo !CFG_FILE!
    )
)

echo.
echo Todas las simulaciones TYPE 1 por lotes han finalizado.
pause
