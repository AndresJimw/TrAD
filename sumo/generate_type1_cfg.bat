@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM GENERADOR DE ARCHIVOS .sumocfg PARA TYPE 1 POR DENSIDAD
REM ============================================================

set PROJECT_ROOT=D:\TrAD-Quito
set INPUT_DIR=%PROJECT_ROOT%\sumo\input
set CONFIG_DIR=%PROJECT_ROOT%\sumo\config
set NET_FILE=..\input\simon_bolivar.net.xml
set ADDITIONAL_FILES=..\input\vehicles.add.xml,..\input\roi_simon_bolivar.add.xml

cd /d %CONFIG_DIR%

for %%D in (500 1000 2500 5000) do (
    echo Generando archivo simon_bolivar_type1_%%D.sumocfg...

    echo ^<configuration^> > simon_bolivar_type1_%%D.sumocfg
    echo     ^<input^> >> simon_bolivar_type1_%%D.sumocfg
    echo         ^<net-file value="%NET_FILE%"/^> >> simon_bolivar_type1_%%D.sumocfg
    echo         ^<route-files value="..\input\routes_type1_%%D.rou.xml"/^> >> simon_bolivar_type1_%%D.sumocfg
    echo         ^<additional-files value="%ADDITIONAL_FILES%"/^> >> simon_bolivar_type1_%%D.sumocfg
    echo     ^</input^> >> simon_bolivar_type1_%%D.sumocfg
    echo     ^<time^> >> simon_bolivar_type1_%%D.sumocfg
    echo         ^<begin value="0"/^> >> simon_bolivar_type1_%%D.sumocfg
    echo         ^<end value="3600"/^> >> simon_bolivar_type1_%%D.sumocfg
    echo     ^</time^> >> simon_bolivar_type1_%%D.sumocfg
    echo     ^<output^> >> simon_bolivar_type1_%%D.sumocfg
    echo         ^<tripinfo-output value="..\output\tripinfo_type1_%%D.xml"/^> >> simon_bolivar_type1_%%D.sumocfg
    echo     ^</output^> >> simon_bolivar_type1_%%D.sumocfg
    echo ^</configuration^> >> simon_bolivar_type1_%%D.sumocfg
)

echo.
echo Archivos .sumocfg generados correctamente en %CONFIG_DIR%
pause
