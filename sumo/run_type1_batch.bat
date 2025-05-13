@echo off
setlocal

REM Ir a la raíz del proyecto
cd /d D:\TrAD-Quito

set DENSITIES=40 60 80 100 120 140 160

echo Ejecutando simulaciones para todos los escenarios de densidad...

for %%D in (%DENSITIES%) do (
    echo ------------------------------
    echo Simulando densidad %%D...
    sumo -c sumo\config\simon_bolivar_type1_%%D.sumocfg
)

echo ------------------------------
echo Todas las simulaciones han terminado.
pause
