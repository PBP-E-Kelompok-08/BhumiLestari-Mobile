import 'package:bhumilestari_mobile/config/api_endpoints.dart';
import 'package:bhumilestari_mobile/services/api_client.dart';
import 'package:bhumilestari_mobile/services/api_exception.dart';

class AuthSession {
  const AuthSession({required this.token, required this.user});

  final String token;
  final Map<String, dynamic> user;
}

class AuthService {
  const AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.postJson(
      ApiEndpoints.login,
      authenticated: false,
      body: {'email': email, 'password': password},
    );
    if (response is! Map<String, dynamic> || response['token'] is! String) {
      throw const ApiException(
        message: 'Respons login dari server tidak lengkap.',
      );
    }

    final token = response['token'] as String;
    final rawUser = response['user'];
    final user = rawUser is Map<String, dynamic>
        ? rawUser
        : <String, dynamic>{};
    await _apiClient.saveToken(token);
    return AuthSession(token: token, user: user);
  }

  /// Mengirim OTP registrasi ke [email]. Mengembalikan pesan dari server.
  Future<String> sendOtp(String email) async {
    final response = await _apiClient.postJson(
      ApiEndpoints.sendOtp,
      authenticated: false,
      body: {'email': email},
    );
    final detail = response is Map<String, dynamic> ? response['detail'] : null;
    return detail is String ? detail : 'Kode OTP telah dikirim ke email kamu.';
  }

  /// Registrasi buyer/seller. Server langsung mengembalikan token (auto-login).
  Future<AuthSession> register({
    required String role,
    required String fullName,
    required String email,
    required String otpCode,
    required String password,
    required String confirmPassword,
    String username = '',
    String storeName = '',
  }) async {
    final response = await _apiClient.postJson(
      ApiEndpoints.register,
      authenticated: false,
      body: {
        'role': role,
        'full_name': fullName,
        'username': username,
        'store_name': storeName,
        'email': email,
        'otp_code': otpCode,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );
    if (response is! Map<String, dynamic> || response['token'] is! String) {
      throw const ApiException(
        message: 'Respons pendaftaran dari server tidak lengkap.',
      );
    }

    final token = response['token'] as String;
    final rawUser = response['user'];
    final user = rawUser is Map<String, dynamic>
        ? rawUser
        : <String, dynamic>{};
    await _apiClient.saveToken(token);
    return AuthSession(token: token, user: user);
  }

  /// Profil user yang sedang login.
  Future<Map<String, dynamic>> profile() async {
    final response = await _apiClient.getJson(ApiEndpoints.profile);
    return response is Map<String, dynamic> ? response : <String, dynamic>{};
  }

  Future<void> logout() async {
    try {
      await _apiClient.postJson(ApiEndpoints.logout);
    } finally {
      await _apiClient.clearToken();
    }
  }
}
