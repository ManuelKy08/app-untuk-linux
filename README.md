## aplikasi desktop berbasis web untuk linux
syarat:
1. *-linux-x64
2. Ada environment X11 atau Wayland
3. dependensi wajib, libgtk, libx11, libnss, libasound

## Sampel Tampilan
<a href="https://freeimage.host/i/FMk2RpI"><img src="https://iili.io/FMk2RpI.md.jpg" alt="FMk2RpI.md.jpg" border="0"></a>

## instagram
1. chmod +x ig.sh
2. sudo dpkg -i ~/AppBuilds/instagram-web.deb

## X
1. chmod +x x.sh
2. ./build-x-twitter.sh
3. sudo dpkg -i ~/AppBuilds/twitter-web.deb


## Jaga-jaga jika terjadi error "dependency"
1. sudo apt --fix-broken install

## Kalau mariadb-server error, kamu bisa perbaiki dengan
1. sudo apt install mariadb-common
2. sudo dpkg --configure -a


## Langkah untuk ngebuat launcher di dekstop linux kalian
1. nano ~/.local/share/applications/instagram-web.desktop
2. Tekan CTRL + O, lalu ENTER untuk simpan
3. Tekan CTRL + X untuk keluar

## masukkan script ini ig
<pre>
[Desktop Entry]
Name=Instagram Web
Exec=/home/rrsec/AppBuilds/InstagramWeb-linux-x64/InstagramWeb --no-sandbox
Icon=/home/rrsec/AppBuilds/instagram-web/usr/share/icons/hicolor/256x256/apps/instagram.png
Type=Application
Categories=Network;Social;
StartupNotify=true
Terminal=false
</pre>

## masukkan script ini x
<pre>
[Desktop Entry]
Name=X Web
Comment=Twitter Web Desktop by Mr.Kokok
Exec=/home/rrsec/AppBuilds/TwitterWeb-linux-x64/TwitterWeb --no-sandbox
Icon=twitter
Terminal=false
Type=Application
Categories=Network;SocialNetworking;
</pre>

## masukkan script ini fb
<pre>
[Desktop Entry]
Name=Facebook Web
Exec=/home/rrsec/AppBuilds/facebook-app/FacebookWeb-linux-x64/FacebookWeb --no-sandbox
Icon=/home/rrsec/AppBuilds/facebook-app/icon.png
Terminal=false
Type=Application
Categories=Network;Social;
StartupNotify=true
</pre>

## masukkan script ini tiktok
<pre>
[Desktop Entry]
Name=TikTok Web
Comment=Aplikasi TikTok berbasis web
Exec=/home/rrsec/AppBuilds/tiktok-app/TikTokWeb-linux-x64/TikTokWeb --no-sandbox
Icon=/home/rrsec/AppBuilds/tiktok-app/tiktok.png
Terminal=false
Type=Application
Categories=Network;Video;
StartupNotify=true
</pre>

## masukkan script ini wa
<pre>
[Desktop Entry]
Name=WhatsApp Web
Comment=Aplikasi WhatsApp berbasis web
Exec=/home/rrsec/AppBuilds/whatsapp-app/WhatsAppWeb-linux-x64/WhatsAppWeb --no-sandbox
Icon=/home/rrsec/AppBuilds/whatsapp-app/whatsapp.png
Terminal=false
Type=Application
Categories=Network;InstantMessaging;
StartupNotify=true
</pre>

# Note
1. Ganti /home/rrsec/... sesuai rename linux kalian
2. nano name.sh
3. ctrl + shift v (untuk paste), lalu ctrl + x untuk keluar dan tekan y dan enter (untuk kombinasi keluar dan save)

## terakhir refresh cache agar ada di tampilan dekstop 
<pre>
update-desktop-database ~/.local/share/applications/
</pre>
