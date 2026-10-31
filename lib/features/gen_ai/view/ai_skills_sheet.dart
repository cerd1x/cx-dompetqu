import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:dompetqu/core/theme/dompet_brand.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/ai_skill.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/skill_store_entry.dart';
import 'package:dompetqu/features/gen_ai/domain/repositories/skill_store_repository.dart';

sealed class AiSkillAction {
  const AiSkillAction();
}

final class CreateAiSkill extends AiSkillAction {
  const CreateAiSkill({required this.name, required this.instructions});

  final String name;
  final String instructions;
}

final class DeleteAiSkill extends AiSkillAction {
  const DeleteAiSkill(this.id);

  final String id;
}

final class ImportAiSkill extends AiSkillAction {
  const ImportAiSkill({required this.name, required this.url});

  final String name;
  final String url;
}

/// Menambahkan skill langsung dari toko skills.sh; instruksi diunduh
/// controller lewat repository (bukan di UI) agar tetap satu jalur simpan.
final class ImportAiSkillFromStore extends AiSkillAction {
  const ImportAiSkillFromStore(this.entry);

  final SkillStoreEntry entry;
}

class AiSkillsSheet extends StatefulWidget {
  const AiSkillsSheet({
    super.key,
    required this.skills,
    required this.storeRepository,
  });

  final List<AiSkill> skills;

  /// Toko skills (skills.sh) — sumber katalog dan isi `SKILL.md`.
  final SkillStoreRepository storeRepository;

  @override
  State<AiSkillsSheet> createState() => _AiSkillsSheetState();
}

/// Mode tampilan sheet skills: daftar, form buat manual, form impor URL, atau
/// katalog toko skills.sh.
enum _SkillSheetMode { list, create, import, store }

class _AiSkillsSheetState extends State<AiSkillsSheet> {
  _SkillSheetMode _mode = _SkillSheetMode.list;

  String get _title =>
      _mode == _SkillSheetMode.store ? 'Toko Skills' : 'Kelola Skills';

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.8;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Box(
        style: BoxStyler()
            .constraints(
              BoxConstraintsMix.value(BoxConstraints(maxHeight: maxHeight)),
            )
            .decoration(
              DecorationMix.value(
                const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border(top: BorderSide(color: DompetBrand.csBorder)),
                ),
              ),
            ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
                child: Row(
                  children: [
                    if (_mode == _SkillSheetMode.store)
                      IconButton(
                        tooltip: 'Kembali',
                        onPressed: () =>
                            setState(() => _mode = _SkillSheetMode.list),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white70,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        _title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Tutup',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.white10),
              if (_mode == _SkillSheetMode.create)
                AiSkillForm(
                  onCancel: () => setState(() => _mode = _SkillSheetMode.list),
                  onSubmit: (action) => Navigator.of(context).pop(action),
                )
              else if (_mode == _SkillSheetMode.import)
                AiSkillImportForm(
                  onCancel: () => setState(() => _mode = _SkillSheetMode.list),
                  onSubmit: (action) => Navigator.of(context).pop(action),
                )
              else if (_mode == _SkillSheetMode.store)
                AiSkillStoreBrowser(
                  repository: widget.storeRepository,
                  onAdd: (entry) =>
                      Navigator.of(context).pop(ImportAiSkillFromStore(entry)),
                )
              else
                AiSkillsList(
                  skills: widget.skills,
                  onCreate: () =>
                      setState(() => _mode = _SkillSheetMode.create),
                  onImport: () =>
                      setState(() => _mode = _SkillSheetMode.import),
                  onBrowseStore: () =>
                      setState(() => _mode = _SkillSheetMode.store),
                  onDelete: (id) =>
                      Navigator.of(context).pop(DeleteAiSkill(id)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AiSkillsList extends StatelessWidget {
  const AiSkillsList({
    super.key,
    required this.skills,
    required this.onCreate,
    required this.onImport,
    required this.onBrowseStore,
    required this.onDelete,
  });

  final List<AiSkill> skills;
  final VoidCallback onCreate;
  final VoidCallback onImport;
  final VoidCallback onBrowseStore;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (skills.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 20),
              child: Text(
                'Belum ada skill. Buat skill untuk menyimpan instruksi khusus.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: skills.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: Colors.white10),
                itemBuilder: (context, index) {
                  final skill = skills[index];
                  return ListTile(
                    title: Text(
                      skill.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      skill.instructions,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white60),
                    ),
                    trailing: IconButton(
                      tooltip: 'Hapus ${skill.name}',
                      onPressed: () => onDelete(skill.id),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton.icon(
                  onPressed: onCreate,
                  icon: const Icon(Icons.add),
                  label: const Text('Buat skill'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: onBrowseStore,
                  icon: const Icon(Icons.storefront_outlined),
                  label: const Text('Toko skills (skills.sh)'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: onImport,
                  icon: const Icon(Icons.link),
                  label: const Text('Impor dari URL'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AiSkillForm extends StatefulWidget {
  const AiSkillForm({
    super.key,
    required this.onCancel,
    required this.onSubmit,
  });

  final VoidCallback onCancel;
  final ValueChanged<CreateAiSkill> onSubmit;

  @override
  State<AiSkillForm> createState() => _AiSkillFormState();
}

class _AiSkillFormState extends State<AiSkillForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    widget.onSubmit(
      CreateAiSkill(
        name: _nameController.text.trim(),
        instructions: _instructionsController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nama skill',
                  hintText: 'Contoh: Perencana anggaran',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama skill wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                minLines: 3,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Instruksi',
                  hintText: 'Jelaskan cara AI menggunakan skill ini.',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Instruksi wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Form URL untuk impor skill; pengunduhan dan penyimpanan ditangani controller.
class AiSkillImportForm extends StatefulWidget {
  const AiSkillImportForm({
    super.key,
    required this.onCancel,
    required this.onSubmit,
  });

  final VoidCallback onCancel;
  final ValueChanged<ImportAiSkill> onSubmit;

  @override
  State<AiSkillImportForm> createState() => _AiSkillImportFormState();
}

class _AiSkillImportFormState extends State<AiSkillImportForm> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _import() {
    if (_formKey.currentState?.validate() != true) return;
    widget.onSubmit(
      ImportAiSkill(
        name: _nameController.text.trim(),
        url: _urlController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _urlController,
                autofocus: true,
                keyboardType: TextInputType.url,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'URL skill',
                  hintText: 'https://raw.githubusercontent.com/.../SKILL.md',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'URL wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nama skill',
                  hintText: 'Contoh: Perencana anggaran',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama skill wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _import,
                      child: const Text('Impor & Simpan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Katalog toko skills.sh.
///
/// Widget ini hanya memilih entri (tidak mengunduh instruksi) — pengunduhan dan
/// penyimpanan tetap di controller lewat `ImportAiSkillFromStore`, sejalan
/// dengan pola sheet skills yang lain. Mode scrape tidak punya pencarian
/// server-side, jadi query disaring lokal oleh repository.
class AiSkillStoreBrowser extends StatefulWidget {
  const AiSkillStoreBrowser({
    super.key,
    required this.repository,
    required this.onAdd,
  });

  final SkillStoreRepository repository;
  final ValueChanged<SkillStoreEntry> onAdd;

  @override
  State<AiSkillStoreBrowser> createState() => _AiSkillStoreBrowserState();
}

class _AiSkillStoreBrowserState extends State<AiSkillStoreBrowser> {
  /// Jeda debounce pencarian, supaya tiap ketikan tidak memicu permintaan.
  static const _searchDebounce = Duration(milliseconds: 350);

  final _searchController = TextEditingController();
  Timer? _debounce;
  SkillStoreView _view = SkillStoreView.allTime;
  List<SkillStoreEntry> _entries = const [];
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final query = _searchController.text.trim();
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final entries = query.length >= 2
          ? await widget.repository.search(query)
          : await widget.repository.list(_view);
      if (!mounted) return;
      setState(() {
        _entries = entries;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  void _selectView(SkillStoreView view) {
    if (view == _view) return;
    _searchController.clear();
    setState(() => _view = view);
    unawaited(_load());
  }

  void _onQueryChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(_searchDebounce, () => unawaited(_load()));
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // filter section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<SkillStoreView>(
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  segments: [
                    for (final view in SkillStoreView.values)
                      ButtonSegment(value: view, label: Text(view.label)),
                  ],
                  selected: {_view},
                  onSelectionChanged: (selection) =>
                      _selectView(selection.first),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  onChanged: _onQueryChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    hintText: 'Cari skill (min. 2 huruf)',
                    suffixIcon: IconButton(
                      tooltip: 'Muat ulang',
                      onPressed: () => unawaited(_load()),
                      icon: const Icon(Icons.refresh, color: Colors.white54),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sumber: skills.sh',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          // results section
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              child: Column(
                children: [
                  Text(
                    'Gagal memuat toko skills.\n$_error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white60),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => unawaited(_load()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba lagi'),
                  ),
                ],
              ),
            )
          else if (_entries.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 24),
              child: Text(
                'Tidak ada skill yang cocok.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: _entries.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: Colors.white10),
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return ListTile(
                    isThreeLine: true,
                    title: Text(
                      entry.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          [
                            entry.source,
                            if (entry.installs != null)
                              '${_formatInstalls(entry.installs!)} pemasangan',
                          ].join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white60),
                        ),
                        Text(
                          entry.installCommand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    trailing: TextButton(
                      onPressed: () => widget.onAdd(entry),
                      child: const Text('Tambah'),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Angka pemasangan mode scrape sudah dibulatkan store (mis. `3.9M`), jadi
  /// ditampilkan ringkas ala Indonesia.
  String _formatInstalls(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)} jt';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)} rb';
    return '$value';
  }
}
