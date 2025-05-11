@echo off
setlocal

set SUMO_TOOLS=D:\sumo-1.18.0\tools
set NET=input\simon_bolivar.net.xml

for %%D in (40 60 80 100 120 140 160) do (
    echo Generando rutas tipo 2 para densidad %%D...

    python "%SUMO_TOOLS%\randomTrips.py" -n %NET% ^
        -o input\simon_bolivar_type2_%%D.trips.xml ^
        --prefix type2_%%D ^
        --trip-attributes "departLane='best' departSpeed='max' departPos='random'" ^
        --validate ^
        --fringe-factor 3 ^
        --insertion-density %%D ^
        --seed %%D

    duarouter -n %NET% ^
        -r input\simon_bolivar_type2_%%D.trips.xml ^
        -o input\simon_bolivar_type2_%%D.rou.xml
)

echo Rutas tipo 2 generadas con éxito para todas las densidades.
pause
