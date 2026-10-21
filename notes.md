# notes.md — Toko Skills (skills.sh) di cx-dompetqu

Dokumen ini mencatat **apa yang sudah dikerjakan**, **bagaimana cara kerjanya**, dan
**apa yang belum dikerjakan** pada fitur "Toko Skills" yang mengambil katalog skill
dari [skills.sh](https://skills.sh), berikut penjelasan detail untuk bagian yang
belum aktif (mode proxy / poin 4).

Terakhir diperbarui: 17 Oktober 2026 (commit `435dde2`).

---

## 1. Ringkasan fitur

Di layar **Gen AI → Kelola Skills**, selain "Buat skill" dan "Impor dari URL",
sekarang ada tombol **"Toko skills (skills.sh)"** dengan alur:

```
Gen AI → Kelola Skills → [Toko skills (skills.sh)]
      → pilih tab (All-time / Trending / Hot) atau cari
      → tekan "Tambah" pada salah satu skill
      → aplikasi mengunduh isi SKILL.md skill tersebut
      → disimpan sebagai skill lokal (nama = nama skill di toko)
      → sheet terbuka lagi dalam mode daftar, skill baru sudah muncul
```

Yang tersimpan tetap `AiSkill` biasa (`id`, `name`, `instructions`) di
`SharedPreferences` — tidak ada format penyimpanan baru.

## 2. Status

| Mode | Kondisi | Cara pakai |
| --- | --- | --- |
| **A. Scrape halaman publik skills.sh** | **Aktif (default)** — sudah diuji manual di aplikasi | tanpa konfigurasi apa pun |
| **B. API resmi skills.sh lewat proxy** | **Belum aktif** — kode klien sudah siap, backend-nya belum ada | `--dart-define=SKILLS_STORE_API_BASE_URL=...` |

Verifikasi yang sudah dijalankan: `flutter analyze` bersih, `flutter test` 59/59 lulus
(termasuk 8 test baru untuk parser toko), dan uji manual mode A oleh pemilik proyek.

## 3. Kenapa harus ada dua mode (inti masalahnya)

skills.sh menyediakan API resmi, **tetapi menolak semua permintaan tanpa autentikasi**.
Ini hasil pengecekan langsung:

```
GET https://skills.sh/api/v1/skills
→ 401 {"error":"authentication_required",
       "message":"This endpoint requires authentication. Pass a Vercel OIDC token
                  (Authorization: Bearer <VERCEL_OIDC_TOKEN>) ..."}
```

Hal yang sama terjadi pada `/api/v1/skills/search` dan `/api/v1/skills/curated`
(semuanya `401`).

Menurut [dokumentasi API resminya](https://skills.sh/docs/api), **satu-satunya cara
autentikasi yang didokumentasikan adalah token Vercel OIDC**:

- Token di-mint oleh Vercel per request, berlaku ±12 jam, scope-nya per (team, project).
- Disediakan otomatis sebagai `process.env.VERCEL_OIDC_TOKEN` (atau header
  `x-vercel-oidc-token`) **hanya bila aplikasi di-deploy di Vercel** dan fitur
  *OIDC Federation* diaktifkan di project tersebut.
- Helper resminya `@vercel/oidc` (`getVercelOidcToken()`), dan token **tidak boleh**
  disimpan/cache sebagai string.
- Rate limit: **600 request/menit per (team, project)**; error `401` (token hilang/
  kedaluwarsa), `404` (skill tidak ada), `429` (+`Retry-After`), `503` (coba lagi
  dengan backoff).

**Konsekuensi untuk aplikasi Flutter desktop/mobile:** aplikasi ini bukan aplikasi
Vercel, jadi ia **tidak akan pernah** punya `VERCEL_OIDC_TOKEN`. Tidak ada opsi
"API key" publik yang didokumentasikan. Karena itu:

- **Mode A** dipakai supaya fitur tetap bisa jalan hari ini: membaca halaman publik
  skills.sh (HTML) yang **tidak** butuh autentikasi.
- **Mode B** disiapkan sebagai jalur "yang benar": aplikasi berbicara ke **proxy milik
  sendiri**, dan **proxy itulah** yang menyelesaikan masalah autentikasi.

## 4. Peta kode (arsitektur)

```
lib/features/gen_ai/
├── domain/
│   ├── entities/skill_store_entry.dart        # SkillStoreEntry + SkillStoreView
│   └── repositories/skill_store_repository.dart   # kontrak: list / search / loadInstructions
├── data/
│   ├── datasources/skill_store_remote_datasource.dart
│   │     ├── SkillStoreRemoteDatasource            (interface)
│   │     ├── SkillsShScrapeRemoteDatasource        (mode A — HTML SSR)
│   │     └── SkillsShApiRemoteDatasource           (mode B — bentuk API resmi)
│   └── repositories/skill_store_repository_impl.dart  # penerus tipis ke datasource
├── stores/
│   ├── skill_store_repository_provider.dart    # provider POLOS (tanpa codegen) + pemilih mode
│   └── ai_skills_controller.dart               # + importFromStore(entry)
└── presentation/
    ├── ai_skills_sheet.dart                    # mode "store" + AiSkillStoreBrowser
    └── gen_ai_screen.dart                      # meneruskan repository & aksi ImportAiSkillFromStore
```

Alur pemanggilan saat user menekan **Tambah**:

```
AiSkillStoreBrowser (UI)
  → pop(ImportAiSkillFromStore(entry))
  → gen_ai_screen.dart: aiSkillsControllerProvider.notifier.importFromStore(entry)
  → AiSkillsStore.importFromStore(entry)          (stores)
  → LocalAiSkillsRepository.importFromStore(entry)     (data)
      → SkillStoreRepository.loadInstructions(entry)   (domain → datasource)
      → create(name: entry.name, instructions: ...)    (simpan seperti skill biasa)
```

**Pemilih mode** (satu-satunya tempat mode ditentukan) ada di
`lib/features/gen_ai/stores/skill_store_repository_provider.dart`
(di bawah ini disederhanakan, tanpa `name:` dan penyesuaian format):

```dart
const _skillsStoreApiBaseUrl = String.fromEnvironment('SKILLS_STORE_API_BASE_URL');

final skillStoreRemoteDatasourceProvider = Provider<SkillStoreRemoteDatasource>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  if (_skillsStoreApiBaseUrl.isEmpty) {
    return SkillsShScrapeRemoteDatasource(client);          // Mode A (default)
  }
  return SkillsShApiRemoteDatasource(                     // Mode B
    client,
    baseUrl: Uri.parse(_skillsStoreApiBaseUrl),
  );
});
```

Karena ini `String.fromEnvironment`, nilainya **di-bake saat compile** — mengubahnya
butuh rebuild/run ulang, bukan sekadar restart Hot Reload.

## 5. Mode A (aktif): scrape halaman publik

Yang dibaca (tanpa autentikasi, semuanya `200 OK`):

| Kebutuhan | Endpoint | Catatan |
| --- | --- | --- |
| katalog All-time | `https://skills.sh/` | ±183 baris |
| katalog Trending | `https://skills.sh/trending` | ±169 baris |
| katalog Hot | `https://skills.sh/hot` | ±196 baris |
| instruksi skill | `https://skills.sh/{source}/{slug}` | isi `SKILL.md` sudah dirender jadi HTML |

Cara parsing:

1. **Daftar**: setiap baris leaderboard berbentuk
   `<a class="group grid ..." href="/{source}/{slug}">` yang berisi `<h3>` (nama),
   `<p>` (source), dan kolom installs
   `<span class="font-mono text-sm text-foreground">3.9M</span>`.
   Baris hanya diterima bila `source` berisi `owner/repo` **dan** href-nya berawalan
   `{source}/`, supaya anchor lain di halaman (mis. `/trending`, `/docs`,
   `/agent/claude-code`) tidak ikut terbaca.
2. **Instruksi**: ambil div `<div class="prose prose-invert ...">` (dengan menghitung
   kedalaman tag karena isinya div bersarang), lalu ubah HTML → teks polos
   (hapus tag, decode entitas, rapikan baris kosong). Dipotong di 50 KB
   (sama seperti batas `AiSkillImportDatasource`).
3. **Cache**: hasil tiap tab disimpan di memori datasource, jadi pindah tab bolak-balik
   tidak memanggil jaringan lagi selama sheet masih hidup.

Keterbatasan yang **harus** dipahami:

- **Pencarian bukan pencarian server**. Halaman `/search?q=...` di skills.sh diisi
  oleh JavaScript (memanggil API yang `401`), jadi dari HTML hasilnya kosong.
  Karena itu mode A: query ≥2 huruf disaring **lokal** dari daftar All-time yang sudah
  dimuat. Artinya pencarian hanya mencakup ~183 skill teratas dan **tidak menemukan**
  skill di luar daftar itu.
- **Instruksi bukan markdown mentah.** Yang didapat adalah hasil konversi HTML→teks,
  jadi tabel/blok kode/format markdown bisa kehilangan struktur.
- **Angka installs perkiraan.** Store menampilkan bentuk singkat (`3.9M`), jadi
  `installs` hasil parse hanya untuk ditampilkan.
- **Rapuh terhadap perubahan situs.** Kalau skills.sh mengganti penanda HTML-nya,
  parser gagal → UI menampilkan pesan galat + tombol "Coba lagi".

## 6. Mode B (belum aktif): API resmi lewat proxy

### 6.1 Apa itu "proxy" di sini?

Proxy = **server kecil milik kita sendiri** yang berdiri di antara aplikasi dan
skills.sh. Aplikasi tidak lagi menghubungi skills.sh; ia menghubungi server kita, dan
server kita yang menghubungi skills.sh (dengan kredensial yang hanya dimiliki server).

```
Mode A:  Aplikasi Flutter ──HTTP──▶ skills.sh (halaman HTML)
Mode B:  Aplikasi Flutter ──HTTP──▶ PROXY kita ──Authorization: Bearer …──▶ skills.sh /api/v1/*
```

Keuntungannya:

1. **Autentikasi beres di server.** Kredensial (token Vercel OIDC / kunci apa pun di
   masa depan) tidak pernah ikut terpasang di aplikasi klien.
2. **Pencarian sungguhan.** Endpoint `/search` resmi memakai fuzzy/semantic search —
   jauh lebih baik daripada saringan lokal mode A.
3. **Satu tempat perbaikan.** Kalau bentuk API/halaman skills.sh berubah, yang diubah
   hanya proxy; aplikasi tidak perlu dirilis ulang.
4. **Bisa menambah cache/rate-limit** sendiri (proteksi 600 req/menit milik skills.sh).

### 6.2 Kontrak yang WAJIB dipenuhi proxy

Kode di `SkillsShApiRemoteDatasource` memanggil tiga URL ini. Proxy **harus** melayani
path yang sama dan mengembalikan bentuk yang sama seperti API resmi:

| Pemanggilan aplikasi | Metode | Query yang dikirim | Bentuk respons yang diharapkan aplikasi |
| --- | --- | --- | --- |
| `{base}/api/v1/skills` | GET | `view` = `all-time`\|`trending`\|`hot`, `per_page` = `100` | `{"data":[ V1Skill, ... ]}` |
| `{base}/api/v1/skills/search` | GET | `q`, `limit` = `50` | `{"data":[ V1Skill, ... ]}` |
| `{base}/api/v1/skills/{id}` | GET | — | `{"files":[ {"path":"SKILL.md","contents":"..."} ]}` |

`V1Skill` (yang dibaca aplikasi: `id`, `slug`, `name`, `source`, `installs`):

```json
{
  "id": "vercel-labs/skills/find-skills",
  "slug": "find-skills",
  "name": "Find Skills",
  "source": "vercel-labs/skills",
  "installs": 24531,
  "sourceType": "github",
  "installUrl": "https://github.com/vercel-labs/skills",
  "url": "https://skills.sh/vercel-labs/skills/find-skills"
}
```

Detail (aplikasi memilih `files[].path == "SKILL.md"`; kalau tidak ada, file `.md`
pertama; `contents` dipakai apa adanya sebagai instruksi):

```json
{
  "id": "vercel-labs/skills/find-skills",
  "files": [
    { "path": "SKILL.md", "contents": "# Find Skills\n..." },
    { "path": "reference.md", "contents": "..." }
  ]
}
```

Catatan perilaku klien: header yang dikirim hanya `accept: application/json` (plus map
`headers` opsional yang saat ini kosong); timeout 20 detik; **status selain 200
dianggap gagal** (pesan `HTTP <kode>`); body harus JSON objek; `SKILL.md` yang
kosong/tidak ada → error "SKILL.md tidak tersedia". Field yang hilang tidak fatal
(ada fallback), tapi `id` wajib ada.

### 6.3 Cara mengaktifkan di aplikasi

```bash
flutter run -d linux --dart-define=SKILLS_STORE_API_BASE_URL=https://skills-proxy.example
```

atau saat build:

```bash
flutter build linux --dart-define=SKILLS_STORE_API_BASE_URL=https://skills-proxy.example
```

> **PENTING — base URL adalah origin, bukan folder.**
> Aplikasi membentuk URL dengan `Uri.replace(path: '/api/v1/...')`, dan `replace`
> **mengganti seluruh path** dari base. Jadi:
> - `https://skills-proxy.example` → benar, memanggil
>   `https://skills-proxy.example/api/v1/skills`.
> - `https://cx-web.example/api/skills` → **salah/ tak terduga**, yang terpanggil
>   `https://cx-web.example/api/v1/skills` (bagian `/api/skills` hilang).
>
> Proxy harus melayani `/api/v1/...` di **root** host-nya, atau kita ubah kode klien
> agar menghormati base path (lihat TODO di bagian 8).

### 6.4 Cara memverifikasi proxy (tanpa menjalankan aplikasi)

```bash
curl -s "https://skills-proxy.example/api/v1/skills?view=trending&per_page=3" | head
curl -s "https://skills-proxy.example/api/v1/skills/search?q=react&limit=3" | head
curl -s "https://skills-proxy.example/api/v1/skills/vercel-labs/skills/find-skills" | head
```

Yang harus terlihat: JSON dengan kunci `data` (dua yang pertama) dan `files` (yang
ketiga). Kalau ketiganya sudah benar, aplikasi pasti bisa memakainya.

### 6.5 Dua cara membangun proxy

#### Opsi B1 — Paling sesuai dokumentasi: function di Vercel + `@vercel/oidc`

Dipakai bila kita boleh/ingin menaruh satu endpoint kecil di Vercel (di situ token
OIDC tersedia otomatis):

```js
// app/api/skills/route.js (Vercel / Next.js Route Handler)
import { getVercelOidcToken } from '@vercel/oidc';

export async function GET(request) {
  // Jangan hoist token ke module scope — token dirotasi tiap ±12 jam.
  const token = await getVercelOidcToken();
  const upstream = new URL('https://skills.sh/api/v1/skills');
  new URL(request.url).searchParams.forEach((v, k) => upstream.searchParams.set(k, v));

  const res = await fetch(upstream, { headers: { Authorization: `Bearer ${token}` } });
  return Response.json(await res.json(), { status: res.status });
}
```

Syaratnya: project di Vercel, lalu aktifkan **Settings → OIDC Federation**. Untuk
endpoint detail (`/api/v1/skills/{id}`) dan search, buat route serupa yang meneruskan
path + query apa adanya. Aplikasi cukup diarahkan ke origin deployment Vercel itu
(`https://<project>.vercel.app`).

#### Opsi B2 — Tanpa Vercel: Worker kita sendiri yang scrape lalu menyajikan bentuk API resmi

Dipakai kalau backend tetap di Cloudflare (sejalan dengan topologi
`cx-dompetqu → cx-web → cx-services`). Proxy melakukan hal yang sama seperti mode A,
tapi **di sisi server**, lalu mengeluarkan JSON berbentuk API resmi. Efeknya: aplikasi
tetap dapat kontrak resmi, sementara logika rapuh HTML terkumpul di satu tempat.

Kerangka (Cloudflare Worker, tanpa dependensi):

```js
const ROW = '<a class="group grid ';
const VIEWS = { 'all-time': '/', trending: '/trending', hot: '/hot' };

function parseRows(html) {
  const out = [];
  for (const chunk of html.split(ROW).slice(1)) {
    const end = chunk.indexOf('</a>');
    if (end < 0) continue;
    const row = chunk.slice(0, end);
    const id = /href="\/([^"]+)"/.exec(row)?.[1];
    const name = /<h3[^>]*>([^<]*)<\/h3>/i.exec(row)?.[1];
    const source = /<p[^>]*>([^<]*)<\/p>/i.exec(row)?.[1];
    if (!id || !name || !source || !id.startsWith(`${source}/`)) continue;
    const installs = /font-mono text-sm text-foreground">([^<]+)</.exec(row)?.[1];
    out.push({
      id,
      slug: id.split('/').pop(),
      name,
      source,
      installs: parseCount(installs),
    });
  }
  return out;
}

function parseCount(raw) {
  if (!raw) return null;
  const m = /^([0-9]*\.?[0-9]+)\s*([KMB])?$/i.exec(raw.replaceAll(',', '').trim());
  if (!m) return null;
  const mult = { K: 1e3, M: 1e6, B: 1e9 }[(m[2] || '').toUpperCase()] || 1;
  return Math.round(parseFloat(m[1]) * mult);
}

export default {
  async fetch(request) {
    const url = new URL(request.url);
    const list = url.pathname === '/api/v1/skills';
    const search = url.pathname === '/api/v1/skills/search';
    const detail = url.pathname.startsWith('/api/v1/skills/');

    if (list || search) {
      const view = list ? url.searchParams.get('view') ?? 'all-time' : 'all-time';
      const page = VIEWS[view];
      if (!page) return Response.json({ error: 'bad_request' }, { status: 400 });

      const res = await fetch(`https://skills.sh${page}`);
      const rows = parseRows(await res.text());

      const q = (url.searchParams.get('q') ?? '').toLowerCase();
      const data = q
        ? rows.filter((r) => q.length >= 2 && `${r.name} ${r.source} ${r.slug}`.toLowerCase().includes(q))
        : rows;

      return Response.json({ data });
    }

    if (detail) {
      // "/api/v1/skills/vercel-labs/skills/find-skills" -> id
      const id = url.pathname.replace('/api/v1/skills/', '');
      const res = await fetch(`https://skills.sh/${id}`);
      const html = await res.text();
      const prose = extractProse(html);
      if (!prose) return Response.json({ error: 'not_found' }, { status: 404 });
      return Response.json({
        id,
        files: [{ path: 'SKILL.md', contents: htmlToText(prose) }],
      });
    }

    return Response.json({ error: 'not_found' }, { status: 404 });
  },
};
```

Yang masih perlu dilengkapi sendiri: `extractProse()` + `htmlToText()` (port dari
`skill_store_remote_datasource.dart`), cache (mis. `caches.default` atau KV) supaya
tidak memanggil skills.sh tiap request, header CORS bila aplikasi di-build untuk web,
serta auth untuk proxy itu sendiri.

#### Opsi B3 — Bila kelak skills.sh menyediakan API key

Cukup ganti "upstream" di proxy (B2) menjadi `https://skills.sh/api/v1/...` dengan
header kunci tersebut. **Aplikasi tidak perlu diubah sama sekali** — inilah gunanya
abstraksi `SkillStoreRemoteDatasource`.

### 6.6 Troubleshooting

| Gejala | Kemungkinan penyebab & tindakan |
| --- | --- |
| `Toko skills menolak permintaan (HTTP 401)` | Proxy meneruskan tanpa token, atau token OIDC kedaluwarsa/hoisted ke module scope. Panggil `getVercelOidcToken()` di dalam handler. |
| `HTTP 404` padahal skill ada | Path `/api/v1/skills/{id}` tidak diteruskan apa adanya, atau ganti `/api/v1/skills/...` prefix terpotong. |
| `HTTP 429` | Kena rate limit 600/menit. Tambahkan cache/backoff di proxy, hormati `Retry-After`. |
| `HTTP 503` | skills.sh sedang tidak tersedia — ulangi dengan backoff. |
| `Respons toko skills tidak valid` | Proxy mengembalikan bukan JSON objek (mis. halaman HTML error). |
| `SKILL.md untuk … tidak tersedia` | Respons detail tidak punya `files[].path == "SKILL.md"` dengan `contents` non-kosong. |
| Tampilan tetap mode scrape | Nilai `SKILLS_STORE_API_BASE_URL` di-bake saat compile: perlu run/build ulang, bukan hot reload. |
| Jalan di desktop tapi gagal di web | Proxy belum mengirim header CORS (`Access-Control-Allow-Origin`). |

### 6.7 Keamanan

- Jangan pernah menaruh token/kunci skills.sh di aplikasi klien (`--dart-define`
  **bukan** tempat aman: nilainya tertanam di binary). Simpan hanya di proxy.
- Jangan commit `.env` / `.env.local` (`vercel env pull` menulis `VERCEL_OIDC_TOKEN`
  ke sana).
- Pertimbangkan membatasi proxy: hanya izinkan `GET`, batasi path ke `/api/v1/skills*`,
  dan tambahkan autentikasi aplikasi sendiri bila proxy diekspos publik.

## 7. Batasan & risiko yang diketahui

1. Mode A bergantung pada markup HTML skills.sh → bisa patah kapan saja tanpa
   peringatan. Penanganannya: pesan galat di UI + tombol "Coba lagi", dan logika
   terkumpul di satu file datasource.
2. Mode A tidak punya pencarian server-side (hanya saringan lokal All-time).
3. Instruksi mode A hasil konversi HTML→teks, bukan markdown mentah.
4. `SKILLS_STORE_API_BASE_URL` mengabaikan path dari base URL (lihat 6.3) — saat ini
   harus berupa origin.
5. Contoh `--dart-define` di doc comment
   `stores/skill_store_repository_provider.dart` saat ini menulis
   `https://cx-web.example/api/skills`, padahal menurut perilaku di poin 4 seharusnya
   `https://cx-web.example`. **Perlu diperbaiki** (lihat TODO).

## 8. Langkah berikutnya (TODO)

- [ ] Putuskan jalur proxy mana yang dipakai (B1 Vercel+OIDC, atau B2 Worker kita
      yang scrape lalu menyajikan bentuk API resmi).
- [ ] Buat proxy-nya, lalu uji dengan tiga perintah `curl` di bagian 6.4.
- [ ] Aktifkan di aplikasi dengan `--dart-define=SKILLS_STORE_API_BASE_URL=<origin>`
      dan uji manual: tab, pencarian, dan "Tambah".
- [ ] Rapikan contoh `--dart-define` di doc comment
      `skill_store_repository_provider.dart` (buang `/api/skills`), **atau** ubah
      implementasi agar menghormati base path (mis. memakai
      `baseUrl.replace(path: '${baseUrl.path}/api/v1/skills')`).
- [ ] (Opsional) Tambahkan indikator di UI tentang mode yang sedang aktif
      ("mode toko: scrape lokal" vs "proxy") supaya tidak membingungkan saat uji.
- [ ] (Opsional) Cache hasil katalog beberapa menit di sisi klien agar pindah tab
      tidak memanggil jaringan.

## 9. Perintah yang relevan

```bash
flutter analyze
flutter test test/skill_store_scrape_datasource_test.dart
flutter test
dart run build_runner build --delete-conflicting-outputs   # HANYA bila perlu refresh hash generated
flutter run -d linux
flutter run -d linux --dart-define=SKILLS_STORE_API_BASE_URL=https://skills-proxy.example
```

Catatan codegen: `ai_skills_repository.dart` (fungsi provider) memuat
`debugGetCreateSourceHash` yang dihitung dari `sha1(node.toSource())`. Setelah
perubahan body fungsi, hash di `.g.dart` menjadi basi (tidak error, tidak memengaruhi
analyze/test) dan sudah disegarkan lewat `build_runner` pada commit `435dde2`.
