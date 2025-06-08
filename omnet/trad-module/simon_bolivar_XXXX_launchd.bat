@echo off
REM ===========================================================
REM CREA LOS ARCHIVOS simon_bolivar_XXXX.launchd.xml (TYPE 2)
REM EN LA CARPETA: D:\TrAD-Quito\omnet\trad-module
REM ===========================================================

setlocal enabledelayedexpansion

for %%D in (1000 2000 3000 4000 5000 6000 7000 8000 9000 10000) do (
    echo Generando archivo simon_bolivar_%%D.launchd.xml...
    > simon_bolivar_%%D.launchd.xml (
        echo ^<launch^>
        echo     ^<copy file="simon_bolivar.net.xml" /^>
        echo     ^<copy file="routes_type2_%%D.rou.xml" /^>
        echo     ^<copy file="roi_simon_bolivar.add.xml" /^>
        echo     ^<copy file="vehicles.add.xml" /^>
        echo     ^<copy file="simon_bolivar_type2_%%D.sumocfg" type="config" /^>
        echo ^</launch^>
    )
)

echo.
echo Archivos .launchd.xml generados en trad-module correctamente.
pause
