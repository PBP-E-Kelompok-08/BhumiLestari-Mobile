import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:bhumilestari_mobile/services/api_client.dart';
import 'package:bhumilestari_mobile/services/api_exception.dart';
import 'package:bhumilestari_mobile/services/auth_service.dart';

/// Status login user (token disimpan oleh ApiClient di secure storage).
class UserSession {
  UserSession._();

  static const _rememberKey = 'bhumilestari_remember_me';
  static const _storage = FlutterSecureStorage();

  static final ApiClient apiClient = ApiClient();
  static final AuthService auth = AuthService(apiClient);

  /// Data user dari respons login/register/profile (cache di memori).
  static Map<String, dynamic>? user;

  static Future<bool> isLoggedIn() => apiClient.hasToken();

  /// Dipanggil setelah login/register berhasil.
  static Future<void> start(AuthSession session, {required bool remember}) async {
    user = session.user;
    await _storage.write(key: _rememberKey, value: remember.toString());
  }

  /// Dipanggil saat app dibuka: kalau login terakhir tanpa "Remember Me",
  /// token dihapus supaya user harus login lagi.
  static Future<void> clearIfNotRemembered() async {
    try {
      final remember = await _storage.read(key: _rememberKey);
      if (remember == 'false') {
        await apiClient.clearToken();
        await _storage.delete(key: _rememberKey);
      }
    } catch (_) {
      // Storage tidak tersedia: abaikan, app tetap jalan.
    }
  }

  /// User yang sedang login, atau null kalau belum login / token kadaluarsa.
  static Future<Map<String, dynamic>?> currentUser() async {
    if (user != null) return user;
    if (!await isLoggedIn()) return null;
    try {
      user = await auth.profile();
      return user;
    } on ApiException catch (e) {
      if (e.statusCode == 401) await apiClient.clearToken();
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      await auth.logout();
    } finally {
      user = null;
      await _storage.delete(key: _rememberKey);
    }
  }
}

/// Ambil pesan error yang enak dibaca dari respons DRF.
/// DRF bisa membalas {"detail": "..."} atau {"field": ["pesan", ...]}.
String apiErrorMessage(Object error) {
  if (error is ApiException) {
    final data = error.data;
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String) return detail;
      for (final value in data.values) {
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value is String) return value;
      }
    }
    return error.message;
  }
  return 'Terjadi kesalahan, coba lagi.';
}
