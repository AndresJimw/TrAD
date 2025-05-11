@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0config"

echo 🔧 Corrigiendo rutas en archivos .sumocfg tipo 1...

for %%F in (simon_bolivar_type1_*.sumocfg) do (
    echo Procesando %%F...

    REM Crear copia de seguridad
    copy "%%F" "%%F.bak" > nul

    REM Crear archivo temporal corregido
    set "TMPFILE=tmp_%%F"
    (for /f "usebackq delims=" %%L in ("%%F") do (
        set "line=%%L"
        setlocal enabledelayedexpansion
        echo(!line:input\=..\input\!
        endlocal
    )) > "!TMPFILE!"

    REM Reemplazar archivo original
    move /Y "!TMPFILE!" "%%F" > nul
    echo ✔ Corregido: %%F
)

echo.
echo ✅ Todos los archivos tipo 1 fueron corregidos. Copias de seguridad guardadas como .bak
pause
