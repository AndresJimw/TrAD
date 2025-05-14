@echo off
setlocal enabledelayedexpansion

REM ==========================================
REM GENERADOR DE RUTAS TYPE 2 SIN FILTRO ROI
REM Genera .rou.xml directamente desde .trips
REM ==========================================

set PROJECT_ROOT=D:\TrAD-Quito
set INPUT_DIR=%PROJECT_ROOT%\sumo\input
set SCRIPTS_DIR=%PROJECT_ROOT%\sumo\scripts
set NET_FILE=%INPUT_DIR%\simon_bolivar.net.xml
set VEHICLE_TYPES=%INPUT_DIR%\vehicles.add.xml

cd /d %PROJECT_ROOT%

for %%D in (500 1000 2500 5000) do (
    echo ============================
    echo Procesando densidad %%D...
    echo ============================

    set "TRIPS_FILE=%INPUT_DIR%\trips_type2_%%D.trips.xml"
    set "ROUTE_FILE=%INPUT_DIR%\routes_type2_%%D.rou.xml"
    set "TEMP_FILE=%INPUT_DIR%\routes_type2_%%D_temp.rou.xml"

    if exist !TRIPS_FILE! (
        echo Generando rutas con duarouter...
        duarouter -n %NET_FILE% ^
            --trip-files !TRIPS_FILE! ^
            --additional-files %VEHICLE_TYPES% ^
            -o !ROUTE_FILE!

        echo Limpiando archivo .rou.xml...
        findstr /V "<vType " !ROUTE_FILE! > !TEMP_FILE!
        del /f /q !ROUTE_FILE!
        move /Y !TEMP_FILE! !ROUTE_FILE! >nul
        echo Rutas generadas correctamente: !ROUTE_FILE!
    ) else (
        echo Error: No se encontro el archivo !TRIPS_FILE!
    )
)

echo.
echo Todas las rutas type 2 fueron procesadas correctamente.
pause
