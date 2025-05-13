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
    echo Generando rutas tipo 2 para densidad %%D...

    python "%TOOLS_DIR%\randomTrips.py" ^
        -n "%NET_FILE%" ^
        -o "%INPUT_DIR%\simon_bolivar_type2_%%D.trips.xml" ^
        --prefix type2_%%D ^
        --trip-attributes "departLane='best' departSpeed='max' departPos='random'" ^
        --validate ^
        --fringe-factor 6 ^
        --insertion-density %%D ^
        --begin 0 --end 3600 ^
        --seed %%D

    if exist "%INPUT_DIR%\simon_bolivar_type2_%%D.trips.xml" (
        echo Ejecutando duarouter para densidad %%D...

        duarouter -n "%NET_FILE%" ^
            --trip-files "%INPUT_DIR%\simon_bolivar_type2_%%D.trips.xml" ^
            --additional-files "%VEHICLE_TYPES%" ^
            -o "%INPUT_DIR%\simon_bolivar_type2_%%D.rou.xml"

        echo Limpiando definición duplicada de vType...
        findstr /V "<vType " "%INPUT_DIR%\simon_bolivar_type2_%%D.rou.xml" > "%INPUT_DIR%\temp_%%D.rou.xml"
        del /f /q "%INPUT_DIR%\simon_bolivar_type2_%%D.rou.xml"
        move /Y "%INPUT_DIR%\temp_%%D.rou.xml" "%INPUT_DIR%\simon_bolivar_type2_%%D.rou.xml"

        echo Creando archivo .sumocfg...
        (
            echo ^<configuration^>
            echo     ^<input^>
            echo         ^<net-file value="..\input\simon_bolivar.net.xml"/^>
            echo         ^<route-files value="..\input\simon_bolivar_type2_%%D.rou.xml"/^>
            echo         ^<additional-files value="..\input\roi_simon_bolivar.add.xml,..\input\vehicles.add.xml"/^>
            echo     ^</input^>
            echo     ^<time^>
            echo         ^<begin value="0"/^>
            echo         ^<end value="3600"/^>
            echo     ^</time^>
            echo ^</configuration^>
        ) > "%CONFIG_DIR%\simon_bolivar_type2_%%D.sumocfg"

    ) else (
        echo [ERROR] No se generó el archivo de trips para densidad %%D
    )
)

echo.
echo Todas las rutas tipo 2 fueron procesadas correctamente.
pause
