# AGENTS.md — cx-dompetqu

Aturan perilaku AI saat bekerja di repositori ini. Wajib dibaca sebelum
mengubah kode. Detail tambahan ada di `.agents/skills/` (lihat bagian "Skill").

## Ringkasan Proyek

Aplikasi dompet (finansial) — port dari modul `/dompet` SvelteKit ke Flutter.
Desktop (Linux/Windows/macOS) & mobile memakai Riverpod + go_router yang sama.

Topologi backend (tanpa deploy, hanya HTTP/GraphQL):

```
cx-dompetqu ──HTTP/GraphQL──▶ cx-web (/api/*) ──▶ cx-services
                     atau langsung ───────────────▶ cx-services
```

Backend kontrak hidup di repo sibling `../cx-services` (Elysia + GraphQL Yoga +
Drizzle pada Cloudflare D1). Verifikasi endpoint/tipe ke `cx-services/*.md`,
`app.ts`, dan `domain/*/adapters/driving/graphql/*.gql` bila ragu.

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

## Arsitektur Aplikasi

```
lib/
├── main.dart                       # bootstrap + router (appRouterProvider, keepAlive)
├── core/
│   ├── config/        api_config.dart      # baseUrl, graphqlEndpoint, killswitchEndpoint
│   ├── graphql/       graphql_providers.dart (+ main.g.dart)  # GraphQLClient tunggal
│   ├── logger/        app_logger.dart, log_level.dart, log_record.dart
│   ├── network/       cookie_aware_client.dart (+ .g.dart)     # sesi cookie __sst__/__rft__
│   ├── theme/         app_theme.dart, ui_style.dart, dompet_brand.dart, widgets/
│   └── utils/         balance.dart, formatters.dart
└── features/
    ├── auth/          application/ data/ models/ presentation/
    ├── app_lock/      application/ data/ models/ presentation/
    ├── admin_pannel/  (screen + application/ + data/)           # layar admin + kill switch
    ├── beta_report/, charts/
    └── home/          application/ data/ models/ + per-screen dirs
```

- **Routing:** `go_router` via `appRouterProvider` (`lib/main.dart`). Redirect
  memakai `ref.read` (bukan `ref.watch`) + `ref.listen` untuk `router.refresh()`.
  Route utama: `/auth`, `/`, `/app-lock`, `/admin`, `/admin/killswitch`,
  `/settings*`, `/order`, `/asset-detail/:id`, `/analytics`, `/charts`, dll.
- **State:** Riverpod 3 **codegen** (`@Riverpod(keepAlive: true)` /
  `@riverpod`) + `part '<file>.g.dart'`. State & model memakai **Freezed 4**
  (`@freezed abstract class ... with _$X`, `@Default(...)`) + `json_serializable`
  (`part '<file>.freezed.dart'` + `.g.dart`).
- **Data layer:** query/mutation GraphQL **ditulis manual** sebagai string `gql`
  di `lib/features/*/data/*_remote_source.dart`. TIDAK ada GraphQL codegen.
- **GraphQL client:** `graphQLClientProvider` (`lib/core/graphql/graphql_providers.dart`)
  — HttpLink + cookie client, timeout 30s, parser error toleran.
- **Sesi:** `CookieAwareClient` (`lib/core/network/cookie_aware_client.dart`)
  mengelola cookie `__sst__`/`__rft__`, persist ke SharedPreferences;
  `refreshSession()` memakai query `CheckAuthorized` via HTTP mentah.
- **Kill switch (REST):** sengaja REST (bukan GraphQL) supaya tetap hidup saat
  GraphQL bermasalah. Header `x-admin-token`. Lihat
  `lib/features/admin_pannel/data/killswitch_remote_source.dart`.

## Konvensi Kode

- **Komentar Bahasa Indonesia** untuk semua doc comment; jelaskan _mengapa_,
  bukan apa. Bila meniru perilaku web/backend, **rujuk padanan SvelteKit/TS**-nya
  (contoh: "padanan `transactionStore` di web", "cerminan `DEFAULT_PAGE_SIZE` di
  `services/domain/transactions`").
- **Section comment** dalam `build()`/layout: `// header section`,
  `// stats section`, dst.
- Widget internal privat ber-prefix `_` (contoh `_AdminHeader`, `_TokenField`).
- Freezed state: `@Default` untuk nilai awal; controller memanggil
  `Future.microtask(load)` di dalam `build()` (menghindari "uninitialized
  provider" di Riverpod 3) dan menjaga `ref.mounted` pada async gap; pola
  dedupe request via `_inFlight` future.
- Logger: `AppLogger.instance` (delegasikan ke field `final _log = ...`),
  selalu sertakan `tag:` (contoh `'GraphQL'`, `'TransactionsController'`,
  `'CookieClient'`). `success` = normal, `error` = gagal, `warn` = tak fatal.
  Lihat `docs-dev/app-logger.md`.
- Generate file: `/* GENERATED CODE - DO NOT MODIFY BY HAND */` — jangan ubah.
- **Nama file yang "salah" dipertahankan** apa adanya karena sudah dipakai
  di routing & route name: `admin_pannel` (typo "panel"), `KillswitchControllScreen`
  (typo "Control"). Jangan "betulkan" nama-nama ini.

## Design System

- untuk design dari Container gantikan dengan Box milik package:mix
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

## Catatan / Draf Diketahui

- `KillswitchRemoteSource._headers` mengirim `Authorization: adminToken` dengan
  baris `'x-admin-token': adminToken` dikomentari; backend memeriksa
  `x-admin-token`. Ada ketidakcocokan yang perlu dibetulkan.
- Docs `action-ai-rules-execution` masih menyebut "/api/graphql"; nilai aktual
  `ApiConfig.graphqlEndpoint` adalah `$baseUrl/graphql`. Update bila touch.
