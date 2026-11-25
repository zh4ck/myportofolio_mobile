import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;
  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );
  return context.mounted &&
      loggedIn == true &&
      context.read<AuthState>().isLoggedIn;
}

Future<void> logoutAndNotify(BuildContext context) async {
  final auth = context.read<AuthState>();
  final messenger = ScaffoldMessenger.of(context);
  try {
    await auth.logout();
    if (messenger.mounted) {
      messenger.showSnackBar(const SnackBar(content: Text('Berhasil keluar.')));
    }
  } catch (_) {
    if (messenger.mounted) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Sesi di perangkat telah dihapus, tetapi server tidak dapat dihubungi.',
          ),
        ),
      );
    }
  }
}
