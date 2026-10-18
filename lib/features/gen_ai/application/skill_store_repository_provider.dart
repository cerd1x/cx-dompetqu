import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/datasources/skill_store_remote_datasource.dart';
import '../data/repositories/skill_store_repository_impl.dart';
import '../domain/repositories/skill_store_repository.dart';

/// Base URL proxy toko skills (opsional, diisi saat build).
///
/// Kosong (default) = mode scrape halaman publik skills.sh. Bila diisi, aplikasi
/// memakai bentuk API resmi skills.sh lewat proxy milik backend, mis.:
/// `flutter run -d linux --dart-define=SKILLS_STORE_API_BASE_URL=https://cx-web.example/api/skills`
/// Backend yang menyisipkan token Vercel OIDC — token tidak disimpan di klien.
const _skillsStoreApiBaseUrl = String.fromEnvironment(
  'SKILLS_STORE_API_BASE_URL',
);

/// Titik pilih sumber toko skills: scrape (tanpa backend) atau proxy API resmi.
final skillStoreRemoteDatasourceProvider = Provider<SkillStoreRemoteDatasource>(
  (ref) {
    final client = http.Client();
    ref.onDispose(client.close);

    if (_skillsStoreApiBaseUrl.isEmpty) {
      return SkillsShScrapeRemoteDatasource(client);
    }
    return SkillsShApiRemoteDatasource(
      client,
      baseUrl: Uri.parse(_skillsStoreApiBaseUrl),
    );
  },
  name: 'skillStoreRemoteDatasource',
);

final skillStoreRepositoryProvider = Provider<SkillStoreRepository>((ref) {
  return SkillStoreRepositoryImpl(
    ref.watch(skillStoreRemoteDatasourceProvider),
  );
}, name: 'skillStoreRepository');
