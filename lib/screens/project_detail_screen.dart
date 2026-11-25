import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Proyek')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.projectImageUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  project.projectImageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160,
                    color: theme.colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: const Text('Gambar tidak dapat dimuat'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            Text(project.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 24),
            Text('Deskripsi', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SelectableText(project.description),
            const SizedBox(height: 24),
            Text('Teknologi', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SelectableText(project.techStack),
            const SizedBox(height: 24),
            Text('Tautan Proyek', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SelectableText(project.projectUrl),
          ],
        ),
      ),
    );
  }
}
