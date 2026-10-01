# App Lock — Cara Kerja

Dokumen ini menjelaskan bagaimana fitur _App Lock_ di DompetQu bekerja, dari
persistensi, state, hingga tampilan layar kunci.

## 1. Arsitektur

Fitur ini dipisah menjadi 4 lapisan di `lib/features/app_lock/`:

| Lapisan         | File                                                              | Tanggung jawab                                             |
| --------------- | ----------------------------------------------------------------- | ---------------------------------------------------------- |
| `models/`       | `lock_method.dart`                                                | Enum `LockCredential` + `AppLockState`                     |
| `data/`         | `app_lock_storage.dart`                                           | Persistensi via `SharedPreferences`, hashing SHA-256       |
| `application/`  | `app_lock_controller.dart`                                        | Sebagai **satu-satunya sumber state** dan logika bisnis    |
| `presentation/` | `app_lock_screen.dart`, `app_lock_setup_screen.dart`, `widgets/*` | UI layar kunci & pengaturan                                |

Semua state hidup di Riverpod: `AppLockController` (`@Riverpod(keepAlive: true)`)
dan `AppLockStorage` (`@Riverpod(keepAlive: true)`).

## 2. State: `AppLockState`

Terdefinisi di `models/lock_method.dart`:

```dart
class AppLockState {
  final bool isEnabled;          // app lock aktif/off
  final LockCredential credential; // kredensial wajib: pin | pattern
  final bool biometricEnabled;   // opsi tambahan: biometrik aktif?
  final bool locked;             // sedang terkunci?
  final int failedAttempts;      // jumlah percobaan gagal
  final DateTime? lockoutUntil;  // kapan lockout selesai
}
```

`isLockedOut` = `lockoutUntil != null && DateTime.now() < lockoutUntil`.

Saat controller dibangun (`build()`), ia membaca storage dan menghasilkan:
`enabled`, `credential`, `biometricEnabled`, `locked = enabled`.

### Model kombinasi

App lock punya **satu kredensial wajib** (`LockCredential.pin` /
`LockCredential.pattern`) dan **biometrik sebagai opsi tambahan**
(`biometricEnabled`). Jadi kombinasi yang didukung:

- `PIN` saja
- `Pola` saja
- `PIN + Biometrik`
- `Pola + Biometrik`

Biometrik **tidak pernah berdiri sendiri** — selalu butuh PIN/pola sebagai
fallback, sehingga layar kunci tidak pernah buntu saat biometrik gagal.

## 3. Alur redirect router

`lib/main.dart` memakai `GoRouter` dengan dua `ref.listen`:

1. **`sessionControllerProvider`** → refresh router saat status login berubah.
2. **`appLockControllerProvider`** → refresh saat nilai `locked` berubah.

Logika redirect di `appRouter`:

- Autentikasi gagal → `/auth`.
- Success + app lock **enabled** + `locked == true` → diarahkan ke `/app-lock`.
- Begitu `locked` menjadi `false` (berhasil unlock) → redirect balik ke `/`.
  Artinya `AppLockScreen` **tidak perlu memanggil `context.pop()` sendiri**;
  perubahan state-lah yang melemparnya keluar layar kunci.

## 4. Layar kunci: `AppLockScreen`

`presentation/app_lock_screen.dart` — `ConsumerStatefulWidget`.

### 4.1 Build & state

```dart
final lockAsync = ref.watch(appLockControllerProvider);
final lockState = lockAsync.value;
```

- `lockState == null` (masih load) → `CircularProgressIndicator`.
- `lockState.isLockedOut` → layar lockout.
- Selain itu → konten berdasarkan `credential`.

Layar berisi `AnnotatedRegion` (status bar transparan + ikon terang), `PopScope`
(`canPop: false` → tombol back tidak bisa keluar dari layar kunci), dan `Scaffold`
dengan gradient gelap + `SafeArea`.

Konten memakai `Column` + `Spacer` (icon/title/hint di atas, input di tengah,
tombol biometrik di bawah):

- ICON `lock_outline` + judul "DompetQu Terkunci".
- Hint (atau `_errorText` merah saat gagal).
- Input sesuai `credential`:
  - **PIN** → `PinInput` inline (6 kotak).
  - **Pola** → tombol fallback + dialog otomatis (lihat §4.3).
- Jika `biometricEnabled` → `BiometricButton` sebagai **opsi buka cepat** di
  bawah. User boleh pilih biometrik ATAU masukkan PIN/pola.

### 4.2 PIN inline

`PinInput` adalah 6 `TextField` terpisah (1 digit per kotak, `obscureText`).
Saat lengkap → `onCompleted(pin)`:

```dart
final ok = await ref.read(appLockControllerProvider.notifier).unlockWithPin(pin);
if (!ok) {
  _errorText = 'PIN salah. Coba lagi.';
  _pinKey.currentState?.clear();   // reset + fokus balik ke kotak pertama
}
```

### 4.3 Pattern dalam dialog

Karena pola lebih nyaman di area khusus, input pola **tidak inline** — ia muncul
dalam `AlertDialog` (`_showPatternDialog`).

- `_schedulePatternDialogIfNeeded` dipanggil di `build()`: jika
  `credential == pattern`, `!isLockedOut`, dan dialog belum terbuka → dialog
  dijadwalkan lewat `addPostFrameCallback`.
- Dialog `barrierDismissible: false` → tidak bisa ditutup dengan tap di luar.
- Error ("Pola salah. Coba lagi.") tampil **di dalam dialog** lewat
  `StatefulBuilder` + variabel lokal `dialogError`.
- `navigator.pop()` dipanggil pada dua kondisi:
  1. Unlock sukses → dialog tertutup, router-refresh mengarahkan keluar.
  2. Masuk lockout → dialog ditutup agar layar lockout + countdown terlihat.
- Lewat tombol fallback "Gambarkan pola" dialog bisa dibuka ulang (disabled saat
  dialog aktif).

## 5. Biometrik sebagai opsi + double-prompt

Biometrik di layar kunci bekerja via **`BiometricButton`**
(`widgets/biometric_button.dart`) — widget mandiri yang mengecek ketersediaan
biometrik lalu **memverifikasi via `LocalAuthentication`** sendiri. Setelah
sukses ia memanggil `onAuthenticated`.

**Gotcha:** menghubungkan `BiometricButton.onAuthenticated` ke
`unlockWithBiometric()` akan memancing **dua prompt OS berurutan**. Karena itu
layar kunci memanggil `completeUnlock()`:

```dart
void completeUnlock() {
  final current = state.value;
  if (current == null || current.isLockedOut) return;
  _resetAttempts();
  _setLocked(false);   // locked=false -> router refresh -> keluar layar kunci
}
```

`completeUnlock` **tidak memunculkan prompt lagi** — verifikasi sudah dilakukan
oleh `BiometricButton`. `unlockWithBiometric()` tetap ada untuk pemanggil yang
belum terverifikasi.

Jika perangkat tak punya biometrik, `BiometricButton` render
`SizedBox.shrink()` dan user tetap bisa buka lewat PIN/pola (kredensial wajib
selalu ada).

## 6. Mekanisme lockout

Konstanta di `app_lock_controller.dart`:

```dart
const int _kMaxFailedAttempts = 5;
const Duration _kLockoutDuration = Duration(minutes: 1);
```

Alur `_incrementFailedAttempts`:

1. Gagal → `failedAttempts + 1`.
2. Jika `failedAttempts >= 5`:
   - `lockoutUntil = DateTime.now() + 1 menit`.
   - `_startLockoutTimer(1 menit)` → saat timer habis, `_resetAttempts()`
     mengosongkan percobaan & lockout.
3. Jika masih `< 5` → hanya memperbarui `failedAttempts`.

`_resetAttempts` juga dipanggil saat berhasil unlock (reset sebelum dipakai).

### Countdown yang berjalan

`_buildLockout` menghitung `remaining` sekali — tanpa refresh, teks countdown
akan beku. Karena itu ada `_scheduleCountdownTicks()`: `Timer.periodic(1 detik)`
yang me-rebuild layar selama `isLockedOut`, lalu berhenti sendiri saat lockout
selesai. Timer di-cancel di `dispose()`.

## 7. Sistem verifikasi & storage

`AppLockStorage` (`data/app_lock_storage.dart`) memakai `SharedPreferences`:

| Key                      | Isi                                       |
| ------------------------ | ----------------------------------------- |
| `app_lock_enabled`       | `bool` aktif/nonaktif                     |
| `app_lock_credential`    | nama enum `LockCredential` (pin/pattern)  |
| `app_lock_biometric`     | `bool` opsi biometrik aktif               |
| `app_lock_pin_hash`      | salted SHA-256 dari PIN                   |
| `app_lock_pattern_hash`  | salted SHA-256 dari pola                  |
| `app_lock_salt`          | salt acak 16-byte (dibuat ulang tiap save) |

`savePin`/`savePattern` selalu membuat salt baru, lalu hash
`utf8('<input>:<salt>')` dengan SHA-256, dan menyimpan `credential` yang sesuai.
Verifikasi membandingkan hash; tidak ada penyimpanan PIN/pola plaintext.

`savePin` menimpa hash PIN + set credential `pin`; `savePattern` menimpa hash
pola + set credential `pattern`. Keduanya tidak mengubah flag biometrik.

### Migrasi dari format lama

Format lama (`app_lock_method` satu nilai: `pin`/`pattern`/`biometric`)
dimigrasikan sekali di `getCredential()`:

- `pin` → credential `pin`
- `pattern` → credential `pattern`
- `biometric` → credential `pin` (default) + `app_lock_biometric = true`

Key lama (`app_lock_method`) dihapus setelah migrasi.

### Perbaikan otomatis (self-healing reset)

`ensureUsable()` (dipanggil di `build()` controller saat startup) mengecek:
jika app lock **aktif** tetapi salt/hash kredensial (PIN/pola) **tidak
tersimpan** (mis. sisa data dari mode biometric-only lama), seluruh data app
lock di-reset penuh (`_resetAll`) sehingga aplikasi jadi terbuka dan user bisa
setup ulang — mencegah layar kunci tanpa jalur buka (lockout permanen).

Cara reset manual di device debug: `adb shell run-as id.dompetqu.dompetqu rm
shared_prefs/FlutterSharedPreferences.xml`, atau hapus data aplikasi dari
Settings.

## 8. Pengaturan: `AppLockSetupScreen`

User memilih **kredensial** (PIN atau Pola) dan **opsional biometrik**
(switch, hanya tampil jika perangkat mendukung `canCheckBiometrics`).

- Kredensial baru: pilih PIN/Pola → masukkan → konfirmasi → tombol "Aktifkan"
  (`setupPin`/`setupPattern` dengan `biometricEnabled` sesuai toggle).
- Sudah aktif: kartu status menampilkan kredensial + status biometrik. Toggle
  biometrik langsung memanggil `enableBiometric()`/`disableBiometric()`.
  Mengganti kredensial memakai alur yang sama dan **mempertahankan** nilai
  biometrik yang sedang aktif.
- "Nonaktif" → konfirmasi lalu `disableLock()` menghapus semua state.

## 9. Ringkasan alur unlock

```
masuk /app-lock
  -> build() -> credential?
      pin      -> PinInput inline -> unlockWithPin
      pattern  -> dialog dibuka otomatis -> unlockWithPattern
  + biometricEnabled -> BiometricButton tersedia (opsi buka cepat)

gagal -> error / clear input / failedAttempts++
  5x   -> lockout 1 menit (dinamis countdown), input terkunci
sukses -> _resetAttempts + locked=false
      -> ref.listen(appLockControllerProvider) -> router.refresh()
      -> redirect ke '/', layar kunci ter-leave
```

## 10. Catatan & edge cases

- **`PopScope canPop: false`** — user tidak bisa back-nav keluar layar kunci.
- **Biometrik tak tersedia** — `BiometricButton` render `SizedBox.shrink()`;
  PIN/pola tetap jadi jalur buka.
- **Kredensial wajib selalu ada** — model ini menghapus mode biometric-only agar
  layar kunci tidak pernah buntu saat biometrik `PlatformException`.
- Lockout menutup dialog pola; setelah lockout usai, dialog pola dibuka ulang
  otomatis oleh `_schedulePatternDialogIfNeeded`.