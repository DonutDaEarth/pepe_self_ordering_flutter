import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pepe_self_ordering_flutter/src/state/app_state.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/app_header.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/labeled_text_field.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  String? error;
  bool loading = false;
  Future<void> submit() async {
    if (email.text.trim().isEmpty || pass.text.trim().isEmpty) {
      setState(() => error = 'Email and password are required');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    final result = await context.read<AppState>().authRepo.login(
      email.text.trim(),
      pass.text,
    );
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
      body: Column(
        children: [
          AppHeader(showSearch: false, onBack: () => context.pop()),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  children: [
                    const SizedBox(height: 56),
                    const Text(
                      'Login to an existing account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "CarterOne",
                        fontSize: 26,
                        color: AppColors.orangePrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 56),
                    LabeledTextField(label: 'E-mail', controller: email),
                    const SizedBox(height: 24),
                    LabeledTextField(
                      label: 'Password',
                      controller: pass,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    if (error != null)
                      Text(error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 64),
                    PrimaryButton(
                      text: loading ? 'Loading...' : 'Login',
                      onPressed: loading ? null : submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
