import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/dompet_brand.dart';
import '../models/ai_skill.dart';

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

class AiSkillsSheet extends StatefulWidget {
  const AiSkillsSheet({super.key, required this.skills});

  final List<AiSkill> skills;

  @override
  State<AiSkillsSheet> createState() => _AiSkillsSheetState();
}

/// Mode tampilan sheet skills: daftar, form buat manual, atau form impor URL.
enum _SkillSheetMode { list, create, import }

class _AiSkillsSheetState extends State<AiSkillsSheet> {
  _SkillSheetMode _mode = _SkillSheetMode.list;

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
                    const Expanded(
                      child: Text(
                        'Kelola Skills',
                        style: TextStyle(
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
                  onCancel: () =>
                      setState(() => _mode = _SkillSheetMode.list),
                  onSubmit: (action) => Navigator.of(context).pop(action),
                )
              else if (_mode == _SkillSheetMode.import)
                AiSkillImportForm(
                  onCancel: () =>
                      setState(() => _mode = _SkillSheetMode.list),
                  onSubmit: (action) => Navigator.of(context).pop(action),
                )
              else
                AiSkillsList(
                  skills: widget.skills,
                  onCreate: () =>
                      setState(() => _mode = _SkillSheetMode.create),
                  onImport: () =>
                      setState(() => _mode = _SkillSheetMode.import),
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
    required this.onDelete,
  });

  final List<AiSkill> skills;
  final VoidCallback onCreate;
  final VoidCallback onImport;
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
                  hintText:
                      'https://raw.githubusercontent.com/.../SKILL.md',
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
