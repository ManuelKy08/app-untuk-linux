#!/bin/bash

APP_NAME="DiscordWeb"
APP_DIR=~/AppBuilds/discord-app
BUILD_DIR="$APP_DIR/$APP_NAME-linux-x64"
ICON_URL="https://cdn-icons-png.flaticon.com/512/2111/2111370.png"

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
    icon: __dirname + '/icon.png',
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true
    }
  })
  win.loadURL('https://discord.com/app')
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
  "name": "discord-app",
  "version": "1.0.0",
  "main": "main.js",
  "description": "Discord desktop wrapper",
  "scripts": {
    "start": "electron ."
  }
}
EOF

# 4. Install Electron & Packager
npm install --save-dev electron@26 electron-packager

# 5. Build Aplikasi
npx electron-packager . $APP_NAME --platform=linux --arch=x64 --overwrite

# 6. Unduh ikon Discord
wget -q -O "$APP_DIR/icon.png" "$ICON_URL"

# 7. Buat file .desktop supaya muncul di menu aplikasi
DESKTOP_FILE=~/.local/share/applications/discord.desktop

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Discord Web
Exec=$BUILD_DIR/$APP_NAME --no-sandbox
Icon=$APP_DIR/icon.png
Type=Application
Categories=Network;Chat;
Terminal=false
EOF

chmod +x "$DESKTOP_FILE"
xdg-desktop-menu forceupdate

echo "✅ Discord Web App berhasil dibuat dan muncul di menu aplikasi!"
