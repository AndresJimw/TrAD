@echo off
setlocal enabledelayedexpansion

:: CONFIGURACIÓN
set PROJECT_ROOT=D:\TrAD-Quito
set TOOLS_DIR=D:\sumo-1.18.0\tools
set INPUT_DIR=%PROJECT_ROOT%\sumo\input
set CONFIG_DIR=%PROJECT_ROOT%\sumo\config
set NET_FILE=%INPUT_DIR%\simon_bolivar.net.xml
set VEHICLE_TYPES=%INPUT_DIR%\vehicles.add.xml

cd /d %PROJECT_ROOT%

for %%D in (40 60 80 100 120 140 160) do (
    echo ============================
    echo Procesando densidad %%D...

    :: Rutas filtradas
    set TRIPS_FILE=%INPUT_DIR%\simon_bolivar_type2_%%D_filtered.trips.xml
    set ROU_FILE=%INPUT_DIR%\simon_bolivar_type2_%%D_filtered.rou.xml
    set SUMO_FILE=%CONFIG_DIR%\simon_bolivar_type2_%%D_filtered.sumocfg

    duarouter -n "%NET_FILE%" ^
        --trip-files "!TRIPS_FILE!" ^
        --additional-files "%VEHICLE_TYPES%" ^
        -o "!ROU_FILE!"

    echo Limpiando vType duplicado...
    findstr /V "<vType " "!ROU_FILE!" > "%INPUT_DIR%\temp_%%D.rou.xml"
    del /f /q "!ROU_FILE!"
    move /Y "%INPUT_DIR%\temp_%%D.rou.xml" "!ROU_FILE!" >nul

    echo Generando archivo .sumocfg...
    (
        echo ^<configuration^>
        echo     ^<input^>
        echo         ^<net-file value="..\input\simon_bolivar.net.xml"/^>
        echo         ^<route-files value="..\input\simon_bolivar_type2_%%D_filtered.rou.xml"/^>
        echo         ^<additional-files value="..\input\roi_simon_bolivar.add.xml,..\input\vehicles.add.xml"/^>
        echo     ^</input^>
        echo     ^<time^>
        echo         ^<begin value="0"/^>
        echo         ^<end value="3600"/^>
        echo     ^</time^>
        echo ^</configuration^>
    ) > "!SUMO_FILE!"
)

echo.
echo Todos los archivos filtrados han sido procesados correctamente.
pause
