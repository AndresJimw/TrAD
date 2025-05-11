@echo off
setlocal

REM Ruta al ejecutable de SUMO
set SUMO_EXEC=D:\sumo-1.18.0\bin\sumo.exe

REM Carpeta base
set CFG_DIR=config
set OUT_DIR=output

REM Asegurar que la carpeta output exista
if not exist %OUT_DIR% (
    mkdir %OUT_DIR%
)

echo Ejecutando simulaciones tipo 2 (modo batch)...
echo --------------------------------------------

for %%D in (40 60 80 100 120 140 160) do (
    echo Simulando densidad %%D...
    %SUMO_EXEC% -c %CFG_DIR%\simon_bolivar_type2_%%D.sumocfg --tripinfo-output %OUT_DIR%\tripinfo_type2_%%D.xml --no-warnings
)

echo --------------------------------------------
echo Simulaciones tipo 2 completadas.
pause
