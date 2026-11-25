import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationListScreen extends StatefulWidget {
  const EducationListScreen({super.key});

  @override
  State<EducationListScreen> createState() => _EducationListScreenState();
}

class _EducationListScreenState extends State<EducationListScreen> {
  late Future<List<Education>> _educations;
  bool _openingForm = false;

  @override
  void initState() {
    super.initState();
    _educations = context.read<ApiClient>().getEducations();
  }

  Future<void> _refresh() async {
    final request = context.read<ApiClient>().getEducations();
    setState(() => _educations = request);
    try {
      await request;
    } catch (_) {
      return;
    }
  }

  Future<void> _addEducation() async {
    if (_openingForm) return;
    setState(() => _openingForm = true);
    try {
      final loggedIn = await ensureLoggedIn(context);
      if (!mounted || !loggedIn) return;
      final created = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const EducationFormPage()),
      );
      if (mounted && created == true) await _refresh();
    } finally {
      if (mounted) setState(() => _openingForm = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Edukasi'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openingForm ? null : _addEducation,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Edukasi'),
      ),
      body: FutureBuilder<List<Education>>(
        future: _educations,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 80),
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Gagal memuat edukasi. Periksa koneksi dan coba lagi.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _refresh,
                      child: const Text('Coba lagi'),
                    ),
                  ),
                ],
              ),
            );
          }
          final educations = snapshot.data!;
          if (educations.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: const [
                  SizedBox(height: 80),
                  Icon(Icons.school_outlined, size: 48),
                  SizedBox(height: 16),
                  Text('Belum ada data edukasi.', textAlign: TextAlign.center),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: educations.length,
              itemBuilder: (context, index) {
                final education = educations[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.school_outlined),
                    title: Text(education.institution),
                    subtitle: Text(
                      '${education.major}\n${education.startedAt}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EducationDetailScreen(education: education),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
