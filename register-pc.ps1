# 1. Ambil UUID Motherboard & MAC Address utama
$uuid = (Get-CimInstance -ClassName Win32_ComputerSystemProduct).UUID
$mac = (Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object -First 1).MacAddress

# 2. Konfigurasi Endpoint & Parameter
$serverUrl = "https://api-absensi.irvan.cloud/api/register-device"
$secretKey = "Allahuakbar1213*" # Ubah sesuai environment backend Anda

$body = @{
    uuid   = $uuid
    mac    = $mac
    secret = $secretKey
} | ConvertTo-Json

try {
    # 3. Kirim ke API Next.js / NestJS Backend
    $response = Invoke-RestMethod -Uri $serverUrl -Method POST -Body $body -ContentType "application/json"

    if ($response.success) {
        # 4. Buka browser dengan One-Time Token
        $claimUrl = "https://absensi.umsu.ac.id/auth/claim-device?token=" + $response.oneTimeToken
        Start-Process $claimUrl
    } else {
        Write-Host "Gagal: $($response.message)" -ForegroundColor Red
    }
} catch {
    Write-Host "Terjadi kesalahan saat terhubung ke server." -ForegroundColor Red
}
