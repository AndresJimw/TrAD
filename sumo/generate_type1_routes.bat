@echo off
setlocal enabledelayedexpansion

:: Configuración de rutas
set PROJECT_ROOT=D:\TrAD-Quito
set SCRIPTS_DIR=%PROJECT_ROOT%\sumo\scripts
set INPUT_DIR=%PROJECT_ROOT%\sumo\input
set NET_FILE=%INPUT_DIR%\simon_bolivar.net.xml
set VEHICLE_TYPES=%INPUT_DIR%\vehicles.add.xml

:: Ir a la raíz del proyecto
cd /d %PROJECT_ROOT%

:: Iterar sobre las densidades
for %%D in (40 60 80 100 120 140 160) do (
    echo.
    echo ============================
    echo Generando rutas tipo 1 para densidad %%D...
    echo ============================

    :: Generar archivo .trips.xml con el nombre correspondiente
    python %SCRIPTS_DIR%\generate_trips_roi.py --vehicles %%D --output %INPUT_DIR%\simon_bolivar_roi_%%D.trips.xml

    if exist %INPUT_DIR%\simon_bolivar_roi_%%D.trips.xml (
        echo Archivo de trips generado. Ejecutando duarouter...

        :: Ejecutar duarouter para generar el .rou.xml correspondiente
        duarouter -n %NET_FILE% ^
            --trip-files %INPUT_DIR%\simon_bolivar_roi_%%D.trips.xml ^
            --additional-files %VEHICLE_TYPES% ^
            -o %INPUT_DIR%\simon_bolivar_roi_%%D.rou.xml

        :: Eliminar línea de definición de vType redundante del archivo .rou.xml
        findstr /V "<vType " %INPUT_DIR%\simon_bolivar_roi_%%D.rou.xml > %INPUT_DIR%\temp_%%D.rou.xml
        del /f /q %INPUT_DIR%\simon_bolivar_roi_%%D.rou.xml
        move /Y %INPUT_DIR%\temp_%%D.rou.xml %INPUT_DIR%\simon_bolivar_roi_%%D.rou.xml >nul

    ) else (
        echo No se encontró el archivo de trips generado. Se omite densidad %%D.
    )
)

echo.
echo Todas las rutas tipo 1 fueron procesadas.
pause
