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
  final _tanggal = TextEditingController();
  DateTime? _tanggalMulai;

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
    if (nilai.trim().length > 100) {
      return 'Maksimal 100 karakter';
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
              Text('Tanggal mulai: ${_tanggal.text}'),
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
                controller: _tanggal,
                readOnly: true,
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
              ElevatedButton(onPressed: _simpan, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
