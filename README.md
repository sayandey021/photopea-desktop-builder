# 🚀 Photopea Desktop Builder Script

This release contains a **ready-to-use batch file** that automates the process of turning [Photopea v2](https://gitflic.ru/project/photopea-v2/photopea-v-2) into a portable Windows desktop app using Electron.

---

## 💡 Features
- One-click `.exe` builder for Photopea
- Interactive icon selection
- Auto-setup of Electron environment
- Portable output—no installation required

---

## 📦 How to Use
1. Download `build_photopea.bat` from this release.
2. Place it inside your `photopea-v2` folder.
3. Right-click → “Run as Administrator”.
4. Enter your `.ico` path when prompted.
5. Your app will be built at:
dist/Photopea-win32-x64/Photopea.exe

---

## 📥 Download
Click the `.bat` file below to download and start building your own offline Photopea desktop app.

---

## 🔍 Script Breakdown: `build_photopea.bat`

```bat
REM ✅ 1. Environment Check
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Node.js not found. Please install Node.js first.
    pause
    exit /b
)

:: 📦 2. Project Initialization
if not exist package.json (
    echo Initializing npm project...
    npm init -y >nul
)

:: ⚙️ 3. Electron Setup
echo Installing Electron...
call npm install electron --save-dev

:: 🧠 4. Create main.js (if missing)
if not exist main.js (
    echo Creating main.js...
    :: Generates Electron window with icon and loads index.html
    :: Includes contextIsolation and disables menu bar
    ...
)

:: 📝 5. Configure package.json
powershell -Command "(Get-Content package.json) -replace '\"scripts\": \{[^}]*\}', '\"scripts\": {\"start\": \"electron .\"}' | Set-Content package.json"

:: 🎨 6. Icon Selection
set /p ICON_PATH=💠 Enter full path to your icon (.ico):
if not exist "%ICON_PATH%" (
    echo ❌ Icon not found at: %ICON_PATH%
    pause
    exit /b
)
copy "%ICON_PATH%" "%cd%\icon.ico" >nul

:: 📦 7. Electron Packager & Build
call npm install -g electron-packager
call electron-packager . Photopea --platform=win32 --arch=x64 --out=dist --overwrite --icon=icon.ico

:: ✅ 8. Final Output
echo ✅ Build complete! Your EXE is ready at:
echo %cd%\dist\Photopea-win32-x64\Photopea.exe
pause
```

## ⚠️ Disclaimer
This script is **not affiliated with Photopea**.  
It simply wraps the open-source Photopea v2 project in a desktop shell using Electron.


