import 'dart:convert';
import 'dart:io';

import 'package:dompetqu/features/gen_ai/data/datasources/skill_store_remote_datasource.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/skill_store_entry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Fixture dipangkas dari HTML SSR skills.sh (struktur asli: anchor
/// `class="group grid ..."` berisi rank, `<h3>` nama, `<p>` source, dan kolom
/// installs).
const _leaderboardHtml = '''
<div>
<a class="group grid grid-cols-[auto 1fr auto] lg:grid-cols-16 items-start" href="/vercel-labs/skills/find-skills"><div class="min-w-7"><span class="font-mono">1</span></div><div class="lg:col-span-11"><h3 class="font-semibold">find-skills</h3><p class="font-mono">vercel-labs/skills</p></div><div><svg><circle/></svg></div><div class="lg:col-span-2 text-right"><span class="font-mono text-sm text-foreground">3.9M</span></div></a>
<a class="group grid grid-cols-[auto 1fr auto] items-start" href="/expo/skills/react-native"><div><span>2</span></div><div><h3>React Native &amp; Expo</h3><p>expo/skills</p></div><div></div><div><span class="font-mono text-sm text-foreground">3,842</span></div></a>
<a class="group grid grid-cols-[auto 1fr auto] items-start" href="/agent/claude-code"><div><h3>Claude Code</h3><p>Claude Code</p></div><div></div><div><span class="font-mono text-sm text-foreground">1.2M</span></div></a>
</div>
''';

const _detailHtml = '''
<html><body>
<div class="wrapper"><div class="prose prose-invert max-w-none prose-headings:font-semibold"><h1>Find Skills</h1>
<p>This skill helps you discover and install skills.</p>
<ul><li>Use it when the user asks &quot;how do I do X&quot;</li><li>Second item</li></ul>
<pre><code>npx skills add vercel-labs/skills</code></pre>
</div></div>
</body></html>
''';

http.Response _html(String body) =>
    http.Response.bytes(utf8.encode(body), 200, headers: {
      'content-type': 'text/html; charset=utf-8',
    });

void main() {
  group('SkillsShScrapeRemoteDatasource', () {
    late List<Uri> requested;

    SkillsShScrapeRemoteDatasource build({
      String? detailBody,
      int detailStatus = 200,
    }) {
      requested = [];
      final client = MockClient((request) async {
        requested.add(request.url);
        if (request.url.path == '/vercel-labs/skills/find-skills') {
          return http.Response.bytes(
            utf8.encode(detailBody ?? _detailHtml),
            detailStatus,
          );
        }
        if (request.url.path == '/' || request.url.path == '/trending') {
          return _html(_leaderboardHtml);
        }
        return http.Response('not found', 404);
      });
      return SkillsShScrapeRemoteDatasource(client);
    }

    test('membaca baris leaderboard dan melewatkan anchor non-skill', () async {
      final datasource = build();

      final entries = await datasource.list(SkillStoreView.allTime);

      expect(entries, hasLength(2));
      expect(entries.first.id, 'vercel-labs/skills/find-skills');
      expect(entries.first.slug, 'find-skills');
      expect(entries.first.name, 'find-skills');
      expect(entries.first.source, 'vercel-labs/skills');
      expect(entries.first.installs, 3900000);

      // Entitas HTML di-decode dan angka ribuan dibaca apa adanya.
      expect(entries.last.name, 'React Native & Expo');
      expect(entries.last.installs, 3842);
    });

    test('memakai cache per tampilan katalog', () async {
      final datasource = build();

      await datasource.list(SkillStoreView.allTime);
      await datasource.list(SkillStoreView.allTime);

      expect(requested, hasLength(1));
    });

    test('pencarian menyaring katalog lokal dan minimal 2 huruf', () async {
      final datasource = build();

      expect(await datasource.search('r'), isEmpty);
      final found = await datasource.search('expo');

      expect(found, hasLength(1));
      expect(found.single.id, 'expo/skills/react-native');
      // Pencarian memakai cache all-time yang sudah dimuat di atas.
      expect(requested, hasLength(1));
    });

    test('mengubah SKILL.md menjadi teks polos', () async {
      final datasource = build();
      final entries = await datasource.list(SkillStoreView.allTime);

      final instructions = await datasource.loadInstructions(entries.first);

      expect(instructions, contains('Find Skills'));
      expect(
        instructions,
        contains('- Use it when the user asks "how do I do X"'),
      );
      expect(instructions, contains('npx skills add vercel-labs/skills'));
      expect(instructions, isNot(contains('<')));
      expect(instructions, isNot(contains('&quot;')));
    });

    test('gagal jelas saat halaman detail tidak memuat SKILL.md', () async {
      final datasource = build(detailBody: '<html><body>kosong</body></html>');
      const entry = SkillStoreEntry(
        id: 'vercel-labs/skills/find-skills',
        slug: 'find-skills',
        name: 'find-skills',
        source: 'vercel-labs/skills',
      );

      expect(
        () => datasource.loadInstructions(entry),
        throwsA(isA<FormatException>()),
      );
    });

    test('melempar HttpException saat katalog tidak tersedia', () async {
      final client = MockClient(
        (request) async => http.Response('boom', 500),
      );
      final datasource = SkillsShScrapeRemoteDatasource(client);

      expect(
        () => datasource.list(SkillStoreView.hot),
        throwsA(isA<HttpException>()),
      );
    });
  });

  group('SkillsShApiRemoteDatasource', () {
    test('memetakan respons V1Skill dan mengambil files SKILL.md', () async {
      final client = MockClient((request) async {
        if (request.url.path == '/api/v1/skills') {
          expect(request.url.queryParameters['view'], 'trending');
          return http.Response(
            jsonEncode({
              'data': [
                {
                  'id': 'expo/skills/react-native',
                  'slug': 'react-native',
                  'name': 'React Native',
                  'source': 'expo/skills',
                  'installs': 3842,
                },
              ],
              'pagination': {'page': 0, 'hasMore': false},
            }),
            200,
          );
        }
        if (request.url.path == '/api/v1/skills/expo/skills/react-native') {
          return http.Response(
            jsonEncode({
              'id': 'expo/skills/react-native',
              'files': [
                {'path': 'examples/app.tsx', 'contents': 'export default 1;'},
                {'path': 'SKILL.md', 'contents': '# React Native\nPanduan.'},
              ],
            }),
            200,
          );
        }
        return http.Response('not found', 404);
      });
      final datasource = SkillsShApiRemoteDatasource(
        client,
        baseUrl: Uri.parse('https://proxy.example'),
      );

      final entries = await datasource.list(SkillStoreView.trending);
      expect(entries.single.name, 'React Native');
      expect(entries.single.installs, 3842);

      final instructions = await datasource.loadInstructions(entries.single);
      expect(instructions, '# React Native\nPanduan.');
    });

    test('pencarian butuh minimal 2 huruf tanpa memanggil jaringan', () async {
      var calls = 0;
      final client = MockClient((request) async {
        calls++;
        return http.Response('{}', 200);
      });
      final datasource = SkillsShApiRemoteDatasource(
        client,
        baseUrl: Uri.parse('https://proxy.example'),
      );

      expect(await datasource.search('a'), isEmpty);
      expect(calls, 0);
    });
  });
}
