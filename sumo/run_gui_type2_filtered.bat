@echo off
setlocal enabledelayedexpansion

REM ==========================================================
REM EJECUTA UNA SIMULACION TYPE 2 FILTRADA EN MODO GUI
REM Usuario selecciona cantidad de vehículos simulada
REM ==========================================================

set SUMO_GUI="D:\sumo-1.18.0\bin\sumo-gui.exe"
set CONFIG_DIR=D:\TrAD-Quito\sumo\config

echo =====================================================
echo       EJECUTAR SIMULACION TYPE 2 FILTRADA (GUI)
echo =====================================================
echo.
echo Selecciona una densidad equivalente:
echo   1) ~1000 vehiculos (densidad 25 veh/km²)
echo   2) ~3000 vehiculos (densidad 75 veh/km²)
echo   3) ~6000 vehiculos (densidad 150 veh/km²)
echo   4) ~10000 vehiculos (densidad 250 veh/km²)
echo.

set /p CHOICE="Opcion (1-4): "

if "%CHOICE%"=="1" set VEHICLES=1000
if "%CHOICE%"=="2" set VEHICLES=3000
if "%CHOICE%"=="3" set VEHICLES=6000
if "%CHOICE%"=="4" set VEHICLES=10000

if not defined VEHICLES (
    echo Opcion invalida. Cerrando...
    pause
    exit /b
)

set CFG_FILE=%CONFIG_DIR%\simon_bolivar_type2_%VEHICLES%_filtered.sumocfg

if exist "%CFG_FILE%" (
    echo Ejecutando simulacion GUI: %CFG_FILE%
    start "" %SUMO_GUI% "%CFG_FILE%"
) else (
    echo [ERROR] No se encontro el archivo: %CFG_FILE%
)

pause
