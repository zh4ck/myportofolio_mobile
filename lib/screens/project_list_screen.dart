import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late Future<List<Project>> _projects;

  @override
  void initState() {
    super.initState();
    _projects = context.read<ApiClient>().getProjects();
  }

  Future<void> _refresh() async {
    final request = context.read<ApiClient>().getProjects();
    setState(() => _projects = request);
    try {
      await request;
    } catch (_) {}
  }

  Future<void> _addProject() async {
    if (!await ensureLoggedIn(context) || !mounted) return;
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ProjectFormPage()),
    );
    if (created == true && mounted) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Proyek')),
      drawer: const LeftDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProject,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Proyek'),
      ),
      body: FutureBuilder<List<Project>>(
        future: _projects,
        builder: (context, snapshot) {
          Widget content;
          if (snapshot.connectionState != ConnectionState.done) {
            content = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            content = Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Daftar proyek belum dapat dimuat. Periksa koneksi dan coba lagi.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _refresh,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            content = const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada proyek. Tambahkan proyek pertama atau tarik untuk memuat ulang.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            final projects = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: projects.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Card(
                    child: ListTile(
                      title: Text(project.title),
                      subtitle: Text(
                        project.techStack,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailScreen(project: project),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: LayoutBuilder(
              builder: (context, constraints) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: constraints.maxHeight, child: content),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
