@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM GENERADOR DE ARCHIVOS .sumocfg PARA TYPE 2 (fuera del ROI)
REM Densidades: 500, 1000, 2500, 5000 veh/km²
REM Entrada: routes_type2_%%D.rou.xml
REM Salida: simon_bolivar_type2_%%D.sumocfg
REM ============================================================

:: Rutas base del proyecto
set PROJECT_ROOT=D:\TrAD-Quito
set INPUT_DIR=%PROJECT_ROOT%\sumo\input
set CONFIG_DIR=%PROJECT_ROOT%\sumo\config

:: Archivos constantes
set NET_FILE=..\input\simon_bolivar.net.xml
set ADDITIONAL_FILES=..\input\roi_simon_bolivar.add.xml,..\input\vehicles.add.xml

cd /d %CONFIG_DIR%

for %%D in (1000, 3000, 6000, 10000) do (
    set "SUMOCFG_FILE=simon_bolivar_type2_%%D.sumocfg"
    set "ROUTE_FILE=..\input\routes_type2_%%D.rou.xml"

    echo Generando archivo !SUMOCFG_FILE!...

    (
        echo ^<configuration^>
        echo     ^<input^>
        echo         ^<net-file value="!NET_FILE!"/^>
        echo         ^<route-files value="!ROUTE_FILE!"/^>
        echo         ^<additional-files value="!ADDITIONAL_FILES!"/^>
        echo     ^</input^>
        echo     ^<time^>
        echo         ^<begin value="0"/^>
        echo         ^<end value="3600"/^>
        echo     ^</time^>
        echo     ^<output^>
        echo         ^<tripinfo-output value="..\output\tripinfo_type2_%%D.xml"/^>
        echo     ^</output^>
        echo ^</configuration^>
    ) > !SUMOCFG_FILE!
)

echo.
echo Archivos .sumocfg tipo 2 generados correctamente.
pause
