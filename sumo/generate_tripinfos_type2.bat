@echo off
setlocal

REM ================================================
REM Genera archivos tripinfo_type2_XXXX.xml para análisis
REM ================================================
set SUMO=D:\sumo-1.18.0\bin\sumo.exe
set CONFIG_DIR=config
set OUTPUT_DIR=output

echo Generando archivos tripinfo_type2_XXXX.xml...

%SUMO% -c %CONFIG_DIR%\simon_bolivar_type2_1000.sumocfg --tripinfo-output %OUTPUT_DIR%\tripinfo_type2_1000.xml
%SUMO% -c %CONFIG_DIR%\simon_bolivar_type2_3000.sumocfg --tripinfo-output %OUTPUT_DIR%\tripinfo_type2_3000.xml
%SUMO% -c %CONFIG_DIR%\simon_bolivar_type2_6000.sumocfg --tripinfo-output %OUTPUT_DIR%\tripinfo_type2_6000.xml
%SUMO% -c %CONFIG_DIR%\simon_bolivar_type2_10000.sumocfg --tripinfo-output %OUTPUT_DIR%\tripinfo_type2_10000.xml

echo Listo. Archivos guardados en %OUTPUT_DIR%.
pause
