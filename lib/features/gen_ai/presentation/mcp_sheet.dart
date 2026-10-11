import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/dompet_brand.dart';
import '../models/mcp_server.dart';

sealed class McpAction {
  const McpAction();
}

final class AddMcpServer extends McpAction {
  const AddMcpServer({required this.name, required this.url});

  final String name;
  final String url;
}

final class RemoveMcpServer extends McpAction {
  const RemoveMcpServer(this.id);

  final String id;
}

class McpSheet extends StatefulWidget {
  const McpSheet({super.key, required this.servers});

  final List<McpServer> servers;

  @override
  State<McpSheet> createState() => _McpSheetState();
}

class _McpSheetState extends State<McpSheet> {
  bool _creating = false;

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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
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
                        'Kelola MCP',
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
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Text(
                  'Endpoint disimpan di perangkat. Koneksi dan pemanggilan '
                  'MCP belum diaktifkan.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              if (_creating)
                McpServerForm(
                  onCancel: () => setState(() => _creating = false),
                  onSubmit: (action) => Navigator.of(context).pop(action),
                )
              else
                McpServerList(
                  servers: widget.servers,
                  onCreate: () => setState(() => _creating = true),
                  onRemove: (id) =>
                      Navigator.of(context).pop(RemoveMcpServer(id)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class McpServerList extends StatelessWidget {
  const McpServerList({
    super.key,
    required this.servers,
    required this.onCreate,
    required this.onRemove,
  });

  final List<McpServer> servers;
  final VoidCallback onCreate;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (servers.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Text(
                'Belum ada endpoint MCP yang tersimpan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: servers.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: Colors.white10),
                itemBuilder: (context, index) {
                  final server = servers[index];
                  return ListTile(
                    title: Text(
                      server.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      server.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white60),
                    ),
                    trailing: IconButton(
                      tooltip: 'Hapus ${server.name}',
                      onPressed: () => onRemove(server.id),
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
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add_link),
                label: const Text('Tambah MCP'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class McpServerForm extends StatefulWidget {
  const McpServerForm({
    super.key,
    required this.onCancel,
    required this.onSubmit,
  });

  final VoidCallback onCancel;
  final ValueChanged<AddMcpServer> onSubmit;

  @override
  State<McpServerForm> createState() => _McpServerFormState();
}

class _McpServerFormState extends State<McpServerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    widget.onSubmit(
      AddMcpServer(
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
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nama server',
                  hintText: 'Contoh: MCP lokal',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama server wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'URL endpoint',
                  hintText: 'https://server.example.com/mcp',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'URL endpoint wajib diisi.';
                  }
                  final uri = Uri.tryParse(value.trim());
                  if (uri == null ||
                      (uri.scheme != 'http' && uri.scheme != 'https') ||
                      uri.host.isEmpty) {
                    return 'Masukkan URL endpoint http/https yang valid.';
                  }
                  return null;
                },
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
