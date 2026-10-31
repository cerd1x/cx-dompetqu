import 'package:dompetqu/features/gen_ai/domain/entities/skill_store_entry.dart';

/// Kontrak toko skills (skills.sh).
///
/// Dipakai sheet skills untuk menampilkan daftar katalog dan mengambil isi
/// `SKILL.md` dari skill yang akan ditambahkan. Datasource konkretnya bisa
/// scrape halaman publik skills.sh atau (nanti) memakai API resmi lewat proxy.
abstract interface class SkillStoreRepository {
  /// Daftar skill untuk salah satu tampilan katalog.
  Future<List<SkillStoreEntry>> list(SkillStoreView view);

  /// Cari skill. Mode scrape menyaring daftar all-time yang sudah dimuat
  /// secara lokal, mode proxy meneruskan ke `GET /api/v1/skills/search`.
  Future<List<SkillStoreEntry>> search(String query);

  /// Instruksi (isi `SKILL.md`) untuk entri terpilih.
  Future<String> loadInstructions(SkillStoreEntry entry);
}
