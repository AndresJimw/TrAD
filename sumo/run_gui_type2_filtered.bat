@echo off
setlocal enabledelayedexpansion

REM ==========================================================
REM EJECUTA UNA SIMULACION TYPE 2 FILTRADA EN MODO GUI
REM Te permite elegir la densidad (500, 1000, 2500, 5000)
REM ==========================================================

set SUMO_GUI="D:\sumo-1.18.0\bin\sumo-gui.exe"
set CONFIG_DIR=D:\TrAD-Quito\sumo\config

echo =====================================================
echo       EJECUTAR SIMULACION TYPE 2 FILTRADA (GUI)
echo =====================================================
echo.
echo Selecciona una densidad:
echo   1) 500 veh/km2
echo   2) 1000 veh/km2
echo   3) 2500 veh/km2
echo   4) 5000 veh/km2
echo.

set /p CHOICE="Opcion (1-4): "

if "%CHOICE%"=="1" set DENSITY=500
if "%CHOICE%"=="2" set DENSITY=1000
if "%CHOICE%"=="3" set DENSITY=2500
if "%CHOICE%"=="4" set DENSITY=500

if not defined DENSITY (
    echo Opcion invalida. Cerrando...
    pause
    exit /b
)

if "%CHOICE%"=="4" set DENSITY=5000

set CFG_FILE=%CONFIG_DIR%\simon_bolivar_type2_%DENSITY%_filtered.sumocfg

if exist "%CFG_FILE%" (
    echo Ejecutando simulacion GUI: %CFG_FILE%
    start "" %SUMO_GUI% "%CFG_FILE%"
) else (
    echo [ERROR] No se encontro el archivo: %CFG_FILE%
)

echo.
pause
