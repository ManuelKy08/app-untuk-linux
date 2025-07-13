#!/bin/bash

# Nama aplikasi
APP_NAME="twitter-web"
APP_TITLE="Twitter Web"
URL="https://twitter.com"
ICON_URL="https://upload.wikimedia.org/wikipedia/commons/6/6f/Logo_of_Twitter.svg"

# Lokasi build
BUILD_DIR="$HOME/AppBuilds"
APP_DIR="$BUILD_DIR/TwitterWeb-linux-x64"
DEB_NAME="$APP_NAME.deb"

echo "[*] Membuat folder build..."
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

echo "[*] Membuat app dari $URL..."
nativefier --name "$APP_TITLE" --icon "$ICON_URL" --disable-dev-tools --single-instance "$URL"

echo "[*] Menyiapkan struktur .deb..."
mkdir -p "$APP_NAME/usr/bin"
mkdir -p "$APP_NAME/usr/share/applications"
mkdir -p "$APP_NAME/usr/share/icons/hicolor/256x256/apps"

# Copy file binary
cp -r "$APP_DIR/"* "$APP_NAME/usr/bin/$APP_NAME"

# Unduh icon
echo "[*] Mengunduh icon..."
wget -O "$APP_NAME/usr/share/icons/hicolor/256x256/apps/$APP_NAME.png" "$ICON_URL"

# Buat file desktop
cat <<EOF > "$APP_NAME/usr/share/applications/$APP_NAME.desktop"
[Desktop Entry]
Name=Twitter Web
Exec=/usr/bin/$APP_NAME/$APP_TITLE --no-sandbox
Icon=$APP_NAME
Type=Application
Categories=Network;Social;
StartupNotify=true
Terminal=false
EOF

# Buat control file
mkdir -p "$APP_NAME/DEBIAN"
cat <<EOF > "$APP_NAME/DEBIAN/control"
Package: $APP_NAME
Version: 1.0
Section: web
Priority: optional
Architecture: amd64
Maintainer: Mr.Kokok
Description: Twitter Web App versi Desktop untuk Parrot OS (.deb)
EOF

# Bangun .deb
echo "[*] Membangun file .deb..."
dpkg-deb --build "$APP_NAME"
mv "$APP_NAME.deb" "$BUILD_DIR/$DEB_NAME"
echo "[✓] Selesai! File .deb ada di: $BUILD_DIR/$DEB_NAME"
