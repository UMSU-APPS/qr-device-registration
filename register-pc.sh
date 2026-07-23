#!/bin/bash

# 1. Ambil MAC Address antarmuka jaringan aktif
MAC_ADDR=$(cat /sys/class/net/$(ip route show default | awk '/default/ {print $5}')/address 2>/dev/null)

# 2. Ambil System UUID (Fallback ke CPU Serial untuk Raspberry Pi / Machine-ID)
if [ -f /sys/class/dmi/id/product_uuid ]; then
    SYSTEM_UUID=$(cat /sys/class/dmi/id/product_uuid 2>/dev/null)
else
    SYSTEM_UUID=$(grep -i 'serial' /proc/cpuinfo | awk '{print $3}')
fi

if [ -z "$SYSTEM_UUID" ]; then
    SYSTEM_UUID=$(cat /var/lib/dbus/machine-id 2>/dev/null)
fi

# 3. Konfigurasi Endpoint
SERVER_URL="https://api-absensi.irvan.cloud/api/register-device"
SECRET_KEY="Allahuakbar1213*" # Ubah sesuai environment backend Anda

# 4. Kirim Data via cURL
RESPONSE=$(curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d "{\"uuid\": \"$SYSTEM_UUID\", \"mac\": \"$MAC_ADDR\", \"secret\": \"$SECRET_KEY\"}")

TOKEN=$(echo "$RESPONSE" | grep -o '"oneTimeToken":"[^"]*' | grep -o '[^"]*$')

if [ -n "$TOKEN" ]; then
    echo "Registrasi Berhasil! Membuka browser..."
    xdg-open "https://absensi.umsu.ac.id/auth/claim-device?token=$TOKEN"
else
    echo "Gagal mendaftarkan perangkat. Respon Server: $RESPONSE"
fi
