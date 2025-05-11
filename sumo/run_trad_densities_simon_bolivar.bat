@echo off
echo Ejecutando simulaciones para todos los escenarios de densidad...
setlocal EnableDelayedExpansion

set "densities=40 60 80 100 120 140 160"

for %%D in (%densities%) do (
    echo ------------------------------
    echo Simulando densidad %%D...
    "%SUMO_HOME%\bin\sumo" -c config\simon_bolivar_%%D.sumocfg
)

echo ------------------------------
echo Todas las simulaciones han terminado.
pause
