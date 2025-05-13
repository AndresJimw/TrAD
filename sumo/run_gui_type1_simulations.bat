@echo off
setlocal

REM Nos movemos al directorio 'config' donde las rutas relativas son válidas
cd /d "%~dp0config"

set DENSITIES=40 60 80 100 120 140 160

for %%D in (%DENSITIES%) do (
    echo Ejecutando simulación GUI para densidad %%D...
    start /wait sumo-gui -c simon_bolivar_type1_%%D.sumocfg
)

echo Todas las simulaciones tipo 1 han sido ejecutadas.
pause
