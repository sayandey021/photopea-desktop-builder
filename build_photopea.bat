@echo off
title Photopea Desktop Builder
setlocal EnableDelayedExpansion

REM ==================================================
REM Fix working directory
REM ==================================================
cd /d "%~dp0"

echo ==========================================
echo       Photopea Desktop App Builder
echo ==========================================
echo.

REM ==================================================
REM STEP 1: Check Node.js
REM ==================================================
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo Node.js not found. Please install Node.js from https://nodejs.org/
    pause
    exit /b
)

REM ==================================================
REM STEP 2: Initialize npm project if missing
REM ==================================================
if not exist package.json (
    echo Initializing npm project...
    call npm init -y
    if !errorlevel! neq 0 (
        echo Failed to initialize npm project.
        pause
        exit /b
    )
)

REM ==================================================
REM STEP 3: Install Electron
REM ==================================================
echo Installing Electron...
call npm install electron --save-dev
if !errorlevel! neq 0 (
    echo Failed to install Electron.
    pause
    exit /b
)

REM ==================================================
REM STEP 4: Create index.js if missing
REM ==================================================
if not exist index.js (
    echo Creating index.js...
    (
        echo const { app, BrowserWindow } = require^('electron'^);
        echo const path = require^('path'^);
        echo.
        echo function createWindow^(^) {
        echo     const win = new BrowserWindow^({
        echo         width: 1280,
        echo         height: 800,
        echo         webPreferences: {
        echo             nodeIntegration: false,
        echo             contextIsolation: true
        echo         }
        echo     }^);
        echo     win.loadFile^(path.join^(__dirname, 'index.html'^)^);
        echo     win.setMenuBarVisibility^(false^);
        echo }
        echo.
        echo app.whenReady^(^).then^(createWindow^);
        echo.
        echo app.on^('window-all-closed', ^(^) =^> {
        echo     if ^(process.platform !== 'darwin'^) app.quit^(^);
        echo }^);
    ) > index.js
)

REM ==================================================
REM STEP 5: Configure package.json
REM ==================================================
echo Configuring package.json...
node -e "let f=require('fs');let p=JSON.parse(f.readFileSync('package.json'));p.main='index.js';p.scripts={start:'electron .'};f.writeFileSync('package.json',JSON.stringify(p,null,2));"
if !errorlevel! neq 0 (
    echo Failed to configure package.json.
    pause
    exit /b
)

REM ==================================================
REM STEP 6: Ask for icon (optional)
REM ==================================================
echo.
set "ICON_PATH="
set /p ICON_PATH="Enter full path to your icon (.ico) [Press Enter to skip]: "
set "ICON_OPTION="

if defined ICON_PATH (
    if not exist "!ICON_PATH!" (
        echo Icon not found at: !ICON_PATH!
        echo Continuing without custom icon...
    ) else (
        echo Copying icon to project folder...
        copy "!ICON_PATH!" "%cd%\icon.ico" >nul
        set "ICON_OPTION=--icon=icon.ico"
    )
) else (
    echo No icon provided. Using default Electron icon.
)

REM ==================================================
REM STEP 7: Install packager and build EXE
REM ==================================================
echo Installing Electron Packager...
call npm install electron-packager --save-dev
if !errorlevel! neq 0 (
    echo Failed to install electron-packager.
    pause
    exit /b
)

echo Building Windows EXE...
if defined ICON_OPTION (
    call npx electron-packager . Photopea --platform=win32 --arch=x64 --out=dist --overwrite !ICON_OPTION! --prune=true --asar
) else (
    call npx electron-packager . Photopea --platform=win32 --arch=x64 --out=dist --overwrite --prune=true --asar
)

REM ==================================================
REM STEP 8: Launch final message in new window
REM ==================================================
set "BUILD_PATH=%cd%\dist\Photopea-win32-x64\Photopea.exe"

echo.
if exist "!BUILD_PATH!" (
    echo ==========================================
    echo Build complete!
    echo Your EXE is ready at:
    echo !BUILD_PATH!
    echo ==========================================
    echo.
    start "" explorer /select,"!BUILD_PATH!"
) else (
    echo ==========================================
    echo Build failed!
    echo Please check the logs above for errors.
    echo ==========================================
)

echo.
echo Press any key to exit...
pause >nul
