cat > /home/cerd1x/Documents/cx-dompetqu/sec_reports.md << 'EOF'
# Laporan Keamanan - cx-dompetqu

**Tanggal:** Sat Oct 17 2026  
**Scope:** `lib/` (auth/session, admin panel, killswitch, cookie storage, network, logging)  
**Metode:** Static code review (read-only) + grep pola sensitif  
**Status:** Cukup solid. Ada 1 poin yang perlu diklarifikasi/perbaiki (P0), sisanya berupa _hardening_.

## 1. Executive Summary

Dari hasil review, tidak ditemukan hal berikut pada kode Flutter (`lib/`):

- Hardcoded secret, API key, password, atau token
- Celah injeksi yang jelas (_obvious injection_)
- Auth bypass terbuka
- Logging data sensitif ke `AppLogger`

Namun terdapat **inkonsistensi header autentikasi killswitch** antara client (`Authorization`) vs ekspektasi backend (`x-admin-token`) yang perlu diverifikasi. Selain itu, penyimpanan sesi berbasis `SharedPreferences` dan ketiadaan _TLS pinning_ layak menjadi prioritas _hardening_ mengingat aplikasi ini bersifat finansial.

## 2. Temuan Kritis & Tinggi

### [HIGH] Inkonsistensi header `x-admin-token` di Killswitch (Admin Panel)

- **File:** `lib/features/admin_pannel/data/killswitch_remote_source.dart:17–22`
- **Kode saat ini:**

  ```dart
  Map<String, String> _headers(String adminToken) => <String, String>{
        'Content-Type': 'application/json',
        'Authorization': adminToken,        // aktif
        // 'x-admin-token': adminToken,      // dikomentari
      };
