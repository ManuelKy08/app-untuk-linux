#!/bin/bash

APP_NAME="WhatsAppWeb"
APP_DIR=~/AppBuilds/whatsapp-app
BUILD_DIR="$APP_DIR/$APP_NAME-linux-x64"
ICON_URL="https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg"

echo "[*] Membuat folder aplikasi..."
mkdir -p "$APP_DIR"
cd "$APP_DIR" || exit 1

echo "[*] Membuat file main.js..."
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
  win.loadURL('https://web.whatsapp.com')
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

echo "[*] Membuat file package.json..."
cat <<EOF > package.json
{
  "name": "whatsapp-app",
  "version": "1.0.0",
  "main": "main.js",
  "description": "WhatsApp Web Desktop",
  "scripts": {
    "start": "electron ."
  }
}
EOF

echo "[*] Menginstal Electron dan Electron Packager..."
npm install --save-dev electron@26 electron-packager

echo "[*] Membangun aplikasi..."
npx electron-packager . $APP_NAME --platform=linux --arch=x64 --overwrite

echo "[*] Mengunduh ikon..."
wget -q -O "$APP_DIR/whatsapp.svg" "$ICON_URL"

echo "[*] Mengubah ikon SVG ke PNG..."
sudo apt install librsvg2-bin -y
rsvg-convert -w 256 -h 256 "$APP_DIR/whatsapp.svg" -o "$APP_DIR/whatsapp.png"

echo "[*] Membuat shortcut di desktop..."
DESKTOP_FILE=~/.local/share/applications/whatsapp.desktop

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=WhatsApp Web
Comment=Aplikasi WhatsApp berbasis Web
Exec=$BUILD_DIR/$APP_NAME --no-sandbox
Icon=$APP_DIR/whatsapp.png
Terminal=false
Type=Application
Categories=Network;Chat;
EOF

chmod +x "$DESKTOP_FILE"
xdg-desktop-menu forceupdate
update-desktop-database ~/.local/share/applications

echo "✅ WhatsApp Web berhasil dibuat dan muncul di menu aplikasi!"
