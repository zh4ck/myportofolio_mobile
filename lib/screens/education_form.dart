import 'package:material_ui/material_ui.dart';
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
  final _tahun = TextEditingController();

  @override
  void dispose() {
    _institusi.dispose();
    _jurusan.dispose();
    _tahun.dispose();
    super.dispose();
  }

  String? _cekTeks(String? nilai) {
    if (nilai == null || nilai.trim().isEmpty) {
      return 'Kolom ini wajib diisi';
    }
    if (nilai.trim().length > 100) {
      return 'Maksimal 100 karakter';
    }
    return null;
  }

  String? _cekTahun(String? nilai) {
    final teks = nilai?.trim() ?? '';
    if (teks.isEmpty) return 'Tahun wajib diisi';
    final tahun = int.tryParse(teks);
    if (!RegExp(r'^\d{4}$').hasMatch(teks) ||
        tahun == null ||
        tahun < 1900 ||
        tahun > DateTime.now().year) {
      return 'Masukkan tahun antara 1900 dan tahun sekarang';
    }
    return null;
  }

  void _simpan() {
    if (!_kunciForm.currentState!.validate()) return;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ringkasan Edukasi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Institusi: ${_institusi.text.trim()}'),
              Text('Jurusan: ${_jurusan.text.trim()}'),
              Text('Tahun mulai: ${_tahun.text.trim()}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
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
                decoration: const InputDecoration(labelText: 'Institusi'),
                textCapitalization: TextCapitalization.words,
                validator: _cekTeks,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jurusan,
                decoration: const InputDecoration(labelText: 'Jurusan'),
                textCapitalization: TextCapitalization.words,
                validator: _cekTeks,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tahun,
                decoration: const InputDecoration(labelText: 'Tahun mulai'),
                keyboardType: TextInputType.number,
                validator: _cekTahun,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _simpan, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
