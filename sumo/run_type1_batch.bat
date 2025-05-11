@echo off
set DENSITIES=40 60 80 100 120 140 160

for %%D in (%DENSITIES%) do (
    echo Running CLI simulation for density %%D...
    sumo -c sumo\config\simon_bolivar_roi_%%D.sumocfg
)
echo All CLI simulations completed.
pause
