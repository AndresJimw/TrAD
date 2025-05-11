@echo off
setlocal EnableDelayedExpansion

set "INPUT_DIR=input"
set "CONFIG_DIR=config"
set "NETWORK_FILE=!INPUT_DIR!\simon_bolivar.net.xml"
set "ADDITIONAL_FILES=input/roi_simon_bolivar.add.xml,input/source_node.add.xml"
set "TYPE1_PREFIX=simon_bolivar_type1"
set "DENSITIES=40 60 80 100 120 140 160"

echo Generating SUMO configuration files for type 1 routes...

for %%D in (%DENSITIES%) do (
    set "TRIPFILE=!INPUT_DIR!\!TYPE1_PREFIX!_%%D.trips.xml"
    set "ROUTEFILE=!INPUT_DIR!\!TYPE1_PREFIX!_%%D.rou.xml"
    set "SUMOCFG=!CONFIG_DIR!\!TYPE1_PREFIX!_%%D.sumocfg"

    echo Writing config for density %%D...

    (
        echo ^<configuration^>
        echo   ^<input^>
        echo     ^<net-file value="!NETWORK_FILE!" /^>
        echo     ^<route-files value="!ROUTEFILE!" /^>
        echo     ^<additional-files value="!ADDITIONAL_FILES!" /^>
        echo   ^</input^>
        echo   ^<time^>
        echo     ^<begin value="0" /^>
        echo     ^<end value="3600" /^>
        echo   ^</time^>
        echo ^</configuration^>
    ) > "!SUMOCFG!"
)

echo Done generating config files.
pause
