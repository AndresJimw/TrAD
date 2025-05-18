@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM GENERADOR DE ARCHIVOS .sumocfg PARA TYPE 1 POR CANTIDAD VEHICULAR
REM Vehículos aproximados: 83, 250, 500, 830
REM ============================================================

set PROJECT_ROOT=D:\TrAD-Quito
set INPUT_DIR=%PROJECT_ROOT%\sumo\input
set CONFIG_DIR=%PROJECT_ROOT%\sumo\config
set NET_FILE=..\input\simon_bolivar.net.xml
set ADDITIONAL_FILES=..\input\vehicles.add.xml,..\input\roi_simon_bolivar.add.xml

cd /d %CONFIG_DIR%

for %%D in (83 250 500 830) do (
    echo Generando archivo simon_bolivar_type1_%%D.sumocfg...

    (
        echo ^<configuration^>
        echo     ^<input^>
        echo         ^<net-file value="%NET_FILE%"/^>
        echo         ^<route-files value="..\input\routes_type1_%%D.rou.xml"/^>
        echo         ^<additional-files value="%ADDITIONAL_FILES%"/^>
        echo     ^</input^>
        echo     ^<time^>
        echo         ^<begin value="0"/^>
        echo         ^<end value="3600"/^>
        echo     ^</time^>
        echo     ^<output^>
        echo         ^<tripinfo-output value="..\output\tripinfo_type1_%%D.xml"/^>
        echo     ^</output^>
        echo ^</configuration^>
    ) > simon_bolivar_type1_%%D.sumocfg
)

echo.
echo Archivos .sumocfg generados correctamente en %CONFIG_DIR%
pause
