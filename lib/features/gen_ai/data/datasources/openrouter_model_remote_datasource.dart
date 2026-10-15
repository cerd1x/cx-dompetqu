import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../domain/entities/openrouter_model.dart';

abstract interface class OpenRouterModelRemoteDataSource {
  Future<List<OpenRouterModel>> loadModels({
    required String baseUrl,
    required String apiKey,
    Map<String, String> headers = const {},
  });
}

class HttpOpenRouterModelRemoteDataSource
    implements OpenRouterModelRemoteDataSource {
  const HttpOpenRouterModelRemoteDataSource(this._client);

  final http.Client _client;

  @override
  Future<List<OpenRouterModel>> loadModels({
    required String baseUrl,
    required String apiKey,
    Map<String, String> headers = const {},
  }) async {
    if (apiKey.trim().isEmpty) {
      throw StateError('API key OpenRouter belum diatur di Pengaturan AI.');
    }

    final uri = _modelsUri(baseUrl);
    final requestHeaders = <String, String>{...headers};
    requestHeaders.removeWhere(
      (key, _) =>
          key.toLowerCase() == 'accept' || key.toLowerCase() == 'authorization',
    );
    requestHeaders['Accept'] = 'application/json';
    requestHeaders['Authorization'] = 'Bearer ${apiKey.trim()}';

    final response = await _client
        .get(uri, headers: requestHeaders)
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'Gagal memuat model OpenRouter (HTTP ${response.statusCode}).',
        uri: uri,
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> || decoded['data'] is! List) {
      throw const FormatException(
        'Respons katalog model OpenRouter tidak valid.',
      );
    }

    final models = <OpenRouterModel>[];
    for (final item in decoded['data'] as List) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException(
          'Respons katalog model OpenRouter tidak valid.',
        );
      }
      final id = item['id'];
      if (id is! String || id.trim().isEmpty) {
        throw const FormatException(
          'Respons katalog model OpenRouter tidak valid.',
        );
      }
      final name = item['name'];
      final contextLength = item['context_length'];
      models.add(
        OpenRouterModel(
          id: id,
          name: name is String && name.trim().isNotEmpty ? name : id,
          contextLength: contextLength is num ? contextLength.toInt() : null,
        ),
      );
    }

    models.sort(
      (first, second) =>
          first.name.toLowerCase().compareTo(second.name.toLowerCase()),
    );
    return models;
  }

  Uri _modelsUri(String baseUrl) {
    final uri = Uri.tryParse(baseUrl.trim());
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.toLowerCase() != 'openrouter.ai') {
      throw const FormatException(
        'Base URL harus menggunakan https://openrouter.ai.',
      );
    }

    var path = uri.path.replaceFirst(RegExp(r'/+$'), '');
    if (path.endsWith('/chat/completions')) {
      path = path.substring(0, path.length - '/chat/completions'.length);
    }
    if (!path.endsWith('/models')) {
      path = '$path/models';
    }
    return Uri.https('openrouter.ai', path);
  }
}
