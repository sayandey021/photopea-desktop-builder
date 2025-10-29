const { app, BrowserWindow } = require('electron');
const path = require('path');

function createWindow() {
  const win = new BrowserWindow({
    width: 1280,
    height: 800,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true
    }
  });

  // Load local index.html
  win.loadFile(path.join(__dirname, 'index.html'));

  // Optional: remove menu bar
  win.setMenuBarVisibility(false);
}

app.whenReady().then(createWindow); 