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
echo [1]  ~1000 vehiculos
echo [2]  ~2000 vehiculos
echo [3]  ~3000 vehiculos
echo [4]  ~4000 vehiculos
echo [5]  ~5000 vehiculos
echo [6]  ~6000 vehiculos
echo [7]  ~7000 vehiculos
echo [8]  ~8000 vehiculos
echo [9]  ~9000 vehiculos
echo [10] ~10000 vehiculos
echo.

set /p OPTION=Selecciona una opcion (1-10): 

if "%OPTION%"=="1" set VEHICLES=1000
if "%OPTION%"=="2" set VEHICLES=2000
if "%OPTION%"=="3" set VEHICLES=3000
if "%OPTION%"=="4" set VEHICLES=4000
if "%OPTION%"=="5" set VEHICLES=5000
if "%OPTION%"=="6" set VEHICLES=6000
if "%OPTION%"=="7" set VEHICLES=7000
if "%OPTION%"=="8" set VEHICLES=8000
if "%OPTION%"=="9" set VEHICLES=9000
if "%OPTION%"=="10" set VEHICLES=10000

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
