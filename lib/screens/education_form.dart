import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _kunciForm = GlobalKey<FormState>();
  final _institusi = TextEditingController();
  final _jurusan = TextEditingController();
  final _tanggal = TextEditingController();
  DateTime? _tanggalMulai;
  bool _isSaving = false;

  @override
  void dispose() {
    _institusi.dispose();
    _jurusan.dispose();
    _tanggal.dispose();
    super.dispose();
  }

  String? _cekTeks(String? nilai) {
    if (nilai == null || nilai.trim().isEmpty) {
      return 'Kolom ini wajib diisi';
    }
    if (nilai.trim().length > 255) {
      return 'Maksimal 255 karakter';
    }
    return null;
  }

  Future<void> _pilihTanggal() async {
    final sekarang = DateTime.now();
    final pilihan = await showDatePicker(
      context: context,
      initialDate: _tanggalMulai ?? sekarang,
      firstDate: DateTime(1900),
      lastDate: sekarang,
      initialDatePickerMode: DatePickerMode.year,
    );
    if (!mounted || pilihan == null) return;
    setState(() {
      _tanggalMulai = pilihan;
      _tanggal.text =
          '${pilihan.day.toString().padLeft(2, '0')}/'
          '${pilihan.month.toString().padLeft(2, '0')}/${pilihan.year}';
    });
  }

  Future<void> _simpan() async {
    if (_isSaving || !_kunciForm.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final loggedIn = await ensureLoggedIn(context);
      if (!mounted || !loggedIn) return;

      final token = context.read<AuthState>().token;
      if (token == null || token.isEmpty) {
        throw StateError('Sesi tidak tersedia');
      }

      final tanggal = _tanggalMulai!;
      final startedAt =
          '${tanggal.year.toString().padLeft(4, '0')}-'
          '${tanggal.month.toString().padLeft(2, '0')}-'
          '${tanggal.day.toString().padLeft(2, '0')}';
      final education = Education(
        institution: _institusi.text.trim(),
        major: _jurusan.text.trim(),
        startedAt: startedAt,
      );
      await context.read<ApiClient>().createEducation(education, token: token);
      if (!mounted) return;
      setState(() => _isSaving = false);

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Edukasi berhasil disimpan'),
          content: const Text('Data edukasi berhasil ditambahkan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      } else {
        _kunciForm.currentState!.reset();
        _institusi.clear();
        _jurusan.clear();
        _tanggal.clear();
        _tanggalMulai = null;
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      var message = 'Gagal menyimpan edukasi. Silakan coba lagi.';
      if (error.statusCode == 401) {
        message = 'Sesi tidak valid. Silakan masuk kembali.';
        try {
          await context.read<AuthState>().logout();
        } catch (_) {
          message =
              'Sesi tidak valid. Silakan masuk kembali. '
              'Gagal menghubungi server saat keluar.';
        }
        if (!mounted) return;
      } else if (error.statusCode == 403) {
        message = 'Akun Anda tidak memiliki izin untuk menambahkan edukasi.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      if (error.statusCode == 401) {
        await ensureLoggedIn(context);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan edukasi. Silakan coba lagi.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Edukasi'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _kunciForm,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _institusi,
                enabled: !_isSaving,
                decoration: const InputDecoration(labelText: 'Institusi'),
                textCapitalization: TextCapitalization.words,
                validator: _cekTeks,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jurusan,
                decoration: const InputDecoration(labelText: 'Jurusan'),
                enabled: !_isSaving,
                textCapitalization: TextCapitalization.words,
                validator: _cekTeks,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tanggal,
                readOnly: true,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Tanggal mulai',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _pilihTanggal,
                validator: (nilai) => nilai == null || nilai.isEmpty
                    ? 'Tanggal mulai wajib dipilih'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _simpan,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
