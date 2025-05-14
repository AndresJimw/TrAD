@echo off
setlocal

REM ================================================
REM LANZADOR INTERACTIVO DE SIMULACIONES TYPE 1 GUI
REM Permite elegir una densidad y lanza SUMO-GUI
REM ================================================

set CONFIG_DIR=D:\TrAD-Quito\sumo\config

echo Simulaciones disponibles para TYPE 1:
echo -------------------------------------
echo [1]  500 veh/km2
echo [2]  1000 veh/km2
echo [3]  2500 veh/km2
echo [4]  5000 veh/km2
echo.

set /p OPTION=Selecciona una opción (1-4): 

if "%OPTION%"=="1" set DENSITY=500
if "%OPTION%"=="2" set DENSITY=1000
if "%OPTION%"=="3" set DENSITY=2500
if "%OPTION%"=="4" set DENSITY=5000

if not defined DENSITY (
    echo Opción inválida. Cerrando...
    pause
    exit /b
)

set CFG_FILE=%CONFIG_DIR%\simon_bolivar_type1_%DENSITY%.sumocfg

if exist "%CFG_FILE%" (
    echo Abriendo simulación con densidad %DENSITY% veh/km²...
    sumo-gui -c "%CFG_FILE%"
) else (
    echo Archivo de configuración no encontrado: %CFG_FILE%
)

pause
