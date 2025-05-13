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
    echo Generando archivo .sumocfg final para densidad %%D...

    set "ROU_FILE=simon_bolivar_type2_%%D_final.rou.xml"
    set "SUMO_FILE=simon_bolivar_type2_%%D_final.sumocfg"

    (
        echo ^<configuration^>
        echo     ^<input^>
        echo         ^<net-file value="..\input\simon_bolivar.net.xml"/^>
        echo         ^<route-files value="..\input\!ROU_FILE!"/^>
        echo         ^<additional-files value="..\input\roi_simon_bolivar.add.xml,..\input\vehicles.add.xml"/^>
        echo     ^</input^>
        echo     ^<time^>
        echo         ^<begin value="0"/^>
        echo         ^<end value="3600"/^>
        echo     ^</time^>
        echo ^</configuration^>
    ) > "%CONFIG_DIR%\!SUMO_FILE!"
)

echo.
echo Todos los archivos .sumocfg finales han sido generados correctamente.
pause
