import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/education.dart';

class EducationDetailScreen extends StatelessWidget {
  const EducationDetailScreen({super.key, required this.education});

  final Education education;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Edukasi'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  education.institution,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text('Jurusan', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(education.major),
                const SizedBox(height: 16),
                Text(
                  'Tanggal mulai',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(education.startedAt),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
