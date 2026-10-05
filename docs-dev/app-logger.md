# AppLogger — Panduan Penggunaan

`AppLogger` (`lib/core/logger/app_logger.dart`) adalah logger tunggal aplikasi
untuk fase beta. Semua log melewati satu instance (`AppLogger.instance`) yang
menyimpan ring buffer di memori, mencetak ke console, dan opsional menulis ke
file (`dompetqu.log` untuk semua level, `errors.log` khusus error).

## Ringkasan cepat

```dart
import '../../../core/logger/app_logger.dart';

AppLogger.instance.debug('pesan debug', tag: 'FiturSaya');
AppLogger.instance.info('pesan info', tag: 'FiturSaya');
AppLogger.instance.success('berhasil', tag: 'FiturSaya');
AppLogger.instance.warn('peringatan', tag: 'FiturSaya');
AppLogger.instance.error('gagal', tag: 'FiturSaya', error: e, stackTrace: st);
```

`tag` opsional tapi sangat disarankan: dipakai untuk memfilter log per fitur.

## Level log

Enum `LogLevel` (`lib/core/logger/log_level.dart`) berurutan dari paling rendah
ke paling tinggi:

```
debug < info < success < warn < error
```

Setiap pemanggilan `_add` akan membandingkan `level.index` dengan `minLevel`.
Log yang levelnya di bawah `minLevel` akan **dibuang** (tidak masuk buffer,
console, maupun file).

## Mengatur level minimum

Default `LogLevel.debug` — semua log direkam. Ubah lewat setter `minLevel`,
umumnya saat startup:

```dart
AppLogger.instance.minLevel = LogLevel.info; // buang log debug
```

Atau dari layar pengaturan/debug:

```dart
AppLogger.instance.minLevel = LogLevel.warn;
```

## Mencatat error dengan detail

Method `error` menerima `error` dan `stackTrace` sehingga detail tipe error
ikut tercatat:

```dart
try {
  await sesuatu();
} catch (e, st) {
  AppLogger.instance.error(
    'Gagal load data',
    tag: 'FiturSaya',
    error: e,
    stackTrace: st,
  );
}
```

Untuk level `debug`/`info`/`warn` tidak ada parameter `error`; bungkus detail
manual lewat `extras` bila perlu:

```dart
AppLogger.instance.debug(
  'Gagal submit',
  tag: 'FiturSaya',
  extras: {'error': '$e', 'stackTrace': '$st'},
);
```

## Hook global (crash tak tertangkap)

Pasang sekali saat startup (idempotent, aman untuk hot restart). Lihat
`lib/main.dart:39`:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.instance.installGlobalHooks();
  AppLogger.instance.info('App dimulai', tag: 'App');
  runApp(const DompetQuApp());
}
```

Setelah dipasang, `FlutterError.onError` dan `PlatformDispatcher.instance.onError`
otomatis masuk ke buffer dengan tag `FlutterError` / `Platform`.

## Logging ke file (opsional)

Hanya di platform non-web. `enableFileLogging()` menyalakan **dua** file di
`<dokumen app>/logs/`, keduanya dengan rotasi otomatis ke `*.old` saat melewati
`maxFileBytes` (256 KB):

| File          | Isi                                                |
| ------------- | -------------------------------------------------- |
| `dompetqu.log`| Semua level yang lolos `minLevel`                  |
| `errors.log`  | Khusus `LogLevel.error` (termasuk crash global)    |

```dart
await AppLogger.instance.enableFileLogging();
```

### Lokasi default file log

Semua file ditulis ke subfolder `logs/` di dalam direktori dokumen aplikasi
(`getApplicationDocumentsDirectory()`):

| Platform | Path default                                                              |
| -------- | ------------------------------------------------------------------------- |
| Android  | `/data/user/0/id.dompetqu.dompetqu/app_flutter/logs/`                     |
| iOS      | `<app sandbox>/Documents/logs/`                                           |
| Linux    | `$XDG_DOCUMENTS_DIR/logs/` (biasanya `~/Documents/logs/`)                 |
| Web      | tidak didukung (logging file dilewati diam-diam)                          |

> Di Linux, `getApplicationDocumentsDirectory()` memakai XDG user dir
> (`$XDG_DOCUMENTS_DIR`, didefinisikan di `~/.config/user-dirs.dirs`, default
> `$HOME/Documents`) **tanpa** subfolder nama aplikasi. Bila user dir DOCUMENTS
> tidak dikonfigurasi, pemanggilan gagal dan `enableFileLogging()` hanya
> mencatat `warn` tanpa crash.

### Mengatur lokasi direktori log

Urutan resolusi direktori dasar: parameter `directory` → `logDirectory` →
`defaultLogDirectory()`.

```dart
// 1. Per panggilan
await AppLogger.instance.enableFileLogging(directory: Directory('/tmp/dompetqu'));

// 2. Set global sebelum enable
AppLogger.instance.logDirectory = Directory('/var/log/dompetqu');
// atau dari path string
AppLogger.instance.setLogDirectoryPath('/var/log/dompetqu');
await AppLogger.instance.enableFileLogging();

// 3. Default platform + resolusi manual
final dir = await AppLogger.defaultLogDirectory();
```

Override lewat environment variable (khusus desktop/Android — di Linux ini
cara paling praktis):

```bash
DOMPETQU_LOG_DIR=/tmp/dompetqu flutter run -d linux
# hasil: /tmp/dompetqu/logs/dompetqu.log & /tmp/dompetqu/logs/errors.log
```

`defaultLogDirectory()` mengembalikan `Directory(DOMPETQU_LOG_DIR)` bila
env diisi, jika tidak jatuh ke `getApplicationDocumentsDirectory()` platform.
Set `logDirectory`/`setLogDirectoryPath()` **sebelum** memanggil
`enableFileLogging()`; sink yang sudah aktif tidak berpindah otomatis.

File yang dihasilkan: `dompetqu.log`, `dompetqu.log.old`, `errors.log`,
`errors.log.old`.

Karena folder ini private di Android, baca lewat `adb` (root tidak diperlukan).

Cek status & path:

```dart
AppLogger.instance.fileLoggingEnabled;      // true bila dompetqu.log aktif
AppLogger.instance.errorFileLoggingEnabled; // true bila errors.log aktif
AppLogger.instance.logFilePath;
AppLogger.instance.errorLogFilePath;
```

Membaca file log di Android:

```bash
adb shell run-as id.dompetqu.dompetqu cat app_flutter/logs/dompetqu.log
adb shell run-as id.dompetqu.dompetqu cat app_flutter/logs/errors.log
```

### File error khusus (`errors.log`)

- Aktif otomatis bersama `enableFileLogging()` — tidak perlu langkah terpisah.
- Setiap record berlevel `LogLevel.error` otomatis ditulis ke sini, termasuk
  error dari `FlutterError.onError` dan `PlatformDispatcher.instance.onError`
  (tag `FlutterError`/`Platform`).
- Level lain **tidak** masuk ke file ini, jadi `errors.log` cocok untuk
  diperiksa cepat saat debugging.
- Rotasi ukuran sama seperti file utama (`errors.log.old`).
- Tiap baris memuat timestamp, level, tag, dan pesan (tipe error termasuk lewat
  `error:`); **stack trace tidak ditulis ke baris file** — ambil dari buffer
  lewat `exportJson()` bila butuh stack trace lengkap.

## Membaca & mengekspor log

```dart
final terbaru = AppLogger.instance.latest(200); // 200 baris terbaru
final teks = AppLogger.instance.exportText();   // gabungan teks
final json = AppLogger.instance.exportJson();   // List<Map> untuk laporan

final jumlahError = AppLogger.instance.errorCount;
final semua = AppLogger.instance.records; // buffer (read-only)

final fileErr = AppLogger.instance.lastFileError; // error tulis file terakhir
```

> Baris log yang gagal ditulis ke file **tidak dibuang**: `_FileSink` menahan
> antreannya dan mencoba lagi saat penulisan berikutnya. `lastFileError`
> menyimpan error terakhir, dan kegagalan juga dicetak via `debugPrint`
> dengan prefix `[AppLogger]`.

Contoh nyata ada di `lib/features/beta_report/beta_report_screen.dart` yang
menampilkan `latest(200)`, menyimpan `exportJson()`, dan mengirim laporan beta.

## Membersihkan buffer

```dart
AppLogger.instance.clear();
```

Menghapus buffer memori; bila file logging aktif, **kedua** file
(`dompetqu.log` dan `errors.log`) juga dikosongkan.

## Konstanta penting

| Konstanta             | Nilai          | Arti                                   |
| --------------------- | -------------- | -------------------------------------- |
| `maxBuffer`           | `300`          | Kapasitas baris di memori              |
| `maxFileBytes`        | `256 * 1024`   | Batas ukuran file sebelum rotate       |
| `logFileName`         | `dompetqu.log` | Nama file log (semua level)            |
| `errorLogFileName`    | `errors.log`   | Nama file log khusus error             |
| `logDirEnvKey`        | `DOMPETQU_LOG_DIR` | Env override direktori dasar log   |

## Rekomendasi pemakaian

- Pakai `tag` yang konsisten dengan nama controller/fitur.
- Bungkus `AppLogger.instance` sebagai field saat dipakai berulang, mis.
  `final _log = AppLogger.instance;` (lihat `assets_controller.dart`, dsb).
- Gunakan `success` untuk operasi yang selesai normal, `error` untuk kegagalan
  yang ditangkap, `warn` untuk kondisi tak terduga yang tidak fatal.
- Jangan log data sensitif (token, password, nomor kartu).
