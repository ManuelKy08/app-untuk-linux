#!/bin/bash

APP_NAME="InstagramWeb"
BUILD_DIR="$HOME/AppBuilds"
OUTPUT_DIR="$BUILD_DIR/${APP_NAME}-linux-x64"

# Pastikan Nativefier terinstal
if ! command -v nativefier &> /dev/null; then
  echo "[*] Menginstal Nativefier dan dependensi..."
  sudo apt update
  sudo apt install -y nodejs npm
  sudo npm install -g nativefier
fi

# Bangun Web App
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "[*] Membangun $APP_NAME..."
nativefier --name "$APP_NAME" \
  --platform linux \
  --arch x64 \
  --single-instance \
  --disable-context-menu \
  --disable-dev-tools \
  --tray \
  --width 400 \
  --height 700 \
  --counter \
  https://www.instagram.com

# Cek apakah berhasil dibangun
if [ ! -d "$OUTPUT_DIR" ]; then
  echo "[!] Gagal menemukan folder hasil build: $OUTPUT_DIR"
  exit 1
fi

# Struktur .deb
echo "[*] Menyiapkan struktur .deb..."
mkdir -p instagram-web/DEBIAN
mkdir -p instagram-web/usr/bin
mkdir -p instagram-web/usr/share/applications
mkdir -p instagram-web/usr/share/icons/hicolor/256x256/apps

# Salin aplikasi
cp -r "$OUTPUT_DIR" instagram-web/usr/bin/instagram-web

# Buat launcher
echo '#!/bin/bash
/usr/bin/instagram-web/InstagramWeb' > instagram-web/usr/bin/instagram
chmod +x instagram-web/usr/bin/instagram

# Unduh ikon Instagram
wget -O instagram-web/usr/share/icons/hicolor/256x256/apps/instagram.png https://upload.wikimedia.org/wikipedia/commons/a/a5/Instagram_icon.png

# Buat .desktop entry
cat <<EOF > instagram-web/usr/share/applications/instagram.desktop
[Desktop Entry]
Name=Instagram Web
Exec=instagram
Icon=instagram
Type=Application
Categories=Network;Social;
StartupNotify=true
EOF

# Buat file control
cat <<EOF > instagram-web/DEBIAN/control
Package: instagram-web
Version: 1.0
Section: web
Priority: optional
Architecture: amd64
Depends: libgtk-3-0, libnotify4, libnss3, libxss1, libxtst6, xdg-utils
Maintainer: Mr.Kokok <mrkokok@parrotos.local>
Description: Instagram Web App for Linux - Packaged with Nativefier
EOF

# Build .deb
echo "[*] Membangun file .deb..."
dpkg-deb --build instagram-web

echo "[✓] Selesai! File .deb kamu siap: $BUILD_DIR/instagram-web.deb"
