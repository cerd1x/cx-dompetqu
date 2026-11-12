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
- **Reports** — fitur pelaporan (UI-only, menampilkan log AppLogger).

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

| Fitur        | Struktur                               | Keterangan                                         |
| ------------ | -------------------------------------- | -------------------------------------------------- |
| admin_pannel | domain/adapters/view                   | Sudah migrasi                                      |
| app_lock     | domain/adapters/view                   | Sudah migrasi                                      |
| assets       | domain/adapters/view                   | Sudah migrasi                                      |
| analytics    | domain/adapters/view (kerangka kosong) | UI-only, belum lengkap                             |
| auth         | domain/adapters/view                   | Sudah migrasi                                      |
| reports      | domain/adapters/view                   | domain/adapters mockup, menampilkan log AppLogger  |
| charts       | view (screens)                         | UI-only, belum lengkap                             |
| contacts     | domain/adapters/view                   | Sudah migrasi (`domain/entities/` kosong)          |
| dashboard    | domain/adapters/view                   | Sudah migrasi                                      |
| gen_ai       | domain/adapters/view                   | Sudah migrasi, 2 provider store masih manual (R2)  |
| inventory    | domain/adapters/view                   | Sudah migrasi                                      |
| order        | domain/adapters/view                   | Sudah migrasi, 4 provider masih manual (R2)        |
| payments     | domain/adapters/view                   | Sudah migrasi, `paymentsByStatus` + `retryPayment` |
| portfolio    | domain/adapters/view                   | Exchange rate source adapter + UI                  |
| settings     | domain/adapters/view                   | Sudah migrasi                                      |
| statistics   | domain/adapters/view                   | Sudah migrasi                                      |
| struct       | view (screens)                         | UI-only, hanya 1 screen                            |
| transactions | domain/adapters/view                   | Sudah migrasi                                      |

Features `analytics` dan `charts` adalah UI-only, hanya memiliki layer presentation tanpa repository/domain boilerplate.

**Konvensi model domain:** acuan resmi adalah `domain/models/`. Folder `domain/entities/` adalah nama lama dan sudah tidak dipakai isinya; sisa direktori kosong `contacts/domain/entities/` boleh dihapus kapan saja.

### Teknologi Utama

- **Framework**: Flutter (desktop & mobile)
- **State Management**: Riverpod 3 dengan codegen (`@Riverpod`, `@riverpod`)
- **Routing**: go_router dengan `appRouterProvider`
- **State Models**: Freezed 4 untuk immutable state dengan `@Default`
- **Serialization**: json_serializable untuk JSON/GraphQL models
- **Networking**: GraphQL (manual string queries) + HTTP untuk REST endpoints
- **Session Management**: Cookie-based dengan `CookieAwareClient`
- **Isolate / Komputasi berat**: `lib/core/utils/isolate_utils.dart` menyediakan
  fungsi top-level yang dipanggil via `dart:isolate compute` untuk parsing JSON
  massal (contoh: `TransactionPage.fromJsonAsync` memindahkan parsing `edges` ke
  isolate terpisah; `fromJson` tetap sinkron untuk pemakaian non-async). Jangan
  melewatkan `GraphQLClient`/`HttpClient` ke isolate.
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
│   │       ├── cx_pin_input.dart
│   │       ├── cx_button_biometric.dart
│   │       ├── cs_glass.dart
│   │       ├── cs_dialog.dart
│   │       ├── cs_nav_bar.dart
│   │       ├── cx_scroll_refresh_wrapper.dart
│   │       ├── cx_button_act_round.dart
│   │       ├── cx_item_menu.dart
│   │       ├── cx_icons.dart
│   │       ├── data_states.dart
│   │       └── placeholders.dart
│   │
│   ├── utils/                         # Utility functions
│   │   ├── balance.dart              # Format & hitung balance
│   │   ├── formatters.dart           # Format tanggal, angka, dll.
│   │   ├── isolate_utils.dart        # Fungsi top-level untuk compute/isolate
│   │   └── platform_target.dart      # Deteksi desktop/mobile dari Theme.platform
│   │
│   └── diagnostics/                   # Development tools
│       └── fps_indicator.dart        # FPS monitoring (dev only)
│
└── features/                          # Feature-based modules
    │
    ├── auth/                          # Fitur autentikasi
    │   ├── domain/
    │   │   ├── models/                # AuthUser, AuthPasskeyCredential, AuthFailure
    │   │   ├── repositories/          # AuthRepository interface
    │   │   └── usecases/              # Auth use cases
    │   ├── adapters/
    │   │   ├── datasources/           # Remote/session/passkey datasources
    │   │   ├── models/                # User, Passkey (data model)
    │   │   ├── mappers/               # data model → domain model
    │   │   └── repositories/          # AuthRepositoryImpl
    │   └── view/
    │       ├── screens/               # AuthScreen
    │       └── stores/                # auth_providers, session_store, app_theme
    │
    ├── app_lock/                      # Fitur kunci aplikasi (PIN/biometrik)
    │   ├── domain/
    │   │   ├── models/                # AppLockState
    │   │   └── repositories/          # AppLockRepository interface
    │   ├── adapters/
    │   │   ├── app_lock_storage.dart  # Penyimpanan PIN (belum di datasources/)
    │   │   ├── datasources/           # Local & biometric datasources
    │   │   └── repositories/          # AppLockRepositoryImpl
    │   └── view/
    │       ├── screens/               # AppLockScreen, SetupScreen
    │       └── stores/                # Riverpod stores
    │
    ├── admin_pannel/                  # Fitur admin panel (typo "panel")
    │   ├── domain/
    │   │   ├── models/                # DisabledOperation
    │   │   └── repositories/          # KillswitchRepository interface
    │   ├── adapters/
    │   │   ├── graphql_operations.dart # Daftar 74 operation root (belum di datasources/)
    │   │   ├── killswitch_remote_source.dart # REST (belum di datasources/)
    │   │   └── repositories/          # KillswitchRepositoryImpl
    │   └── view/
    │       ├── screens/               # AdminScreen, KillswitchControllScreen
    │       └── stores/                # Riverpod stores
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
    │   │   └── repositories/          # HomeRepository (agregat port)
    │   ├── adapters/
    │   │   ├── datasources/           # Agregat datasource fitur terkait
    │   │   ├── mappers/               # JSON → model dashboard
    │   │   └── repositories/          # HomeRepositoryImpl (komposisi fitur)
    │   └── view/
    │       ├── screens/               # DashboardScreen, HomeShell
    │       ├── stores/                # Riverpod stores
    │       └── widgets/               # QuickActions, StatsGrid, TransactionListView, dll.
    │
    ├── gen_ai/                        # Fitur AI generatif (Genkit Dart SDK 1.0)
    │   ├── domain/
    │   │   ├── models/                # AI-related domain models
    │   │   └── repositories/          # Port AI (chat, settings, skills, MCP, dst.)
    │   ├── adapters/
    │   │   ├── datasources/           # Lokal, OpenRouter, skill store, crypto
    │   │   ├── models/                # AiSkill, McpServer, AiSettings (data model)
    │   │   ├── mappers/               # data model → domain model
    │   │   └── repositories/          # Implementasi port AI
    │   └── view/
    │       ├── screens/               # GenAiScreen, AiSettingScreen
    │       ├── widgets/               # Bubble, sheet, profiles card
    │       └── stores/                # Store + provider (2 provider masih manual/R2)
    │
    ├── inventory/                     # Fitur inventori produk
    │   ├── domain/
    │   │   └── models/                # Product
    │   ├── adapters/
    │   │   ├── datasources/           # InventoryRemoteSource (GraphQL)
    │   │   └── models/                # Product (data model)
    │   └── view/
    │       ├── screens/               # InventoryScreen
    │       ├── widgets/               # ProductDetailView, ProductItemView
    │       └── stores/                # inventory_store
    │
    ├── statistics/                    # Fitur statistik
    │   ├── domain/
    │   │   └── models/                # Statistics
    │   ├── adapters/
    │   │   ├── datasources/           # StatisticsRemoteSource (GraphQL)
    │   │   └── models/                # Statistics (data model)
    │   └── view/
    │       └── stores/                # statistics_store
    │
    ├── transactions/                  # Fitur transaksi
    │   ├── domain/
    │   │   └── models/                # Transaction, TransactionPage, PaymentMethodType
    │   ├── adapters/
    │   │   ├── datasources/           # TransactionsRemoteSource (GraphQL)
    │   │   └── models/                # Transaction, TransactionPage (data model)
    │   └── view/
    │       ├── screens/               # TransactionDetailScreen
    │       └── stores/                # transactions_store
    │
    ├── portfolio/                     # Fitur portfolio (exchange rate adapter + UI)
    │   ├── domain/
    │   │   ├── models/                # ExchangeRate, ExchangeRateError
    │   │   └── repositories/          # ExchangeRateRepository interface
    │   ├── adapters/
    │   │   ├── datasources/           # ExchangeRateSource + Frankfurter adapter
    │   │   └── repositories/          # ExchangeRateRepositoryImpl
    │   └── view/
    │       ├── screens/               # PortfolioScreen
    │       └── stores/                # exchange_rate_store, provider
    │
    ├── struct/                        # Fitur struct (UI-only)
    │   └── view/
    │       └── screens/               # StructDetailScreen
    │
    ├── order/                         # Fitur order & transaksi
    │   ├── domain/
    │   │   └── repositories/          # OrderRepository, DebtSettlementsRepository
    │   ├── adapters/
    │   │   ├── datasources/           # OrderRemoteSource (GraphQL), debt settlement local
    │   │   └── repositories/          # OrderRepositoryImpl, DebtSettlementsRepositoryImpl
    │   └── view/
    │       ├── screens/               # OrderScreen
    │       ├── stores/                # Repository providers, debtSettlementsProvider,
    │       │                          # bookkeepingStoreProvider (bulan/filter + ledger)
    │       └── widgets/               # bookkeeping_tab, debt_tab, order_tab,
    │                                  # sale_tab, expense_tab, loan_tab, form widgets
    │
    ├── payments/                      # Fitur payment (read-only)
    │   ├── domain/
    │   │   ├── models/                # Payment (status/retry)
    │   │   └── repositories/          # PaymentsRepository interface
    │   ├── adapters/
    │   │   ├── datasources/           # PaymentsRemoteSource (paymentsByStatus)
    │   │   └── repositories/          # PaymentsRepositoryImpl
    │   └── view/
    │       ├── stores/                # failedPaymentsProvider + repo provider (manual)
    │       └── widgets/               # FailedPaymentRow, PaymentStatusPill
    │
    ├── settings/                      # Fitur pengaturan
    │   ├── domain/
    │   │   ├── models/                # AppSettings
    │   │   └── repositories/          # SettingsRepository interface
    │   ├── adapters/
    │   │   ├── datasources/           # SettingsLocalDatasource
    │   │   └── repositories/          # SettingsRepositoryImpl
    │   └── view/
    │       ├── screens/               # SettingsScreen, AppearanceScreen, ProfileScreen
    │       ├── widgets/               # Passkey section, row picker/toggle
    │       └── stores/                # settings_store, settings_repository_provider, fps_indicator
    │
    ├── analytics/                     # Fitur analytics (UI-only, kerangka kosong)
    │   └── view/
    │       ├── screens/               # analytics_screen.dart
    │       └── widgets/               # analytics_data.dart
    │
    ├── charts/                        # Fitur charts (UI-only)
    │   └── view/
    │       └── screens/               # Chart screens
    │
    └── reports/                       # Fitur laporan (UI-only, menampilkan log AppLogger)
        └── view/
            ├── screens/               # ReportsScreen
            └── stores/                # reports_store
```

### Catatan Penting

1. **Generated Files**: Setiap folder dengan nama `generated/` berisi file yang di-generate oleh `build_runner` (`.g.dart`, `.freezed.dart`). File ini **JANGAN diedit manual**.

2. **Nama Folder yang "Salah"**: Beberapa nama folder dipertahankan karena sudah digunakan di routing:
   - `admin_pannel` (typo "panel")
   - `KillswitchControllScreen` (typo "Control")

3. **UI-Only Features**: `reports`, `charts`, `struct`, dan `analytics` hanya memiliki layer `view/` tanpa repository/domain boilerplate. `portfolio` kini punya domain/adapters (exchange rate source adapter) meski UI-nya masih placeholder.

4. **Pola Komposit (Agregat)**: `HomeRepository` di `dashboard/domain/repositories/` adalah agregat port yang menggabungkan beberapa fitur terkait (assets, contacts, inventory, statistics, transactions). Ini sah untuk mengurangi coupling antar-fitur.

5. **Status Migrasi Struktur**: Seluruh fitur sudah memakai struktur target (`domain/adapters/view`); lihat tabel status migrasi di atas untuk catatan per fitur (UI-only dan utang provider manual).

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
  `LoadViewAnimatingProgressRipple`, `CxScrollRefreshWrapper`, `CxButtonActRound`,
  `CsGlass`, `CsDialog`, `CxTextFieldBalance`, pickers, `CxItemMenu`.

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
  `lib/features/admin_pannel/adapters/graphql_operations.dart` — **disinkron manual**
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
- `code_style.md` — panduan lengkap gaya penulisan code, critical rules R1–R27,
  dan konvensi Riverpod 2025. Lihat `docs-dev/code_style.md` untuk detail.

## Arsitektur Hexagonal

Aplikasi menggunakan Hexagonal Architecture secara pragmatis dalam struktur
feature-first yang sudah ada. Prinsip boundary:

- **Domain = Port.** Kontrak repository didefinisikan sebagai
  `abstract interface class` di `lib/features/<fitur>/domain/repositories/`.
  Domain **tidak boleh** mengimport `adapters/`, `view/`, atau layer UI lain.
- **Data = Adapter.** Implementasi konkret repository dan integrasi
  SDK/network/storage (remote/local datasource) berada di
  `lib/features/<fitur>/adapters/` (termasuk `adapters/repositories/*_impl.dart`).
  Adapter boleh mengimport domain; tidak boleh mengimport `view/`.
- **Stores = Boundary Komposisi.** Providers Riverpod (codegen
  `@Riverpod`/`@riverpod` atau manual `Provider`) di `view/stores/` bertugas
  meng-inject dan memaparkan repository ke presentation. Presentation dan
  store hanya bergantung pada **interface domain**, bukan implementasi data.
- **Presentation = UI.** Screens/widgets hanya mengonsumsi state dari
  stores (provider/store); tidak boleh memanggil datasource/adapter
  layer langsung.

**Pola komposit (agregat):**
Beberapa fitur yang berkaitan dikelompokkan melalui `HomeRepository`
(`lib/features/dashboard/domain/repositories/home_repository.dart`) sebagai
**agregat port**. Implementasinya `HomeRepositoryImpl` di
`dashboard/adapters/repositories/` dan di-compose dari datasource/layanan fitur
terkait (assets/contacts/inventory/statistics/transactions). Ini sah untuk
mengurangi coupling antar-fitur dan tetap menjaga boundary domain–data.

**Catatan implementasi saat ini:**
Sebagian fitur sudah punya pasangan interface+impl terpisah (contoh `auth`,
`order`, `settings`, `app_lock`, `admin_pannel`, `dashboard`, `gen_ai`,
`payments`), sementara fitur lain yang hanya diakses via agregat
`HomeRepository` (`assets`, `contacts`, `inventory`, `statistics`,
`transactions`) tidak wajib dibuatkan repository impl terpisah selama boundary
domain–adapter tetap terjaga. Jangan memecah agregat tanpa alasan yang jelas
dan tanpa perubahan perilaku.

Utang boundary yang masih ada: `auth`, `gen_ai`, dan `settings` punya provider
di `view/stores/` yang mengimpor `adapters/datasources/` secara langsung
(komposisi adapter, bukan lewat port); rapikan bertahap tanpa mengubah perilaku.

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
