@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM GENERA ARCHIVOS .sumocfg TYPE 2 FILTRADOS (fuera del ROI)
REM Usa: routes_type2_%%D_filtered.rou.xml
REM Salida: simon_bolivar_type2_%%D_filtered.sumocfg
REM ============================================================

set PROJECT_ROOT=D:\TrAD-Quito
set CONFIG_DIR=%PROJECT_ROOT%\sumo\config
set INPUT_DIR=%PROJECT_ROOT%\sumo\input
set NET_FILE=..\input\simon_bolivar.net.xml
set ADDITIONAL=..\input\roi_simon_bolivar.add.xml,..\input\vehicles.add.xml

cd /d %CONFIG_DIR%

for %%D in (1000, 3000, 6000, 10000) do (
    set "ROUTE_FILE=..\input\routes_type2_%%D_filtered.rou.xml"
    set "SUMOCFG_FILE=simon_bolivar_type2_%%D_filtered.sumocfg"

    echo Generando archivo !SUMOCFG_FILE!...

    (
        echo ^<configuration^>
        echo     ^<input^>
        echo         ^<net-file value="!NET_FILE!"/^>
        echo         ^<route-files value="!ROUTE_FILE!"/^>
        echo         ^<additional-files value="!ADDITIONAL!"/^>
        echo     ^</input^>
        echo     ^<time^>
        echo         ^<begin value="0"/^>
        echo         ^<end value="3600"/^>
        echo     ^</time^>
        echo     ^<output^>
        echo         ^<tripinfo-output value="..\output\tripinfo_type2_%%D_filtered.xml"/^>
        echo     ^</output^>
        echo ^</configuration^>
    ) > !SUMOCFG_FILE!
)

echo.
echo Archivos .sumocfg filtrados generados correctamente.
pause
