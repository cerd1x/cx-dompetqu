import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_skill_import_datasource.g.dart';

abstract interface class AiSkillImportDatasource {
  Future<String> fetchText(Uri uri);
}

@Riverpod(keepAlive: true)
AiSkillImportDatasource aiSkillImportDatasource(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return HttpAiSkillImportDatasource(client);
}

class HttpAiSkillImportDatasource implements AiSkillImportDatasource {
  const HttpAiSkillImportDatasource(this._client);

  static const maxBodyBytes = 50 * 1024;
  final http.Client _client;

  @override
  Future<String> fetchText(Uri uri) async {
    final request = http.Request('GET', uri);
    final response = await _client
        .send(request)
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('Gagal mengunduh (HTTP ${response.statusCode}).');
    }
    final body = BytesBuilder(copy: false);
    await for (final chunk in response.stream.timeout(
      const Duration(seconds: 15),
    )) {
      if (body.length + chunk.length > maxBodyBytes) {
        throw const FormatException('Isi terlalu besar (maksimum 50 KB).');
      }
      body.add(chunk);
    }
    final text = utf8.decode(body.takeBytes()).trim();
    if (text.isEmpty) {
      throw const FormatException('Isi URL kosong.');
    }
    return text;
  }
}
