/// Satu entri katalog skill dari skills.sh.
///
/// Bentuk field-nya sengaja dibuat sama dengan objek `V1Skill` pada API resmi
/// (`GET /api/v1/skills`) supaya mode scrape dan mode proxy memakai tipe yang
/// sama — padanan satu-tipe-untuk-semua-endpoint di store web.
class SkillStoreEntry {
  const SkillStoreEntry({
    required this.id,
    required this.slug,
    required this.name,
    required this.source,
    this.installs,
  });

  /// Id unik berformat `{source}/{slug}`. Sama dengan `id` di API skills.sh
  /// sekaligus path halaman detailnya (`https://skills.sh/<id>`), jadi dipakai
  /// untuk mengambil instruksi skill.
  final String id;

  /// Slug ramah URL, mis. `find-skills`.
  final String slug;

  /// Nama tampilan skill, mis. `Find Skills`.
  final String name;

  /// Repositori/sumber, format `owner/repo`, mis. `vercel-labs/skills`.
  final String source;

  /// Total pemasangan. Mode scrape hanya mendapat angka yang sudah dibulatkan
  /// store (mis. `3.9M`), jadi nilainya perkiraan; `null` bila tidak tersedia.
  final int? installs;

  /// Perintah pemasangan ala CLI skills.sh; ditampilkan sebagai info di UI.
  String get installCommand => 'npx skills add $source --skill $slug';
}

/// Pilihan katalog di skills.sh — padanan query `view` pada API resmi.
enum SkillStoreView {
  allTime('All-time', 'all-time', '/'),
  trending('Trending', 'trending', '/trending'),
  hot('Hot', 'hot', '/hot');

  const SkillStoreView(this.label, this.query, this.path);

  /// Label untuk tab UI.
  final String label;

  /// Nilai parameter `view` di API resmi.
  final String query;

  /// Path halaman daftar (dipakai mode scrape).
  final String path;
}
