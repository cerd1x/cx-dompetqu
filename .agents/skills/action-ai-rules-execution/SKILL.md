---
name: action-ai-rules-execution
description: Rules for AI behavior when executing scripts and actions on the project. Use when running commands, scripts, or performing automated actions in the codebase.
---

# Action AI Rules Execution

Rules ketika AI menjalankan action/script pada project ini (`cx-dompetqu`).

## Rules

### 1. Selalu Paparkan Command Terlebih Dahulu

Sebelum menjalankan command apapun, AI **WAJIB** menampilkan command yang akan dijalankan dan menunggu konfirmasi user.

```
Command yang akan dijalankan: `flutter pub get`
Konfirmasi? (y/n)
```

### 2. Jangan Jalankan Command Secara Otomatis

- ❌ Tidak boleh langsung eksekusi command tanpa ijin user
- ❌ Tidak boleh menggabungkan beberapa command dalam satu run tanpa persetujuan
- ✅ Tunggu user konfirmasi setiap command satu per satu

### 3. Kategori Command & Aturan

| Kategori       | Contoh                                                    | Aturan                                                |
| -------------- | --------------------------------------------------------- | ----------------------------------------------------- |
| **Read-only**  | `flutter analyze`, `flutter test`, `dart format --set-exit-if-changed .` | Boleh sarankan, tetap minta konfirmasi |
| **Mutasi**     | `flutter pub add/remove`, edit `pubspec.yaml`             | Minta konfirmasi, jelaskan dampaknya                 |
| **Codegen**    | `dart run build_runner build`, `flutter pub run build_runner` | **WAJIB** konfirmasi + cek diff `.g.dart`/`.freezed.dart` |
| **Build**      | `flutter build apk/linux/windows/web`                     | Minta konfirmasi, jelaskan output yang dihasilkan    |
| **Dev Server** | `flutter run -d linux`                                    | Jangan jalankan — biarkan user menjalankan sendiri   |
| **Deploy**     | publish ke Play Store/Store/FlutterHub                    | **WAJIB** konfirmasi + versioning                     |

### 4. Urutan Eksekusi

Ketika task membutuhkan beberapa command, jalankan secara **berurutan dan terpisah**:

1. Jalankan command pertama → tunggu hasil
2. Jika berhasil, baru paparkan command berikutnya → tunggu konfirmasi user
3. Ulangi sampai selesai

Jangan skip urutan hanya karena command sebelumnya berhasil.

### 5. Handle Error dengan Benar

- Jika command gagal, **jangan langsung auto-fix** — paparkan error-nya dulu
- Jelaskan penyebab error secara singkat
- Tawarkan solusi, tapi tetap tunggu user pilih solusi mana yang dijalankan

### 6. Type Checking & Linting

- ketika ai melakukan execution pada project mu dalam mode development analisa maupun cek error maka gunakan:
- ✅ `flutter analyze` untuk analisis static seluruh project
- ✅ `dart format .` untuk formatting
- ✅ `flutter test` untuk test suite
- ❌ Tidak ada `bun run`, `rs:check`, atau `oxlint` di project ini

### 7. Codegen (Riverpod / Freezed / JSON)

- `dart run build_runner build --delete-conflicting-outputs` — regenerate `.g.dart` & `.freezed.dart`
- **WAJIB** review generated files sebelum commit; jangan edit manual file `.g.dart`
- Jika menambah field pada model Freezed, selalu regenerate

### 8. GraphQL Client

- Query/mutation di app ditulis manual di `lib/features/*/data/*_remote_source.dart`
- Tidak ada codegen GraphQL di project ini — berubah manual
- Root URL dikonfigurasi lewat `--dart-define=API_BASE_URL=...` (lihat `lib/core/config/api_config.dart`)

### 9. Script Custom

- Jika ada script di `tool/` atau `scripts/`, **WAJIB** baca isi script dulu sebelum menjalankan
- Jangan jalankan script yang belum dibaca isinya
- Paparkan apa yang dilakukan script tersebut ke user

### 10. Environment Variables

- ❌ Jangan hardcode secrets atau API keys dalam command
- ❌ Jangan print environment variables yang sensitif
- ✅ Gunakan `--dart-define=` atau file `.env` yang di-load runtime untuk konfigurasi
- ✅ Jika command butuh env tertentu, paparkan apa yang dibutuhkan tanpa value-nya

## Referensi Command yang Tersedia

| Command                                              | Keterangan                          | Kategori      |
| ---------------------------------------------------- | ----------------------------------- | ------------- |
| `flutter pub get`                                    | Install dependency                  | Install       |
| `flutter pub add <pkg>` / `flutter pub remove <pkg>`  | Tambah/hapus dependency             | Mutasi        |
| `dart run build_runner build --delete-conflicting-outputs` | Regenerate Riverpod/Freezed | Codegen       |
| `flutter analyze`                                    | Analisis static                    | Read-only     |
| `flutter test`                                       | Jalankan test suite                 | Read-only     |
| `dart format .`                                      | Format seluruh Dart                 | Mutasi (file) |
| `flutter build linux`                                | Build desktop Linux                 | Build         |
| `flutter build windows`                              | Build desktop Windows               | Build         |
| `flutter build apk`                                  | Build Android                       | Build         |
| `flutter build web`                                  | Build web                           | Build         |
| `flutter run -d linux`                               | Run desktop Linux                   | Dev Server    |
| `flutter run -d chrome --dart-define=API_BASE_URL=...`| Run web dengan backend custom      | Dev Server    |

## Konfigurasi Backend

- Default `API_BASE_URL` mengarah ke web app (`/api/graphql`).
- Untuk mengarah langsung ke `cx-services`, endpoint GraphQL adalah `/graphql` tanpa prefix `/api` — `api_config.dart` saat ini selalu memakai `/api/graphql`, jadi hanya lewat web.
- Selalu cek `lib/core/config/api_config.dart` sebelum ubah base URL.
