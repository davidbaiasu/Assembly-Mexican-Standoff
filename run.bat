@echo off
setlocal

set NASM=D:\NASM\nasm.exe
set QEMU=D:\qemu\qemu-system-x86_64.exe

:: Check argument
if "%~1"=="" (
    echo Usage:
    echo    run.bat file.asm
    exit /b 1
)

set INPUT=%~1
set OUTPUT=%~n1.bin

echo [1/2] Assembling %INPUT%...
"%NASM%" -f bin "%INPUT%" -o "%OUTPUT%"

if errorlevel 1 (
    echo.
    echo [ERROR] NASM compilation failed!
    pause
    exit /b 1
)

echo.
echo [2/2] Launching QEMU...
"%QEMU%" -drive format=raw,file="%OUTPUT%"

endlocal