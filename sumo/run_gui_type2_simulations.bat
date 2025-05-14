@echo off
setlocal enabledelayedexpansion

REM ========================================================
REM LANZADOR DE SIMULACIONES TYPE 2 (FUERA DEL ROI) EN GUI
REM Usuario selecciona densidad a simular
REM ========================================================

set PROJECT_ROOT=D:\TrAD-Quito
set SUMO_GUI=sumo-gui
set CONFIG_DIR=%PROJECT_ROOT%\sumo\config

REM Mostrar opciones disponibles
echo Simulaciones disponibles para TYPE 2:
echo -------------------------------------
echo [1]  500 veh/km2
echo [2]  1000 veh/km2
echo [3]  2500 veh/km2
echo [4]  5000 veh/km2
echo.

set /p OPTION=Selecciona una opcion (1-4):

if "%OPTION%"=="1" set DENSITY=500
if "%OPTION%"=="2" set DENSITY=1000
if "%OPTION%"=="3" set DENSITY=2500
if "%OPTION%"=="4" set DENSITY=5000

if not defined DENSITY (
    echo Opcion invalida. Saliendo...
    pause
    exit /b
)

set CONFIG_FILE=%CONFIG_DIR%\simon_bolivar_type2_%DENSITY%.sumocfg

if exist "!CONFIG_FILE!" (
    echo Abriendo simulacion con densidad %DENSITY% veh/km2...
    %SUMO_GUI% -c "!CONFIG_FILE!"
) else (
    echo No se encontro el archivo de configuración: !CONFIG_FILE!
)

pause
