import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  String? _category;
  final _projectUrl = TextEditingController();
  final _imageUrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _projectUrl.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  String? _requiredText(String? value, {int? maxLength}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Kolom ini wajib diisi';
    if (maxLength != null && text.length > maxLength) {
      return 'Maksimal $maxLength karakter';
    }
    return null;
  }

  String? _url(String? value, {bool required = true}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return required ? 'Kolom ini wajib diisi' : null;
    if (text.length > 200) return 'Maksimal 200 karakter';
    final uri = Uri.tryParse(text);
    if (uri == null ||
        !uri.hasAuthority ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      return 'Masukkan URL http atau https yang valid';
    }
    return null;
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    final auth = context.read<AuthState>();
    setState(() => _saving = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final token = auth.token;
      if (token == null) return;
      await context.read<ApiClient>().createProject(
        Project(
          title: _title.text.trim(),
          description: _description.text.trim(),
          techStack: _category!,
          projectUrl: _projectUrl.text.trim(),
          projectImageUrl: _imageUrl.text.trim(),
        ),
        token: token,
      );
      if (!mounted) return;
      setState(() => _saving = false);
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Proyek berhasil ditambahkan'),
          content: Text('Proyek ${_title.text.trim()} telah disimpan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        var message = 'Sesi berakhir. Silakan masuk kembali.';
        try {
          await auth.logout();
        } catch (_) {
          message = 'Sesi berakhir. Gagal menghubungi server saat keluar. Silakan masuk kembali.';
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        await ensureLoggedIn(context);
      } else if (mounted) {
        final message = error.statusCode == 403
            ? 'Akun Anda tidak memiliki izin untuk menambahkan proyek.'
            : 'Proyek gagal disimpan. Periksa data dan coba lagi.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Proyek gagal disimpan. Periksa koneksi dan coba lagi.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Proyek')),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nama Proyek',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _requiredText(value, maxLength: 255),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Proyek',
                border: OutlineInputBorder(),
              ),
              validator: _requiredText,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Kategori Proyek',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'photography',
                  child: Text('Fotografi'),
                ),
                DropdownMenuItem(
                  value: 'web-development',
                  child: Text('Pengembangan Web'),
                ),
                DropdownMenuItem(
                  value: 'video-editing',
                  child: Text('Penyuntingan Video'),
                ),
                DropdownMenuItem(
                  value: 'motion-graphics',
                  child: Text('Grafis Gerak'),
                ),
                DropdownMenuItem(
                  value: 'graphics-design',
                  child: Text('Desain Grafis'),
                ),
                DropdownMenuItem(value: 'others', child: Text('Lainnya')),
              ],
              onChanged: (value) => setState(() => _category = value),
              validator: _requiredText,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _projectUrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Tautan Proyek',
                border: OutlineInputBorder(),
              ),
              validator: _url,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageUrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'URL Gambar (opsional)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _url(value, required: false),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Simpan Proyek'),
            ),
          ],
        ),
      ),
    );
  }
}
