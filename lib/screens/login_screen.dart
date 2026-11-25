import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_loading || !_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AuthState>().login(
        _username.text.trim(),
        _password.text,
      );
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;
      final message = error.statusCode == 400 || error.statusCode == 401
          ? 'Nama pengguna atau kata sandi salah. Silakan coba lagi.'
          : 'Tidak dapat masuk saat ini. Silakan coba lagi.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tidak dapat terhubung ke server. Periksa koneksi dan coba lagi.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Masuk')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Masuk ke MyPortfolio',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('Masuk untuk menambahkan proyek dan pendidikan.'),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _username,
                    autofillHints: const [AutofillHints.username],
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nama pengguna',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Nama pengguna wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _password,
                    autofillHints: const [AutofillHints.password],
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _login(),
                    decoration: InputDecoration(
                      labelText: 'Kata sandi',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Tampilkan kata sandi'
                            : 'Sembunyikan kata sandi',
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Kata sandi wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Masuk'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
