@echo off
setlocal

REM ====================================================
REM LANZADOR INTERACTIVO DE SIMULACIONES TYPE 1 (GUI)
REM Vehículos aproximados dentro del ROI: 83–830
REM ====================================================

set CONFIG_DIR=D:\TrAD-Quito\sumo\config

echo Simulaciones disponibles para TYPE 1:
echo -------------------------------------
echo [1]  ~83 vehiculos (densidad 1000 veh/km2)
echo [2]  ~250 vehiculos (densidad 3000 veh/km2)
echo [3]  ~500 vehiculos (densidad 6000 veh/km2)
echo [4]  ~830 vehiculos (densidad 10000 veh/km2)
echo.

set /p OPTION=Selecciona una opcion (1-4): 

if "%OPTION%"=="1" set VEHICLES=83
if "%OPTION%"=="2" set VEHICLES=250
if "%OPTION%"=="3" set VEHICLES=500
if "%OPTION%"=="4" set VEHICLES=830

if not defined VEHICLES (
    echo Opción inválida. Cerrando...
    pause
    exit /b
)

set CFG_FILE=%CONFIG_DIR%\simon_bolivar_type1_%VEHICLES%.sumocfg

if exist "%CFG_FILE%" (
    echo Abriendo simulacion con ~%VEHICLES% vehiculos...
    sumo-gui -c "%CFG_FILE%"
) else (
    echo Archivo de configuración no encontrado: %CFG_FILE%
)

pause
