import 'dart:async';

import 'package:flutter/material.dart';

import 'package:bhumilestari_mobile/navigation/app_route_names.dart';
import 'package:bhumilestari_mobile/user/user_session.dart';
import 'package:bhumilestari_mobile/user/widgets/auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const _otpCooldownSeconds = 60;

  final _nameController = TextEditingController();
  final _storeController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isSeller = false;
  bool _loading = false;
  bool _sendingOtp = false;
  int _otpCooldown = 0;
  Timer? _otpTimer;

  @override
  void dispose() {
    _otpTimer?.cancel();
    for (final c in [
      _nameController,
      _storeController,
      _usernameController,
      _emailController,
      _otpController,
      _passwordController,
      _confirmController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _startOtpCooldown() {
    _otpTimer?.cancel();
    setState(() => _otpCooldown = _otpCooldownSeconds);
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || _otpCooldown <= 1) {
        t.cancel();
        if (mounted) setState(() => _otpCooldown = 0);
        return;
      }
      setState(() => _otpCooldown--);
    });
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      showAuthSnack(context, 'Isi email dulu sebelum kirim OTP.', error: true);
      return;
    }

    setState(() => _sendingOtp = true);
    try {
      final message = await UserSession.auth.sendOtp(email);
      if (!mounted) return;
      showAuthSnack(context, message);
      _startOtpCooldown();
    } catch (e) {
      if (!mounted) return;
      showAuthSnack(context, apiErrorMessage(e), error: true);
    } finally {
      if (mounted) setState(() => _sendingOtp = false);
    }
  }

  String? _validate() {
    if (_nameController.text.trim().isEmpty) return 'Nama wajib diisi!';
    if (_isSeller && _storeController.text.trim().isEmpty) {
      return 'Nama toko wajib diisi!';
    }
    if (!_isSeller && _usernameController.text.trim().isEmpty) {
      return 'Username wajib diisi!';
    }
    if (_emailController.text.trim().isEmpty) return 'Email wajib diisi!';
    if (_otpController.text.trim().isEmpty) return 'Kode OTP wajib diisi!';
    if (_passwordController.text.isEmpty) return 'Password wajib diisi!';
    if (_passwordController.text != _confirmController.text) {
      return 'Konfirmasi password tidak cocok!';
    }
    return null;
  }

  Future<void> _register() async {
    final error = _validate();
    if (error != null) {
      showAuthSnack(context, error, error: true);
      return;
    }

    setState(() => _loading = true);
    try {
      final session = await UserSession.auth.register(
        role: _isSeller ? 'seller' : 'buyer',
        fullName: _nameController.text.trim(),
        storeName: _isSeller ? _storeController.text.trim() : '',
        username: _isSeller ? '' : _usernameController.text.trim(),
        email: _emailController.text.trim(),
        otpCode: _otpController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmController.text,
      );
      await UserSession.start(session, remember: true);
      if (!mounted) return;

      // Server langsung login-kan user setelah daftar -> masuk dashboard.
      Navigator.pushNamedAndRemoveUntil(
          context, AppRouteNames.home, (route) => false);
      showAuthSnack(
          context, 'Pendaftaran berhasil! Selamat datang di BhumiLestari.');
    } catch (e) {
      if (!mounted) return;
      showAuthSnack(context, apiErrorMessage(e), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goToLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRouteNames.login);
    }
  }

  Widget _otpButton() {
    final disabled = _sendingOtp || _otpCooldown > 0;
    final label = _sendingOtp
        ? 'Mengirim...'
        : _otpCooldown > 0
            ? 'Kirim ulang (${_otpCooldown}s)'
            : 'Kirim OTP';
    return Material(
      color: disabled ? const Color(0xFFE4DCB8) : AuthColors.cream,
      shape: const StadiumBorder(side: BorderSide(color: AuthColors.border)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: disabled ? null : _sendOtp,
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          child: Text(label, style: slab(size: 13, weight: FontWeight.w500)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 13);
    return AuthLayout(
      compact: true,
      child: Column(
        children: [
          const SizedBox(height: 8),
          RoleToggle(
            isSeller: _isSeller,
            onChanged: (v) => setState(() => _isSeller = v),
          ),
          const SizedBox(height: 18),
          PillTextField(controller: _nameController, hint: 'Nama'),
          gap,
          if (_isSeller)
            PillTextField(controller: _storeController, hint: 'Nama Toko')
          else
            PillTextField(controller: _usernameController, hint: 'Username'),
          gap,
          PillTextField(
            controller: _emailController,
            hint: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          gap,
          PillTextField(
            controller: _otpController,
            hint: 'OTP',
            keyboardType: TextInputType.number,
            suffix: _otpButton(),
          ),
          gap,
          PasswordField(controller: _passwordController, hint: 'Password'),
          gap,
          PasswordField(
            controller: _confirmController,
            hint: 'Confirm Password',
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _register(),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
              label: 'Sign Up', loading: _loading, onPressed: _register),
          const SizedBox(height: 16),
          AuthSwitchLink(
            text: 'Already have an account? ',
            linkText: 'Login',
            onTap: _goToLogin,
          ),
        ],
      ),
    );
  }
}
