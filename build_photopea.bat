@echo off
title Photopea Desktop Builder
color 0A

echo ==========================================
echo      🚀 Photopea Desktop App Builder
echo ==========================================
echo.

REM STEP 1: Check Node.js installation
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Node.js not found. Please install Node.js first.
    pause
    exit /b
)

REM STEP 2: Initialize project (if needed)
if not exist package.json (
    echo Initializing npm project...
    npm init -y >nul
)

REM STEP 3: Install Electron
echo Installing Electron...
call npm install electron --save-dev

REM STEP 4: Create main.js if missing
if not exist main.js (
    echo Creating main.js...
    (
    echo const { app, BrowserWindow } = require('electron');
    echo const path = require('path');
    echo.
    echo function createWindow() {
    echo ^tconst win = new BrowserWindow({
    echo ^t^twidth: 1280,
    echo ^t^theight: 800,
    echo ^t^ticon: path.join(__dirname, 'icon.ico'),
    echo ^t^twebPreferences: {
    echo ^t^t^tcontextIsolation: true,
    echo ^t^t^tnodeIntegration: false
    echo ^t^t}
    echo ^t});
    echo.
    echo ^twin.loadFile(path.join(__dirname, 'index.html'));
    echo ^twin.setMenuBarVisibility(false);
    echo }
    echo.
    echo app.whenReady().then(() => {
    echo ^tcreateWindow();
    echo ^tapp.on('activate', () => {
    echo ^t^tif (BrowserWindow.getAllWindows().length === 0) createWindow();
    echo ^t});
    echo });
    echo.
    echo app.on('window-all-closed', () => {
    echo ^tif (process.platform !== 'darwin') app.quit();
    echo });
    ) > main.js
)

REM STEP 5: Add start script to package.json
echo Configuring package.json...
powershell -Command "(Get-Content package.json) -replace '\"scripts\": \{[^}]*\}', '\"scripts\": {\"start\": \"electron .\"}' | Set-Content package.json"

REM STEP 6: Ask for icon path
echo.
set /p ICON_PATH=💠 Enter full path to your icon (.ico): 

if not exist "%ICON_PATH%" (
    echo ❌ Icon not found at: %ICON_PATH%
    pause
    exit /b
)

echo Copying icon to project folder...
copy "%ICON_PATH%" "%cd%\icon.ico" >nul

REM STEP 7: Install packager and build
echo Installing Electron Packager...
call npm install -g electron-packager

echo Building Windows EXE...
call electron-packager . Photopea --platform=win32 --arch=x64 --out=dist --overwrite --icon=icon.ico

echo.
echo ==========================================
echo ✅ Build complete! Your EXE is ready at:
echo %cd%\dist\Photopea-win32-x64\Photopea.exe
echo ==========================================
echo.
pause
