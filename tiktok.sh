#!/bin/bash

APP_NAME="TikTokWeb"
APP_DIR=~/AppBuilds/tiktok-app
BUILD_DIR="$APP_DIR/$APP_NAME-linux-x64"
ICON_URL="https://upload.wikimedia.org/wikipedia/commons/a/a9/TikTok_logo.svg"

# 1. Buat folder build
mkdir -p "$APP_DIR"
cd "$APP_DIR" || exit

# 2. Buat file main.js
cat <<EOF > main.js
const { app, BrowserWindow } = require('electron')

function createWindow () {
  const win = new BrowserWindow({
    width: 1000,
    height: 800,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true
    }
  })
  win.loadURL('https://www.tiktok.com')
}

app.whenReady().then(() => {
  createWindow()
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit()
})
EOF

# 3. Buat file package.json
cat <<EOF > package.json
{
  "name": "tiktok-app",
  "version": "1.0.0",
  "main": "main.js",
  "description": "TikTok desktop wrapper",
  "scripts": {
    "start": "electron ."
  }
}
EOF

# 4. Install Electron & Packager
npm install --save-dev electron@26 electron-packager

# 5. Build Aplikasi
npx electron-packager . $APP_NAME --platform=linux --arch=x64 --overwrite

# 6. Unduh ikon TikTok
wget -q -O "$APP_DIR/icon.png" "$ICON_URL"

# 7. Buat file .desktop supaya muncul di menu aplikasi
DESKTOP_FILE=~/.local/share/applications/tiktok.desktop

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=TikTok
Exec=$BUILD_DIR/$APP_NAME --no-sandbox
Icon=$APP_DIR/icon.png
Type=Application
Categories=Network;Video;
Terminal=false
EOF

chmod +x "$DESKTOP_FILE"
xdg-desktop-menu forceupdate

echo "✅ TikTok App berhasil dibuat dan muncul di menu aplikasi!"
