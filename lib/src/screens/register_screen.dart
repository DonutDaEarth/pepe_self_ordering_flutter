import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pepe_self_ordering_flutter/src/state/app_state.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirm = TextEditingController();
  String? error;
  bool loading = false;

  Future<void> submit() async {
    setState(() => error = null);
    if (name.text.trim().isEmpty)
      return setState(() => error = 'Name is required');
    if (email.text.trim().isEmpty)
      return setState(() => error = 'Email is required');
    if (pass.text.length < 8)
      return setState(() => error = 'Password must be at least 8 characters');
    if (pass.text != confirm.text)
      return setState(() => error = 'Passwords do not match');
    setState(() => loading = true);
    final app = context.read<AppState>();
    final result = await app.authRepo.register(email.text.trim(), pass.text);
    setState(() => loading = false);
    if (!mounted) return;
    if (result == null) {
      context.go('/qr_scanner');
    } else {
      setState(() => error = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24, top: 54),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 246,
                  width: double.infinity,
                  // color: AppColors.,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/pepe_app_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Column(
                    children: [
                      const SizedBox(height: 200),
                      LabeledTextField(label: 'Name', controller: name),
                      const SizedBox(height: 24),
                      LabeledTextField(label: 'E-mail', controller: email),
                      const SizedBox(height: 24),
                      LabeledTextField(
                        label: 'Password',
                        controller: pass,
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      LabeledTextField(
                        label: 'Confirmed Password',
                        controller: confirm,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      if (error != null)
                        Text(error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 40),
                      TextButton(
                        onPressed: () => context.push('/login'),
                        child: const Text(
                          'Already have an account?',
                          style: TextStyle(color: AppColors.orangePrimary),
                        ),
                      ),
                      const SizedBox(height: 10),
                      PrimaryButton(
                        text: loading ? 'Loading...' : 'Register',
                        onPressed: loading ? null : submit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
