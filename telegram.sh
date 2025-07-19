#!/bin/bash

APP_NAME="TelegramWeb"
APP_DIR=~/AppBuilds/telegram-app
BUILD_DIR="$APP_DIR/$APP_NAME-linux-x64"
ICON_URL="https://upload.wikimedia.org/wikipedia/commons/8/82/Telegram_logo.svg"

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
  win.loadURL('https://web.telegram.org/')
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
  "name": "telegram-app",
  "version": "1.0.0",
  "main": "main.js",
  "description": "Telegram desktop wrapper",
  "scripts": {
    "start": "electron ."
  }
}
EOF

# 4. Install Electron & Packager
npm install --save-dev electron@26 electron-packager

# 5. Build Aplikasi
npx electron-packager . $APP_NAME --platform=linux --arch=x64 --overwrite

# 6. Unduh ikon Telegram
wget -q -O "$APP_DIR/icon.png" "$ICON_URL"

# 7. Buat file .desktop supaya muncul di menu aplikasi
DESKTOP_FILE=~/.local/share/applications/telegram.desktop

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Telegram
Exec=$BUILD_DIR/$APP_NAME --no-sandbox
Icon=$APP_DIR/icon.png
Type=Application
Categories=Network;Chat;
Terminal=false
EOF

chmod +x "$DESKTOP_FILE"
xdg-desktop-menu forceupdate

echo "✅ Telegram App berhasil dibuat dan muncul di menu aplikasi!"
