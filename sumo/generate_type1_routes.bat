@echo off
setlocal enabledelayedexpansion

REM ======================================================
REM GENERADOR DE RUTAS TYPE 1 (DENTRO DEL ROI) - REALISTA
REM Densidades: 500 1000 2500 5000 veh/km²
REM Entrada: trips_type1_%%D.trips.xml
REM Salida:  routes_type1_%%D.rou.xml (limpios)
REM ======================================================

:: Configuración de rutas
set PROJECT_ROOT=D:\TrAD-Quito
set INPUT_DIR=%PROJECT_ROOT%\sumo\input
set NET_FILE=%INPUT_DIR%\simon_bolivar.net.xml
set VEHICLE_TYPES=%INPUT_DIR%\vehicles.add.xml

cd /d %PROJECT_ROOT%

for %%D in (500 1000 2500 5000) do (
    echo.
    echo ============================
    echo Generando rutas type 1 para densidad %%D...
    echo ============================

    set "TRIP_FILE=!INPUT_DIR!\trips_type1_%%D.trips.xml"
    set "ROUTE_FILE=!INPUT_DIR!\routes_type1_%%D.rou.xml"
    set "TEMP_FILE=!INPUT_DIR!\temp_%%D.rou.xml"

    if exist !TRIP_FILE! (
        echo Ejecutando duarouter...

        duarouter -n !NET_FILE! ^
            --route-files !TRIP_FILE! ^
            --additional-files !VEHICLE_TYPES! ^
            -o !ROUTE_FILE!

        timeout /t 1 >nul

        if exist !ROUTE_FILE! (
            echo Limpiando definiciones de vType...
            findstr /V "<vType " !ROUTE_FILE! > !TEMP_FILE!

            if exist !TEMP_FILE! (
                del /f /q !ROUTE_FILE!
                move /Y !TEMP_FILE! !ROUTE_FILE! >nul
                echo Rutas generadas correctamente: !ROUTE_FILE!
            ) else (
                echo Advertencia: no se genero el archivo temporal. Se omite limpieza.
            )
        ) else (
            echo Error: duarouter no genero el archivo esperado: !ROUTE_FILE!
        )
    ) else (
        echo Error: archivo de trips no encontrado: !TRIP_FILE!
    )
)

echo.
echo Proceso finalizado. Todas las rutas type 1 fueron procesadas.
pause
