import 'package:dompetqu/features/gen_ai/domain/entities/skill_store_entry.dart';
import 'package:dompetqu/features/gen_ai/domain/repositories/skill_store_repository.dart';
import 'package:dompetqu/features/gen_ai/adapters/datasources/skill_store_remote_datasource.dart';

/// Penerusan tipis ke datasource — semua aturan scrape/API ada di datasource
/// supaya titik ganti sumber (scrape ↔ proxy) tetap satu tempat.
class SkillStoreRepositoryImpl implements SkillStoreRepository {
  const SkillStoreRepositoryImpl(this._remote);

  final SkillStoreRemoteDatasource _remote;

  @override
  Future<List<SkillStoreEntry>> list(SkillStoreView view) => _remote.list(view);

  @override
  Future<List<SkillStoreEntry>> search(String query) => _remote.search(query);

  @override
  Future<String> loadInstructions(SkillStoreEntry entry) =>
      _remote.loadInstructions(entry);
}
