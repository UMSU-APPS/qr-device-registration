#!/bin/bash

# Pastikan direktori autostart ada
mkdir -p ~/.config/autostart

# Copy file chromium-kiosk.desktop ke direktori autostart
cp chromium-kiosk.desktop ~/.config/autostart/chromium-kiosk.desktop
echo "Berhasil menyalin chromium-kiosk.desktop ke ~/.config/autostart/"

# Menjalankan script register-pc.sh
# Asumsi script ini berada di direktori yang sama
echo "Menjalankan register-pc.sh..."
./register-pc.sh

# Menjalankan reboot
echo "Sistem akan direboot sekarang..."
sudo reboot
