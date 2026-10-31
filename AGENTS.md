# AGENTS.md — cx-dompetqu

Aturan perilaku AI saat bekerja di repositori ini. Wajib dibaca sebelum
mengubah kode. Detail tambahan ada di `.agents/skills/` (lihat bagian "Skill").

## Ringkasan Proyek

Aplikasi dompet (finansial) — aplikasi Flutter untuk desktop (Linux/Windows/macOS) & mobile memakai Riverpod + go_router.

Aplikasi ini adalah sistem manajemen keuangan pribadi / bisnis kecil yang memungkinkan
pengguna mencatat, melacak, dan mengelola transaksi keuangan (pemasukan, pengeluaran,
transfer, hutang, dan piutang) secara terstruktur. Fitur utama meliputi:

- **Auth & App Lock** — autentikasi pengguna dan kunci aplikasi berbasis PIN/biometrik.
- **Order & Bookkeeping** — pembuatan transaksi penjualan, pengeluaran, pinjaman, dan
  pembayaran hutang; buku besar (ledger) dengan status pembayaran (`paid`/`unpaid`/`failed`)
  dan opsi retry manual melalui long-press/double-tap pada baris transaksi.
- **Dashboard & Statistik** — ringkasan bulanan pemasukan, pengeluaran, dan keuntungan
  dengan daftar transaksi terbaru.
- **Asset & Detail Transaksi** — tampilan detail aset dan riwayat transaksi per item.
- **Analytics & Charts** — visualisasi data keuangan (UI-only fitur tambahan).
- **Admin Panel & Kill Switch** — kontrol kill switch REST (`x-admin-token`) untuk
  admin, dapat mematikan/mengaktifkan operasi root GraphQL saat darurat.
- **Gen AI** — fitur AI generatif untuk asisten keuangan (Genkit Dart SDK 1.0).
- **Beta Report** — fitur pelaporan versi beta (UI-only).

Topologi backend (tanpa deploy, hanya HTTP/GraphQL):

```
cx-dompetqu ──HTTP/GraphQL──▶ cx-web (/api/*) ──▶ cx-services
                     atau langsung ───────────────▶ cx-services
```

Backend kontrak hidup di repo sibling `../cx-services` (Elysia + GraphQL Yoga +
Drizzle pada Cloudflare D1). Verifikasi endpoint/tipe ke `cx-services/*.md`,
`app.ts`, dan `domain/*/adapters/driving/graphql/*.gql` bila ragu.

## Arsitektur Aplikasi

Aplikasi ini menggunakan **Hexagonal Architecture** (Ports & Adapters) dengan pendekatan **Feature-First** yang dipadukan dengan Riverpod 3 untuk state management. Arsitektur ini memisahkan kode menjadi layer yang jelas untuk memudahkan pengembangan, testing, dan pemeliharaan.

### Prinsip Arsitektur

Aplikasi mengikuti pola **Presentation → Stores → Domain → Data**:

1. **Presentation Layer** (UI) — Screens dan widgets yang mengonsumsi state dari stores
2. **Stores Layer** (State Management) — Riverpod providers yang mengkomposisi repository dan memaparkan state ke UI
3. **Domain Layer** (Business Logic) — Entitas dan kontrak repository (interface), tanpa ketergantungan external
4. **Data Layer** (Implementation) — Implementasi repository, datasource, SDK, network, dan storage

**Catatan Penting**: AI agent **WAJIB** mengecek dan memperbarui AGENTS.md setiap kali ada perubahan infrastructure (struktur folder, naming convention, arsitektur layer) agar dokumentasi selalu sinkron dengan kondisi aktual aplikasi.

### Struktur Folder Per Fitur (Target)

Struktur folder standar yang digunakan untuk fitur-fitur yang telah bermigrasi ke pola baru:

```
<fitur>/
├── domain/
│   ├── models/                # Domain entities (contoh: Freezed immutable state)
│   ├── repositories/          # Repository interfaces (kontrak, abstract interface class)
│   └── usecases/              # Business use cases
├── adapters/                  # Data layer (implementasi konkret)
│   ├── datasources/           # Remote/local datasources
│   ├── models/                # Data models (JSON/GraphQL models)
│   ├── mappers/               # JSON/GraphQL → Entity converters
│   ├── repositories/          # Repository implementations (*Impl)
│   └── generated/             # Generated files (Freezed/json_serializable)
└── view/                      # UI layer
    ├── screens/                # Screens
    ├── widgets/                # Widget komponen
    └── stores/                 # Riverpod stores (@Riverpod providers)
```

Status migrasi struktur per fitur:

| Fitur        | Struktur                                          | Keterangan                                       |
| ------------ | ------------------------------------------------- | ------------------------------------------------ |
| admin_pannel | domain/adapters/view                              | Sudah migrasi                                    |
| app_lock     | domain/adapters/view                              | Sudah migrasi                                    |
| assets       | domain/adapters/view                              | Sudah migrasi                                    |
| analytics    | domain/adapters                                   | UI-only, belum lengkap                           |
| auth         | domain/adapters/view + legacy stores/             | Sudah migrasi, tersisa legacy `stores/` di root  |
| beta_report  | view (screens)                                    | UI-only, belum lengkap                           |
| charts       | view (screens)                                    | UI-only, belum lengkap                           |
| contacts     | domain/adapters/view                              | Sudah migrasi                                    |
| dashboard    | domain/adapters/view                              | Sudah migrasi                                    |
| gen_ai       | domain/adapters/view + legacy presentation/stores | Sedang migrasi                                   |
| inventory    | domain/data/presentation                          | Belum migrasi (gunakan `data/`, `presentation/`) |
| order        | domain/data/presentation                          | Belum migrasi                                    |
| portfolio    | domain/data/presentation                          | Belum migrasi                                    |
| settings     | domain/data/presentation                          | Belum migrasi                                    |
| statistics   | domain/data/presentation                          | Belum migrasi                                    |
| struct       | domain/data/presentation                          | Belum migrasi                                    |
| transactions | domain/data/presentation                          | Belum migrasi                                    |

Features `analytics`, `beta_report`, dan `charts` adalah UI-only, hanya memiliki layer presentation tanpa repository/domain boilerplate.

### Teknologi Utama

- **Framework**: Flutter (desktop & mobile)
- **State Management**: Riverpod 3 dengan codegen (`@Riverpod`, `@riverpod`)
- **Routing**: go_router dengan `appRouterProvider`
- **State Models**: Freezed 4 untuk immutable state dengan `@Default`
- **Serialization**: json_serializable untuk JSON/GraphQL models
- **Networking**: GraphQL (manual string queries) + HTTP untuk REST endpoints
- **Session Management**: Cookie-based dengan `CookieAwareClient`
- **Theme**: Custom design system dengan paket `mix` untuk styling

## Struktur Folder

```
lib/
├── main.dart                          # Entry point aplikasi, inisialisasi router
│
├── core/                              # Layer core yang digunakan seluruh fitur
│   ├── config/                        # Konfigurasi aplikasi
│   │   └── api_config.dart           # baseUrl, graphqlEndpoint, killswitchEndpoint
│   │
│   ├── graphql/                       # GraphQL client & utilities
│   │   ├── graphql_providers.dart    # GraphQLClient tunggal (HttpLink + cookie client)
│   │   └── generated/                 # Generated Riverpod providers
│   │
│   ├── logger/                        # Logging system
│   │   ├── app_logger.dart           # Singleton logger
│   │   ├── log_level.dart            # Definisi level log
│   │   ├── log_record.dart           # Model log record
│   │   └── log_config.dart           # Konfigurasi logger
│   │
│   ├── network/                       # Network layer
│   │   ├── cookie_aware_client.dart  # HTTP client dengan cookie management
│   │   └── generated/                 # Generated Freezed models
│   │
│   ├── theme/                         # Design system & styling
│   │   ├── app_theme.dart            # Theme configuration
│   │   ├── ui_style.dart             # Sumber kebenaran look & feel
│   │   ├── ui_style_controller.dart  # Riverpod controller untuk UiStyle
│   │   ├── dompet_brand.dart         # Brand colors & constants
│   │   ├── cs_mix.dart               # Konfigurasi paket mix
│   │   ├── cs_dialog.dart            # Dialog utilities
│   │   └── widgets/                  # Reusable brand widgets
│   │       ├── dompet_button.dart
│   │       ├── dompet_card.dart
│   │       ├── dompet_text_field.dart
│   │       ├── dompet_avatar.dart
│   │       ├── dompet_badge.dart
│   │       ├── dompet_combobox.dart
│   │       ├── dompet_gradient_background.dart
│   │       ├── balance_input_field.dart
│   │       ├── pin_input.dart
│   │       ├── biometric_button.dart
│   │       ├── cs_glass.dart
│   │       ├── cs_dialog.dart
│   │       ├── cs_nav_bar.dart
│   │       ├── scroll_refresh_wrapper.dart
│   │       ├── round_action_button.dart
│   │       ├── item_menu.dart
│   │       ├── data_states.dart
│   │       └── placeholders.dart
│   │
│   ├── utils/                         # Utility functions
│   │   ├── balance.dart              # Format & hitung balance
│   │   └── formatters.dart           # Format tanggal, angka, dll.
│   │
│   └── diagnostics/                   # Development tools
│       └── fps_indicator.dart        # FPS monitoring (dev only)
│
└── features/                          # Feature-based modules
    │
    ├── auth/                          # Fitur autentikasi
    │   ├── domain/                    # Business logic & entities
    │   │   ├── entities/              # Domain entities (pure Dart)
    │   │   │   └── generated/         # Freezed generated files
    │   │   ├── failures/              # Error definitions
    │   │   ├── repositories/         # Repository interfaces (contracts)
    │   │   └── usecases/              # Business use cases
    │   │
    │   ├── data/                      # Data layer implementation
    │   │   ├── datasources/           # Remote/local data sources
    │   │   ├── repositories/          # Repository implementations
    │   │   ├── mappers/               # JSON/GraphQL → Entity converters
    │   │   └── generated/             # Freezed/json_serializable generated
    │   │
    │   ├── stores/                    # Riverpod state management
    │   │   ├── *_store.dart           # Store dengan @Riverpod
    │   │   ├── *_repository_provider.dart # DI untuk repository
    │   │   └── generated/             # Riverpod codegen
    │   │
    │   ├── presentation/              # UI layer
    │   │   ├── auth_screen.dart       # Screens
    │   │   └── ...                    # Widgets komponen
    │   │
    │   └── models/                    # Legacy data models (sebagian)
    │       └── generated/            # Generated files
    │
    ├── app_lock/                      # Fitur kunci aplikasi (PIN/biometrik)
    │   ├── domain/
    │   │   ├── entities/              # AppLockState entity
    │   │   └── repositories/          # AppLockRepository interface
    │   ├── data/
    │   │   ├── datasources/           # Local & biometric datasources
    │   │   ├── repositories/          # AppLockRepositoryImpl
    │   │   └── generated/
    │   ├── stores/                    # Riverpod stores
    │   ├── presentation/              # Screens (AppLockScreen, SetupScreen)
    │   └── models/                    # LockMethod enum
    │
    ├── admin_pannel/                  # Fitur admin panel (typo "panel")
    │   ├── domain/
    │   │   ├── entities/              # DisabledOperation entity
    │   │   └── repositories/          # KillswitchRepository interface
    │   ├── data/
    │   │   ├── datasources/           # KillswitchRemoteSource (REST)
    │   │   ├── repositories/          # KillswitchRepositoryImpl
    │   │   ├── graphql_operations.dart # Daftar 74 operation root
    │   │   └── generated/
    │   ├── stores/                    # Riverpod stores
    │   └── presentation/              # AdminScreen, KillswitchControllScreen
    │
    ├── assets/                        # Fitur manajemen aset (SUDAH MIGRASI KE STRUKTUR BARU)
    │   ├── domain/
    │   │   ├── models/                # Asset, AssetMutation entities (sebelumnya entities/)
    │   │   ├── repositories/          # AssetRepository interface
    │   │   └── usecases/              # Business use cases (kosong untuk sekarang)
    │   ├── adapters/                  # Data layer (sebelumnya data/)
    │   │   ├── datasources/           # AssetsRemoteSource (GraphQL)
    │   │   ├── models/                # Asset, AssetMutation data models
    │   │   ├── mappers/               # JSON/GraphQL → Entity converters
    │   │   ├── repositories/          # Repository implementations
    │   │   └── generated/             # Freezed/json_serializable generated
    │   └── view/                      # UI layer (sebelumnya presentation/ + stores/)
    │       ├── screens/                # AssetsScreen, AssetDetailScreen, dialogs
    │       ├── widgets/                # Widget komponen (dialogs, forms, dll)
    │       └── stores/                # Riverpod stores
    │
    ├── dashboard/                     # Fitur dashboard/statistik
    │   ├── domain/
    │   │   ├── repositories/          # HomeRepository (agregat port)
    │   │   └── entities/              # Dashboard entities
    │   ├── data/
    │   │   └── repositories/          # HomeRepositoryImpl (komposisi fitur)
    │   ├── stores/                    # Riverpod stores
    │   └── presentation/              # Dashboard screen & widgets
    │
    ├── gen_ai/                        # Fitur AI generatif (Genkit Dart SDK 1.0)
    │   ├── domain/
    │   │   ├── entities/              # AI-related entities
    │   │   └── repositories/          # AI repository interfaces
    │   ├── data/
    │   │   ├── repositories/          # AI repository implementations
    │   │   └── generated/
    │   ├── stores/                    # Riverpod stores
    │   └── presentation/              # AI assistant screens
    │
    ├── order/                         # Fitur order & transaksi
    │   ├── domain/
    │   │   ├── entities/              # Order, Transaction entities
    │   │   └── repositories/          # OrderRepository interface
    │   ├── data/
    │   │   ├── datasources/           # OrderRemoteSource (GraphQL)
    │   │   ├── repositories/          # OrderRepositoryImpl
    │   │   └── generated/
    │   ├── stores/                    # Riverpod stores
    │   └── presentation/              # Order screen & widgets
    │
    ├── settings/                      # Fitur pengaturan
    │   ├── domain/
    │   │   └── repositories/          # SettingsRepository interface
    │   ├── data/
    │   │   └── repositories/          # SettingsRepositoryImpl
    │   ├── stores/                    # Riverpod stores
    │   └── presentation/              # Settings screen
    │
    ├── analytics/                     # Fitur analytics (UI-only)
    │   └── presentation/
    │       ├── analytics_screen.dart
    │       └── analytics_data.dart
    │
    ├── charts/                        # Fitur charts (UI-only)
    │   └── presentation/              # Chart screens & widgets
    │
    └── beta_report/                   # Fitur beta report (UI-only)
        └── presentation/              # Beta report screen
```

### Catatan Penting

1. **Generated Files**: Setiap folder dengan nama `generated/` berisi file yang di-generate oleh `build_runner` (`.g.dart`, `.freezed.dart`). File ini **JANGAN diedit manual**.

2. **Nama Folder yang "Salah"**: Beberapa nama folder dipertahankan karena sudah digunakan di routing:
   - `admin_pannel` (typo "panel")
   - `KillswitchControllScreen` (typo "Control")

3. **UI-Only Features**: `beta_report` dan `charts` saat ini hanya memiliki layer presentation. Tidak perlu menambahkan repository/domain boilerplate sampai fitur ini memiliki logic business atau persistence sendiri.

4. **Pola Komposit (Agregat)**: `HomeRepository` di `dashboard/domain/repositories/` adalah agregat port yang menggabungkan beberapa fitur terkait (assets, contacts, inventory, statistics, transactions). Ini sah untuk mengurangi coupling antar-fitur.

5. **Status Migrasi Struktur**: Sebagian fitur sudah bermigrasi ke struktur baru (`domain/adapters/view`), sementara yang lain masih menggunakan struktur lama (`domain/data/presentation`). Lihat tabel status migrasi di atas untuk detail tiap fitur.

## Workflow Tim (Aturan Wajib)

1. **Paparkan error/analisis dulu.** Saat diminta memperbaiki/mengubah kode,
   tampilkan terlebih dahulu error atau hasil analisis. User yang memilih apa
   yang harus dikerjakan.
2. **Kerjakan hanya yang diperintahkan.** Jangan menambah perbaikan di luar
   scope. Bila ada perbaikan terkait lain, TANYA dulu apakah perlu diproses.
3. **Jangan jalankan type checking otomatis** setiap kali user memberi
   perintah. Jalankan hanya bila diminta eksplisit atau untuk verifikasi akhir
   task.
4. **Tampilkan command sebelum eksekusi.** Setiap command yang mau dijalankan
   wajib dipaparkan dulu, lalu user yang mengonfirmasi. Jalankan berurutan,
   satu per satu, tanpa menggabung beberapa command dalam sekali jalan.
5. **Saat command gagal:** jangan otomatis perbaiki. Paparkan error, jelaskan
   penyebab singkat, tawarkan opsi, tunggu pilihan user.
6. **Codegen dijalankan USER, bukan AI.** Jangan pernah menjalankan
   `build_runner` sendiri. Generated files (`.g.dart`, `.freezed.dart`) JANGAN
   diedit manual; review diff-nya sebelum commit.
7. **Jangan log data sensitif** (token, password, PIN, nomor kartu) ke
   `AppLogger` maupun ke source code.
8. **Wajib perbarui AGENTS.md saat perubahan infrastructure.** Jika ada
   perubahan struktur folder, naming convention, atau arsitektur aplikasi,
   AI **WAJIB** mengecek dan memperbarui AGENTS.md agar selalu sinkron dengan
   kondisi aktual infrastructure. Ini termasuk:
   - Perubahan struktur folder fitur (domain/data/presentation → domain/adapters/view)
   - Perubahan naming convention (entities → models, data → adapters, dll)
   - Perubahan arsitektur layer
   - Penambahan fitur baru dengan struktur berbeda
   - Update contoh struktur folder di dokumen ini

## Command yang Digunakan

| Perintah                                                   | Kategori   | Catatan                                     |
| ---------------------------------------------------------- | ---------- | ------------------------------------------- |
| `flutter analyze`                                          | read-only  | type check + lint; butuh konfirmasi         |
| `flutter test`                                             | read-only  | test; butuh konfirmasi                      |
| `dart format .`                                            | read-only  | format; butuh konfirmasi                    |
| `dart run build_runner build --delete-conflicting-outputs` | codegen    | **HANYA USER** yang menjalankan             |
| `flutter build <target>`                                   | build      | konfirmasi + jelaskan output                |
| `flutter run -d linux`                                     | dev server | **Jangan jalankan** — user yang menjalankan |

Tidak ada `bun run`, `rs:check`, atau `oxlint` di proyek ini.

Konfigurasi runtime lewat `--dart-define` (lihat `lib/core/config/api_config.dart`),
contoh:

```bash
flutter run -d linux --dart-define=API_BASE_URL=http://localhost:8787
```

Jangan hardcode secret; jangan cetak env sensitif.

## Konvensi Kode

- **Komentar Bahasa Indonesia** untuk semua doc comment; jelaskan _mengapa_,
  bukan apa. Bila meniru perilaku web/backend, **rujuk padanan SvelteKit/TS**-nya
  (contoh: "padanan `transactionStore` di web", "cerminan `DEFAULT_PAGE_SIZE` di
  `services/domain/transactions`").
- **Section comment** dalam `build()`/layout: `// header section`,
  `// stats section`, dst.
- Widget internal privat ber-prefix `_` (contoh `_AdminHeader`, `_TokenField`).
- Freezed state: `@Default` untuk nilai awal; store memanggil
  `Future.microtask(load)` di dalam `build()` (menghindari "uninitialized
  provider" di Riverpod 3) dan menjaga `ref.mounted` pada async gap; pola
  dedupe request via `_inFlight` future.
- Logger: `AppLogger.instance` (delegasikan ke field `final _log = ...`),
  selalu sertakan `tag:` (contoh `'GraphQL'`, `'TransactionsStore'`,
  `'CookieClient'`). `success` = normal, `error` = gagal, `warn` = tak fatal.
  Lihat `docs-dev/app-logger.md`.
- Generate file: `/* GENERATED CODE - DO NOT MODIFY BY HAND */` — jangan ubah.
- **Nama file yang "salah" dipertahankan** apa adanya karena sudah dipakai
  di routing & route name: `admin_pannel` (typo "panel"), `KillswitchControllScreen`
  (typo "Control"). Jangan "betulkan" nama-nama ini.

## Design System

- untuk widget dari Container mejadi Box milik packages mix
  docs ref: https://concepta.dev/documentation/mix/widgets/box
- `UiStyle` (`lib/core/theme/ui_style.dart`) = sumber kebenaran look & feel;
  dibaca via `ref.watch(uiStyleControllerProvider).value ?? const UiStyle()`.
  Palet: primary gold `#D4A574`, secondary purple `#8B5CF6`, tertiary pink
  `#F4A6D6`, gradient `[#FFD79B, primary, secondary, tertiary]`, bg `#0A0A0A`.
- Pakai widget brand di `lib/core/theme/widgets/` (jangan inline styling ad hoc):
  `DompetButton`, `DompetCard`, `DompetCombobox<T>`, `DompetAvatar`,
  `DompetBadge`, `DompetTextField`, `DompetGradientBackground`,
  `LoadViewAnimatingProgressRipple`, `ScrollRefreshWrapper`, `RoundActionButton`,
  `CsGlass`, `CsDialog`, `BalanceInputField`, pickers, `ItemMenu`.

## Testing

- `flutter_test` (+ `flutter_riverpod`). Contoh: `test/transactions_hotrestart_repro_test.dart`,
  `test/cookie_aware_client_test.dart`, `test/session_restore_test.dart`.
- Idiom fake HTTP: (a) subclass remote source + `ProviderContainer(overrides: [...])`
  dengan `overrideWithValue`; (b) `MockClient` dari `package:http/testing.dart`;
  (c) `Link.function` + `GraphQLClient(link:..., cache: GraphQLCache(store: InMemoryStore()))`.
- Jangan pernah menjalankan `flutter test` tanpa konfirmasi user.

## Kontrak Backend (Ringkas)

- `GET/POST/DELETE {baseUrl}/admin/killswitch[/:operation]` — kontrol kill switch,
  body `{ reason }` untuk POST; header `x-admin-token`. Endpoint tanpa prefix `/api`.
- Kill switch: only root `Query.*` / `Mutation.*`; fail-open; cache TTL ±5s per
  isolate; error GraphQL ditandai `extensions.code = 503` (HTTP tetap 200).
- Daftar 74 operation root (`34 Query + 40 Mutation`) di
  `lib/features/admin_pannel/data/graphql_operations.dart` — **disinkron manual**
  dari SDL `cx-services`; perbarui bila SDL berubah.
- `{baseUrl}/graphql` = endpoint GraphQL utama; relay-style pagination;
  direktif `@authorized` (pengecualian `signIn`/`signUp`).

## Skill Lokal

Rules operasional & best practice ada di `.agents/skills/` (disinkron via
symlink ke `.claude/skills/`). Baca sebelum mengubah area terkait:

- `ai-rules-execution` — aturan interaksi AI–user (ringkasan di atas).
- `action-ai-rules-execution` — kategorisasi command & alur eksekusi.
- `flutter`, `riverpod`, `flutter-riverpod-expert` — best practice Flutter/Riverpod.
- `building-flutter-apps` — rules R1–R27 (analyze tiap batch, codegen-only
  provider, dsb.; beberapa item mungkin bertabrakan dengan praktik lokal —
  ikuti yang berlaku nyata di kode).
- `building-flutter-production-apps` — referensi expert Flutter production:
  arsitektur (Clean/Hexagonal/Feature-First), performa (jank, rebuild
  overhead), platform integration (MethodChannel/FFI), testing, CI/CD.
  Gunakan untuk keputusan arsitektur & debugging produksi yang kompleks;
  tetap ikuti aturan lokal di dokumen ini (Riverpod codegen, feature-first).
- `developing-genkit-dart` — Genkit Dart SDK 1.0 untuk AI agent/flows/LLM
  di Dart/Flutter. Relevan untuk fitur `gen_ai`; perhatikan migrasi API
  pre-1.0 → 1.0 yang didokumentasikan di skill-nya.
- `Flutter Enterprise Starter` — referensi penerapan Hexagonal Architecture
  (Ports & Adapters) pada Flutter:
  https://github.com/deveminsahin/starter_app. Gunakan prinsip batas domain,
  application, dan adapter-nya secara pragmatis; jangan mengadopsi BLoC atau
  CQRS dari starter tersebut.
- `flutter-clean-riverpod-skills` — referensi state management Riverpod:
  https://github.com/Ethiel97/flutter-clean-riverpod-skills. Gunakan Riverpod
  sebagai pengganti BLoC karena stack aplikasi ini memakai Riverpod 3 codegen;
  aturan dan pola khusus proyek di dokumen ini tetap menjadi acuan utama.

## Arsitektur Hexagonal

Aplikasi menggunakan Hexagonal Architecture secara pragmatis dalam struktur
feature-first yang sudah ada. Prinsip boundary:

- **Domain = Port.** Kontrak repository didefinisikan sebagai
  `abstract interface class` di `lib/features/<fitur>/domain/repositories/`.
  Domain **tidak boleh** mengimport `data/`, `stores/`, atau `presentation/`.
- **Data = Adapter.** Implementasi konkret repository dan integrasi
  SDK/network/storage (remote/local datasource) berada di
  `lib/features/<fitur>/data/` (termasuk `data/repositories/*_impl.dart`).
  Data boleh mengimport domain; tidak boleh mengimport `presentation/`.
- **Stores = Boundary Komposisi.** Providers Riverpod (codegen
  `@Riverpod`/`@riverpod` atau manual `Provider`) di `stores/` bertugas
  meng-inject dan memaparkan repository ke presentation. Presentation dan
  store hanya bergantung pada **interface domain**, bukan implementasi data.
- **Presentation = UI.** Screens/widgets hanya mengonsumsi state dari
  stores (provider/store); tidak boleh memanggil datasource/data
  layer langsung.

**Pola komposit (agregat):**
Beberapa fitur yang berkaitan dikelompokkan melalui `HomeRepository`
(`lib/features/dashboard/domain/repositories/home_repository.dart`) sebagai
**agregat port**. Implementasinya `HomeRepositoryImpl` di
`dashboard/data/repositories/` dan di-compose dari datasource/layanan fitur
terkait (assets/contacts/inventory/statistics/transactions). Ini sah untuk
mengurangi coupling antar-fitur dan tetap menjaga boundary domain–data.

**Catatan implementasi saat ini:**
Sebagian fitur sudah punya pasangan interface+impl terpisah (contoh `auth`,
`order`, `settings`, `app_lock`, `admin_pannel`, `dashboard`, `gen_ai`),
sementara fitur lain yang hanya diakses via agregat `HomeRepository` tidak
wajib dibuatkan repository impl terpisah selama boundary domain-data tetap
terjaga. Jangan memecah agregat tanpa alasan yang jelas dan tanpa perubahan
perilaku.

Referensi: `Flutter Enterprise Starter` (pragmatis, bukan template utuh),
stack tetap **Riverpod 3 codegen**, dengan `flutter-clean-riverpod-skills`
sebagai referensi Riverpod.

## Catatan / Draf Diketahui

- ~~`KillswitchRemoteSource._headers` mengirim `Authorization: adminToken`~~ —
  sudah dibetulkan (18 Okt 2026): header dikirim sebagai `x-admin-token`
  sesuai pemeriksaan backend di `cx-services/app.ts`.
- ~~Docs `action-ai-rules-execution` masih menyebut "/api/graphql"~~ — sudah
  diupdate (18 Okt 2026): endpoint aktual `$baseUrl/graphql` tercatat benar
  di docs skill tersebut.

## Persetujuan Khusus Migrasi Clean Architecture

Pada 13 Oktober 2026, pengguna menyetujui perubahan arsitektur lintas seluruh
fitur aplikasi dan pemeriksaan yang diperlukan untuk menyelesaikan serta
memverifikasi migrasi ini. Persetujuan ini terbatas pada pemisahan domain/data/
presentation dan format/analyze/test yang terkait; tidak mengizinkan perubahan
perilaku fitur, kontrak backend, build/run/deploy, atau commit/push. Aturan
codegen tetap berlaku: AI tidak menjalankan `build_runner` dan tidak mengedit
file generated; bila perubahan berikutnya memerlukan regenerasi, pengguna yang
menjalankannya.
