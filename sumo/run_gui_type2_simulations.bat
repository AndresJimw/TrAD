@echo off
setlocal enabledelayedexpansion

REM ========================================================
REM LANZADOR DE SIMULACIONES TYPE 2 (FUERA DEL ROI) EN GUI
REM Usuario selecciona cantidad aproximada de vehículos
REM ========================================================

set PROJECT_ROOT=D:\TrAD-Quito
set SUMO_GUI=sumo-gui
set CONFIG_DIR=%PROJECT_ROOT%\sumo\config

echo Simulaciones disponibles para TYPE 2:
echo -------------------------------------
echo [1]  ~1000 vehiculos (densidad 25 veh/km²)
echo [2]  ~3000 vehiculos (densidad 75 veh/km²)
echo [3]  ~6000 vehiculos (densidad 150 veh/km²)
echo [4]  ~10000 vehiculos (densidad 250 veh/km²)
echo.

set /p OPTION=Selecciona una opcion (1-4): 

if "%OPTION%"=="1" set VEHICLES=1000
if "%OPTION%"=="2" set VEHICLES=3000
if "%OPTION%"=="3" set VEHICLES=6000
if "%OPTION%"=="4" set VEHICLES=10000

if not defined VEHICLES (
    echo Opcion invalida. Cerrando...
    pause
    exit /b
)

set CONFIG_FILE=%CONFIG_DIR%\simon_bolivar_type2_%VEHICLES%.sumocfg

if exist "!CONFIG_FILE!" (
    echo Abriendo simulacion con ~%VEHICLES% vehiculos...
    %SUMO_GUI% -c "!CONFIG_FILE!"
) else (
    echo No se encontro el archivo de configuración: !CONFIG_FILE!
)

pause
