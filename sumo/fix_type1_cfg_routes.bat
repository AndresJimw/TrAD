@echo off
setlocal enabledelayedexpansion

set "CONFIG_DIR=config"
set "INPUT_DIR=input"
set "DENSITIES=40 60 80 100 120 140 160"

echo 🔧 Corrigiendo archivos .sumocfg tipo 1 para que apunten a los .rou.xml correctos...

for %%D in (%DENSITIES%) do (
    set "CFG_FILE=%CONFIG_DIR%\simon_bolivar_type1_%%D.sumocfg"
    set "OLD_LINE=<route-files value=""..\%INPUT_DIR%\simon_bolivar_type1_%%D.rou.xml""/>"
    set "NEW_LINE=<route-files value=""..\%INPUT_DIR%\simon_bolivar_roi_%%D.rou.xml""/>"

    echo 🔄 Corrigiendo archivo: !CFG_FILE!

    REM Creamos un archivo temporal corregido línea por línea
    set "TMP_FILE=%CFG_FILE%.tmp"
    break > "!TMP_FILE!"

    for /f "usebackq delims=" %%L in ("!CFG_FILE!") do (
        set "line=%%L"
        echo !line! | findstr /c:"<route-files value=" >nul
        if !errorlevel! equ 0 (
            echo !NEW_LINE!>> "!TMP_FILE!"
        ) else (
            echo !line!>> "!TMP_FILE!"
        )
    )

    move /Y "!TMP_FILE!" "!CFG_FILE!" >nul
)

echo ✅ Archivos .sumocfg corregidos exitosamente.
pause
