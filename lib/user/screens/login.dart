import 'package:flutter/material.dart';

import 'package:bhumilestari_mobile/navigation/app_route_names.dart';
import 'package:bhumilestari_mobile/user/user_session.dart';
import 'package:bhumilestari_mobile/user/widgets/auth_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      showAuthSnack(context, 'Email dan password wajib diisi!', error: true);
      return;
    }

    setState(() => _loading = true);

    try {
      final session =
          await UserSession.auth.login(email: email, password: password);
      await UserSession.start(session, remember: _rememberMe);
      if (!mounted) return;

      final name = session.user['current_name'] ??
          session.user['full_name'] ??
          session.user['username'] ??
          '';
      Navigator.pushNamedAndRemoveUntil(
          context, AppRouteNames.home, (route) => false);
      showAuthSnack(context, 'Selamat datang, $name!');
    } catch (e) {
      if (!mounted) return;
      showAuthSnack(context, apiErrorMessage(e), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Column(
        children: [
          Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: 'Welcome ',
                  style: slab(
                      size: 26,
                      weight: FontWeight.bold,
                      color: AuthColors.greenText)),
              TextSpan(
                  text: 'Back', style: slab(size: 26, weight: FontWeight.bold)),
            ]),
          ),
          const SizedBox(height: 4),
          Text('Please enter your details', style: slab(size: 14)),
          const SizedBox(height: 22),
          PillTextField(
            controller: _emailController,
            hint: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          PasswordField(
            controller: _passwordController,
            hint: 'Password',
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _login(),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => setState(() => _rememberMe = !_rememberMe),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    onChanged: (v) => setState(() => _rememberMe = v ?? false),
                    activeColor: AuthColors.link,
                    side: const BorderSide(color: AuthColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Remember Me', style: slab(size: 14)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(label: 'Log In', loading: _loading, onPressed: _login),
          const SizedBox(height: 16),
          AuthSwitchLink(
            text: "Don't have an account? ",
            linkText: 'Sign Up',
            onTap: () => Navigator.pushNamed(context, AppRouteNames.register),
          ),
        ],
      ),
    );
  }
}
