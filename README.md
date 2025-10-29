Note: The code in this repository, as well as this README, was generated iteratively with ChatGPT for my own needs. I have started making manual changes now, and PRs are welcome. Sharing because caring.
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
   `dist/Photopea-win32-x64/Photopea.exe`

---

## 📥 Download
Click the `.bat` file below to download and start building your own offline Photopea desktop app.

---

## 🔍 Script Breakdown: `build_photopea.bat`

### 1. Environment Check
```bat
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Node.js not found. Please install Node.js first.
    pause
    exit /b
)
```

### 2. Project Initialization
```bat
if not exist package.json (
    echo Initializing npm project...
    npm init -y >nul
)
```

### 3. Electron Setup
```bat
echo Installing Electron...
call npm install electron --save-dev
```

### 4. Create main.js (if missing)
```bat
if not exist main.js (
    echo Creating main.js...
    :: Generates Electron window with icon and loads index.html
    :: Includes contextIsolation and disables menu bar
    ...
)
```

### 5. Configure package.json
```bat
powershell -Command "(Get-Content package.json) -replace '\"scripts\": \{[^}]*\}', '\"scripts\": {\"start\": \"electron .\"}' | Set-Content package.json"
```

### 6. Icon Selection
```bat
set /p ICON_PATH=💠 Enter full path to your icon (.ico):
if not exist "%ICON_PATH%" (
    echo ❌ Icon not found at: %ICON_PATH%
    pause
    exit /b
)
copy "%ICON_PATH%" "%cd%\icon.ico" >nul
```

### 7. Electron Packager & Build
```bat
call npm install -g electron-packager
call electron-packager . Photopea --platform=win32 --arch=x64 --out=dist --overwrite --icon=icon.ico
```

### 8. Final Output
```bat
echo ✅ Build complete! Your EXE is ready at:
echo %cd%\dist\Photopea-win32-x64\Photopea.exe
pause
```

---

🎁 **Bonus: Local Dev Setup (Optional)**  
Want to test Photopea as a desktop app before packaging?

### 🧪 BONUS: Local Dev Setup

#### 1. Modify the json file first
```json
{
  "name": "photopea-v2",
  "version": "1.0.0",
  "description": "Offline version of Photopea using Electron.",
  "main": "main.js",
  "scripts": {
    "start": "electron .",
    "dist": "electron-builder"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "type": "commonjs",
  "devDependencies": {
    "electron": "^39.0.0",
    "electron-builder": "^24.6.0"
  },
  "build": {
    "appId": "com.yourname.photopea",
    "productName": "Photopea V2",
    "win": {
      "target": "nsis",
      "icon": "build/icon.ico"
    },
    "nsis": {
      "oneClick": false,
      "allowToChangeInstallationDirectory": true,
      "createDesktopShortcut": true,
      "createStartMenuShortcut": true
    }
  }
}
```

#### 2. Then run the commands

```bat
npm install --save-dev electron-builder
npm run dist
```
This creates a setup.exe for Photopea using Electron-Builder then you can install and use it like a normal desktop app.

---

## ⚠️ **Important Disclaimer**

> **This project and script are provided solely for educational and personal learning purposes.**
>
> **It is NOT affiliated with Photopea, nor endorsed by the Photopea team.**
>
> This builder simply wraps the open-source Photopea v2 project in a desktop shell using Electron, and is intended to help users understand how Electron packaging works.
>
> **Commercial use, redistribution, or any form of misuse is strictly prohibited.**  
> Please respect software licenses and do not use this script or its output for any unauthorized, illegal, or unethical purposes.  
>  
> The author does not accept responsibility for any misuse, infringement, or violation resulting from the use of this tool.  
>
> **If you are unsure about the legal implications, DO NOT use this tool.**
