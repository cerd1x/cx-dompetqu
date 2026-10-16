import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../domain/entities/skill_store_entry.dart';

/// Kontrak pengambilan data toko skills skills.sh.
///
/// Ada dua implementasi dengan kontrak yang sama supaya UI tidak berubah saat
/// sumbernya dialihkan: [SkillsShScrapeRemoteDatasource] (default, membaca
/// halaman publik) dan [SkillsShApiRemoteDatasource] (API resmi, dipakai saat
/// diarahkan ke proxy backend).
abstract interface class SkillStoreRemoteDatasource {
  Future<List<SkillStoreEntry>> list(SkillStoreView view);
  Future<List<SkillStoreEntry>> search(String query);
  Future<String> loadInstructions(SkillStoreEntry entry);
}

/// Mode default: membaca halaman publik skills.sh.
///
/// API resmi (`/api/v1/*`) mewajibkan token Vercel OIDC sehingga selalu 401
/// dari aplikasi klien, jadi katalog diambil dari HTML SSR halaman
/// `/`, `/trending`, dan `/hot`, sedangkan instruksi skill diambil dari
/// halaman detail `/{source}/{slug}` (isi `SKILL.md` yang sudah dirender).
/// Konsekuensinya: pencarian hanya menyaring hasil yang sudah dimuat dan
/// parser bisa rusak bila penanda HTML skills.sh berubah.
class SkillsShScrapeRemoteDatasource implements SkillStoreRemoteDatasource {
  SkillsShScrapeRemoteDatasource(this._client, {Uri? baseUrl})
    : baseUrl = baseUrl ?? Uri.parse(defaultBaseUrl);

  static const defaultBaseUrl = 'https://skills.sh';

  final http.Client _client;
  final Uri baseUrl;

  final Map<SkillStoreView, List<SkillStoreEntry>> _views = {};

  @override
  Future<List<SkillStoreEntry>> list(SkillStoreView view) async {
    final cached = _views[view];
    if (cached != null) return cached;

    final html = await _getHtml(baseUrl.replace(path: view.path));
    final entries = _parseLeaderboard(html);
    if (entries.isEmpty) {
      throw const FormatException(
        'Katalog skills.sh tidak terbaca (susunan halaman berubah?).',
      );
    }
    _views[view] = entries;
    return entries;
  }

  @override
  Future<List<SkillStoreEntry>> search(String query) async {
    final needle = query.trim().toLowerCase();
    if (needle.length < 2) return const [];

    final entries = await list(SkillStoreView.allTime);
    return entries
        .where(
          (entry) =>
              entry.name.toLowerCase().contains(needle) ||
              entry.slug.toLowerCase().contains(needle) ||
              entry.source.toLowerCase().contains(needle),
        )
        .toList(growable: false);
  }

  @override
  Future<String> loadInstructions(SkillStoreEntry entry) async {
    final html = await _getHtml(baseUrl.replace(path: '/${entry.id}'));
    final prose = _extractProseHtml(html);
    if (prose == null) {
      throw FormatException('Halaman ${entry.id} tidak memuat SKILL.md.');
    }

    final text = htmlToPlainText(prose);
    if (text.isEmpty) {
      throw FormatException('Isi SKILL.md ${entry.id} kosong.');
    }
    return _clampInstructions(text);
  }

  Future<String> _getHtml(Uri uri) async {
    final response = await _client
        .get(uri, headers: const {'accept': 'text/html'})
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'Gagal memuat data skills.sh (HTTP ${response.statusCode}).',
        uri: uri,
      );
    }
    // Charset halaman bisa tidak dideklarasikan, jadi decode UTF-8 eksplisit
    // agar nama skill non-ASCII tidak rusak.
    return utf8.decode(response.bodyBytes, allowMalformed: true);
  }
}

/// Mode proxy: memakai bentuk API resmi skills.sh (`/api/v1/...`).
///
/// Dipakai bila `--dart-define=SKILLS_STORE_API_BASE_URL=...` diisi. Backend
/// (cx-web/cx-services) yang bertugas menyisipkan token Vercel OIDC, sehingga
/// aplikasi cukup bicara ke proxy tanpa menyimpan kredensial.
class SkillsShApiRemoteDatasource implements SkillStoreRemoteDatasource {
  const SkillsShApiRemoteDatasource(
    this._client, {
    required this.baseUrl,
    this.headers = const {},
  });

  final http.Client _client;
  final Uri baseUrl;
  final Map<String, String> headers;

  @override
  Future<List<SkillStoreEntry>> list(SkillStoreView view) async {
    final json = await _getJson('/api/v1/skills', {
      'view': view.query,
      'per_page': '100',
    });
    return _mapEntries(json['data']);
  }

  @override
  Future<List<SkillStoreEntry>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return const [];
    final json = await _getJson('/api/v1/skills/search', {
      'q': trimmed,
      'limit': '50',
    });
    return _mapEntries(json['data']);
  }

  @override
  Future<String> loadInstructions(SkillStoreEntry entry) async {
    final json = await _getJson('/api/v1/skills/${entry.id}', const {});

    final files = json['files'];
    if (files is! List) {
      throw FormatException('Skill ${entry.id} tidak punya berkas.');
    }

    Map<dynamic, dynamic>? selected;
    for (final file in files) {
      if (file is! Map) continue;
      final path = file['path'];
      if (path is! String) continue;
      final lower = path.toLowerCase();
      if (lower == 'skill.md') {
        selected = file;
        break;
      }
      selected ??= lower.endsWith('.md') ? file : null;
    }

    final contents = selected?['contents'];
    if (contents is! String || contents.trim().isEmpty) {
      throw FormatException('SKILL.md untuk ${entry.id} tidak tersedia.');
    }
    return _clampInstructions(contents.trim());
  }

  Future<Map<String, dynamic>> _getJson(
    String path,
    Map<String, String> query,
  ) async {
    final uri = baseUrl.replace(
      path: path,
      queryParameters: query.isEmpty ? null : query,
    );
    final response = await _client
        .get(uri, headers: {'accept': 'application/json', ...headers})
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'Toko skills menolak permintaan (HTTP ${response.statusCode}).',
        uri: uri,
      );
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Respons toko skills tidak valid.');
    }
    return decoded;
  }

  List<SkillStoreEntry> _mapEntries(Object? data) {
    if (data is! List) return const [];

    final entries = <SkillStoreEntry>[];
    for (final item in data) {
      if (item is! Map) continue;
      final id = item['id'];
      if (id is! String || id.isEmpty) continue;

      final slug = item['slug'] is String && (item['slug'] as String).isNotEmpty
          ? item['slug'] as String
          : id.split('/').last;
      final name = item['name'];
      entries.add(
        SkillStoreEntry(
          id: id,
          slug: slug,
          name: name is String && name.isNotEmpty ? name : slug,
          source: item['source'] is String
              ? item['source'] as String
              : id.split('/').take(2).join('/'),
          installs: item['installs'] is int ? item['installs'] as int : null,
        ),
      );
    }
    return entries;
  }
}

/// Penanda awal baris leaderboard di HTML SSR skills.sh.
const _rowMarker = '<a class="group grid ';

/// Batas panjang instruksi (padanan `maxBodyBytes` di
/// `ai_skill_import_datasource.dart`) supaya prompt AI tidak membengkak.
const _maxInstructionsChars = 50 * 1024;

/// Mengubah satu halaman leaderboard skills.sh menjadi daftar entri.
///
/// Tiap baris berbentuk anchor `class="group grid ..."` berisi href
/// `/{source}/{slug}`, `<h3>` nama, `<p>` source, dan kolom installs. Baris
/// yang tidak memenuhi pola dilewati supaya anchor lain di halaman tidak ikut
/// terbaca.
List<SkillStoreEntry> _parseLeaderboard(String html) {
  final entries = <SkillStoreEntry>[];
  final seen = <String>{};

  for (final chunk in html.split(_rowMarker).skip(1)) {
    final end = chunk.indexOf('</a>');
    if (end < 0) continue;
    final row = chunk.substring(0, end);

    final href = RegExp(r'href="/([^"]+)"').firstMatch(row)?.group(1);
    final name = _textOf(row, 'h3');
    final source = _textOf(row, 'p');
    if (href == null || name == null || source == null) continue;
    // Hanya baris skill: source wajib `owner/repo` dan href-nya berawalan itu.
    if (source.isEmpty || !href.startsWith('$source/')) continue;
    if (!seen.add(href)) continue;

    entries.add(
      SkillStoreEntry(
        id: href,
        slug: href.split('/').last,
        name: htmlToPlainText(name),
        source: htmlToPlainText(source),
        installs: _parseCount(
          RegExp(
            r'font-mono text-sm text-foreground">([^<]+)<',
          ).firstMatch(row)?.group(1),
        ),
      ),
    );
  }
  return entries;
}

String? _textOf(String html, String tag) {
  return RegExp(
    '<$tag[^>]*>([^<]*)</$tag>',
    caseSensitive: false,
  ).firstMatch(html)?.group(1);
}

/// Mengubah angka tampilan store (mis. `3.9M`, `99,722`) menjadi perkiraan
/// jumlah pemasangan — hanya untuk ditampilkan, bukan data presisi.
int? _parseCount(String? raw) {
  if (raw == null) return null;
  final text = raw.trim().replaceAll(',', '');
  final match = RegExp(
    r'^([0-9]*\.?[0-9]+)\s*([KMB])?$',
    caseSensitive: false,
  ).firstMatch(text);
  if (match == null) return null;

  final value = double.tryParse(match.group(1)!);
  if (value == null) return null;
  final multiplier = switch (match.group(2)?.toUpperCase()) {
    'K' => 1e3,
    'M' => 1e6,
    'B' => 1e9,
    _ => 1.0,
  };
  return (value * multiplier).round();
}

/// Mengambil div `prose` (wadah isi `SKILL.md` hasil render markdown) dengan
/// mencocokkan kedalaman tag, karena isinya div bersarang.
String? _extractProseHtml(String html) {
  final markerIndex = html.indexOf('class="prose prose-invert');
  if (markerIndex < 0) return null;

  final start = html.lastIndexOf('<div', markerIndex);
  if (start < 0) return null;

  final tagPattern = RegExp(r'<(/?)div\b[^>]*>', caseSensitive: false);
  var depth = 0;
  for (final match in tagPattern.allMatches(html, start)) {
    if (match.group(1) == '/') {
      depth--;
      if (depth == 0) return html.substring(start, match.end);
    } else {
      depth++;
    }
  }
  return null;
}

/// Konversi HTML menjadi teks polos untuk disimpan sebagai instruksi skill.
String htmlToPlainText(String html) {
  final text = html
      .replaceAll(
        RegExp(r'<(script|style)\b[^>]*>[\s\S]*?</\1>', caseSensitive: false),
        '',
      )
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(
        RegExp(
          r'</(p|div|li|ul|ol|h[1-6]|tr|pre|blockquote|table)>',
          caseSensitive: false,
        ),
        '\n',
      )
      .replaceAll(RegExp(r'<li\b[^>]*>', caseSensitive: false), '- ')
      .replaceAll(RegExp(r'<[^>]+>'), '');

  return _decodeHtmlEntities(
        text,
      )
      .split('\n')
      .map((line) => line.replaceAll(RegExp(r'[ \t]+'), ' ').trimRight())
      .join('\n')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();
}

const _namedEntities = <String, String>{
  'amp': '&',
  'lt': '<',
  'gt': '>',
  'quot': '"',
  'apos': "'",
  'nbsp': ' ',
  'hellip': '…',
  'mdash': '—',
  'ndash': '–',
  'lsquo': '‘',
  'rsquo': '’',
  'ldquo': '“',
  'rdquo': '”',
  'middot': '·',
  'bull': '•',
  'copy': '©',
  'times': '×',
  'check': '✓',
};

String _decodeHtmlEntities(String input) {
  return input.replaceAllMapped(
    RegExp(r'&(#x?[0-9a-fA-F]+|[a-zA-Z]+);'),
    (match) {
      final token = match.group(1)!;
      if (token.startsWith('#')) {
        final isHex = token.length > 1 && token[1].toLowerCase() == 'x';
        final digits = isHex ? token.substring(2) : token.substring(1);
        final code = int.tryParse(digits, radix: isHex ? 16 : 10);
        return code == null ? match.group(0)! : String.fromCharCode(code);
      }
      return _namedEntities[token.toLowerCase()] ?? match.group(0)!;
    },
  );
}

String _clampInstructions(String text) {
  if (text.length <= _maxInstructionsChars) return text;
  return '${text.substring(0, _maxInstructionsChars)}\n\n'
      '[Instruksi dipotong otomatis karena melebihi batas ukuran.]';
}
