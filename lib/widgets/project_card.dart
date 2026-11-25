import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  Future<void> _open(BuildContext context) async {
    switch (item.name) {
      case 'Lihat Proyek':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProjectListScreen()),
        );
        break;
      case 'Tambah Proyek':
        if (!await ensureLoggedIn(context) || !context.mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProjectFormPage()),
        );
        break;
      case 'Tambah Edukasi':
        if (!await ensureLoggedIn(context) || !context.mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EducationFormPage()),
        );
        break;
      case 'Logout':
        if (context.read<AuthState>().isLoggedIn) {
          await logoutAndNotify(context);
        } else {
          await ensureLoggedIn(context);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.watch<AuthState>().isLoggedIn;
    final isAuthAction = item.name == 'Logout';
    final label = isAuthAction && !loggedIn ? 'Login' : item.name;
    final icon = isAuthAction && !loggedIn ? Icons.login : item.icon;
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _open(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 30),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
