import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  Future<void> _openProtected(NavigatorState navigator, Widget page) async {
    if (!await ensureLoggedIn(navigator.context) || !navigator.mounted) return;
    await navigator.push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.watch<AuthState>().isLoggedIn;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explore personal projects and experiences!',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.pushReplacement(
                MaterialPageRoute(builder: (_) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('View Projects'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.push(
                MaterialPageRoute(builder: (_) => const ProjectListScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              _openProtected(navigator, const ProjectFormPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('View Education'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.push(
                MaterialPageRoute(builder: (_) => const EducationListScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Education'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              _openProtected(navigator, const EducationFormPage());
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(loggedIn ? Icons.logout : Icons.login),
            title: Text(loggedIn ? 'Logout' : 'Login'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              if (loggedIn) {
                logoutAndNotify(navigator.context);
              } else {
                ensureLoggedIn(navigator.context);
              }
            },
          ),
        ],
      ),
    );
  }
}
