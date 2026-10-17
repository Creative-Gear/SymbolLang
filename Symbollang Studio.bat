@echo off
setlocal
title Symbollang Studio
color 0A

:: 自动查找第一个 .exe 文件作为解释器
set "INTERPRETER="
for %%f in (*.exe) do (
    set "INTERPRETER=%%f"
    goto found
)
:found
if not defined INTERPRETER (
    echo [Error] No .exe file found in current directory.
    echo Please place the interpreter executable here.
    pause
    exit /b 1
)

:: 如果文件被拖放至此，直接运行
if not "%~1"=="" goto runfile_drop

:menu
cls
echo ============================
echo  Symbollang Studio
echo  copyright (c)2026 Creative Gears
echo ============================
echo  1. New File
echo  2. Open File
echo  3. Run File
echo  4. Examples
echo  5. Exit
echo  6. About
echo  7. Activate Pro Version
echo ============================
set "choice="
set /p choice="Select (1-7): "
if not defined choice goto menu

if "%choice%"=="1" goto newfile
if "%choice%"=="2" goto openfile
if "%choice%"=="3" goto runfile
if "%choice%"=="4" goto examples
if "%choice%"=="5" exit /b
if "%choice%"=="6" goto openlicense
if "%choice%"=="7" goto activatepro
goto menu

:newfile
set "fname="
set /p fname="Enter file name (without extension): "
if not defined fname goto menu
echo. > "%fname%.~"
echo File created: "%fname%.~"
notepad "%fname%.~"
goto menu

:openfile
echo Current .~ files:
dir *.~ 2>nul
echo.
set "fname="
set /p fname="Enter file name (with extension): "
if not defined fname goto menu
if exist "%fname%" (
    notepad "%fname%"
) else (
    echo File not found!
    pause
)
goto menu

:runfile
echo Current .~ files:
dir *.~ 2>nul
echo.
set "fname="
set /p fname="Enter file name (with extension): "
if not defined fname goto menu
if exist "%fname%" (
    echo Running "%fname%" ...
    echo ============================
    "%INTERPRETER%" "%fname%"
    echo ============================
    echo Run finished.
) else (
    echo File not found!
)
pause
goto menu

:runfile_drop
echo Running "%~1" ...
echo ============================
"%INTERPRETER%" "%~1"
echo ============================
echo Run finished.
pause
exit /b

:examples
if not exist "examples" (
    echo Examples directory not found, creating...
    mkdir examples
)
echo Examples directory:
dir examples\*.~ 2>nul
echo.
echo You can copy example files to current directory.
pause
goto menu

:activatepro
if exist "Activate License.~econf" (
    echo 已激活
    pause
    call :openlicense
) else (
    echo 未激活
    pause
    goto menu
)

:openlicense
if not exist "License.txt" call :create_license
notepad "License.txt"
goto menu

:create_license
call :getexpiration
(
    echo ======================
    echo 感谢您购买Symbollang Studio Pro
    echo ========授权信息=========
    echo 本软件授权给:%USERNAME%
    echo 有效期至:%exp%
) > "License.txt"
goto :eof

:getexpiration
set "exp=Missing expiration date"
if not exist "Activate License.~econf" goto :eof
for /f "tokens=2 delims==" %%a in ('findstr /i /c:"Expiration date" "Activate License.~econf"') do (
    set "exp_raw=%%a"
)
if defined exp_raw (
    for /f "tokens=1 delims=)" %%b in ("%exp_raw%") do set "exp=%%b"
    set "exp=%exp:"=%"
    set "exp=%exp: =%"
)
goto :eof