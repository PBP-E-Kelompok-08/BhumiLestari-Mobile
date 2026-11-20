import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_header.dart';

class AuthColors {
  static const green = Color(0xFFADC178);
  static const greenText = Color(0xFF7C9A3E);
  static const link = Color(0xFF5B7A3A);
  static const cream = Color(0xFFF0EAD2);
  static const border = Color(0xFF3A3A3A);
  static const text = Color(0xFF1B1B1B);
}

TextStyle slab({
  double size = 15,
  FontWeight weight = FontWeight.normal,
  Color color = AuthColors.text,
}) =>
    GoogleFonts.robotoSlab(fontSize: size, fontWeight: weight, color: color);

const _pillShadow = [
  BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 2)),
];

/// Kerangka halaman auth: header ilustrasi + kartu putih bersudut di bawahnya.
class AuthLayout extends StatelessWidget {
  final bool compact;
  final Widget child;
  const AuthLayout({super.key, required this.child, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final headerHeight =
        compact ? authHeaderCompactHeight : authHeaderTallHeight;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                AuthHeader(compact: compact),
                Container(
                  margin: EdgeInsets.only(top: headerHeight - 28),
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: child,
                ),
                if (Navigator.canPop(context))
                  Positioned(
                    top: 8,
                    left: 4,
                    child: SafeArea(
                      child: IconButton(
                        tooltip: 'Kembali',
                        icon: const Icon(Icons.arrow_back,
                            color: AuthColors.text),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Input berbentuk pil dengan bayangan sesuai desain.
class PillTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  const PillTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AuthColors.border),
        boxShadow: _pillShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              style: slab(size: 14),
              cursorColor: AuthColors.link,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: slab(size: 14, color: const Color(0xFF3B3B3B)),
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              ),
            ),
          ),
          ?suffix,
        ],
      ),
    );
  }
}

/// Field password dengan tombol mata untuk show/hide.
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const PasswordField({
    super.key,
    required this.controller,
    required this.hint,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return PillTextField(
      controller: widget.controller,
      hint: widget.hint,
      obscureText: _hidden,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      suffix: IconButton(
        tooltip: _hidden ? 'Tampilkan password' : 'Sembunyikan password',
        icon: Icon(
          _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: const Color(0xFF3B3B3B),
          size: 22,
        ),
        onPressed: () => setState(() => _hidden = !_hidden),
      ),
    );
  }
}

/// Tombol hijau utama (Log In / Sign Up).
class PrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthColors.green,
          disabledBackgroundColor: AuthColors.green.withValues(alpha: 0.7),
          foregroundColor: AuthColors.text,
          elevation: 2,
          shadowColor: Colors.black54,
          side: const BorderSide(color: AuthColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AuthColors.text),
              )
            : Text(label, style: slab(size: 17, weight: FontWeight.w500)),
      ),
    );
  }
}

/// Toggle Penjual / Pembeli.
class RoleToggle extends StatelessWidget {
  final bool isSeller;
  final ValueChanged<bool> onChanged;

  const RoleToggle({super.key, required this.isSeller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget option(String label, bool seller) {
      final selected = isSeller == seller;
      return Expanded(
        child: Semantics(
          button: true,
          selected: selected,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(seller),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AuthColors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: selected ? Border.all(color: AuthColors.border) : null,
              ),
              child: Text(label, style: slab(size: 14)),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AuthColors.border),
        boxShadow: _pillShadow,
      ),
      child: Row(children: [option('Penjual', true), option('Pembeli', false)]),
    );
  }
}

/// Baris "Teks biasa + Link".
class AuthSwitchLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthSwitchLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: slab(size: 13)),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
            child: Text(linkText,
                style: slab(
                    size: 13, color: AuthColors.link, weight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }
}

void showAuthSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? const Color(0xFFB3261E) : const Color(0xFF4A6358),
      behavior: SnackBarBehavior.floating,
    ));
}
