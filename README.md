# INVOTATION V22 — QR Device Pairing

## Tidak ada login
- Tidak ada Google OAuth.
- Tidak ada email.
- Tidak ada password.
- Tidak ada OTP.
- Setiap perangkat mendapat anonymous Supabase session otomatis.

## Pairing
Perangkat utama:
1. Sync -> Mulai Sync di Perangkat Ini.
2. Hubungkan Perangkat Baru.
3. QR tampil selama 10 menit dan hanya bisa dipakai sekali.

Perangkat kedua:
1. Sync -> Scan QR Perangkat Lain.
2. Scan QR perangkat utama.
3. Selesai.

Ada fallback Pilih Foto QR dan Masukkan Kode Pairing.

## Setup Supabase
1. Aktifkan Authentication -> Anonymous Sign-Ins.
2. Jalankan `supabase-schema.sql`.
3. Ambil Project URL + Publishable key.
4. Isi `cloud-config.js`.
5. Deploy.

Tidak perlu Google Cloud Console sama sekali.
