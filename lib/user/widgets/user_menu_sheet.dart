import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bhumilestari_mobile/navigation/app_route_names.dart';
import 'package:bhumilestari_mobile/user/user_session.dart';

const _danger = Color(0xFFB3261E);
const _primary = Color(0xFF4A6358);

/// Bottom sheet yang muncul saat tab "Pengguna" di-tap.
/// - Belum login: pilihan Login / Sign Up.
/// - Sudah login: info akun, Pengaturan Akun, Logout.
Future<void> showUserMenuSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFF3EFC3),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: UserSession.currentUser(),
          builder: (_, snapshot) {
            final children = <Widget>[
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ];

            if (snapshot.connectionState != ConnectionState.done) {
              children.add(const Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: _primary),
              ));
            } else if (snapshot.data == null) {
              children.addAll(_guestItems(context, sheetContext));
            } else {
              children.addAll(
                  _memberItems(context, sheetContext, snapshot.data!));
            }

            return Column(mainAxisSize: MainAxisSize.min, children: children);
          },
        ),
      ),
    ),
  );
}

List<Widget> _guestItems(BuildContext context, BuildContext sheetContext) => [
      ListTile(
        title: Text('Kamu belum login',
            style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
        subtitle: Text('Masuk untuk mengakses akunmu.',
            style: GoogleFonts.prompt(fontSize: 12)),
      ),
      const Divider(height: 1),
      ListTile(
        leading: const Icon(Icons.login, color: _primary),
        title: Text('Login', style: GoogleFonts.prompt()),
        onTap: () {
          Navigator.pop(sheetContext);
          Navigator.pushNamed(context, AppRouteNames.login);
        },
      ),
      ListTile(
        leading: const Icon(Icons.person_add_alt, color: _primary),
        title: Text('Sign Up', style: GoogleFonts.prompt()),
        onTap: () {
          Navigator.pop(sheetContext);
          Navigator.pushNamed(context, AppRouteNames.register);
        },
      ),
    ];

List<Widget> _memberItems(
  BuildContext context,
  BuildContext sheetContext,
  Map<String, dynamic> user,
) {
  final name = (user['current_name'] ?? user['full_name'] ?? '').toString();
  final email = (user['email'] ?? '').toString();
  return [
    ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFD9D9D9),
        child: Icon(Icons.person, color: Colors.grey),
      ),
      title: Text(name.isEmpty ? (user['username'] ?? 'Pengguna').toString() : name,
          style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
      subtitle: email.isEmpty
          ? null
          : Text(email, style: GoogleFonts.prompt(fontSize: 12)),
    ),
    const Divider(height: 1),
    ListTile(
      leading: const Icon(Icons.settings_outlined, color: _primary),
      title: Text('Pengaturan Akun', style: GoogleFonts.prompt()),
      onTap: () {
        Navigator.pop(sheetContext);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Pengaturan akun sedang dalam tahap pengembangan'),
          behavior: SnackBarBehavior.floating,
        ));
      },
    ),
    ListTile(
      leading: const Icon(Icons.logout, color: _danger),
      title: Text('Logout', style: GoogleFonts.prompt(color: _danger)),
      onTap: () {
        Navigator.pop(sheetContext);
        _logout(context);
      },
    ),
  ];
}

Future<void> _logout(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);
  try {
    await UserSession.logout();
  } catch (_) {
    // Token lokal tetap dihapus walau server gagal dihubungi.
  }
  // Dashboard tetap di bawah, jadi user bisa kembali tanpa login.
  navigator.pushNamedAndRemoveUntil(
      AppRouteNames.login, (route) => route.isFirst);
  messenger.showSnackBar(const SnackBar(
    content: Text('Berhasil logout. Sampai jumpa lagi!'),
    behavior: SnackBarBehavior.floating,
  ));
}
