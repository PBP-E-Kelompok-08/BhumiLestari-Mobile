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

  Future<void> logout() async {
    try {
      await _apiClient.postJson(ApiEndpoints.logout);
    } finally {
      await _apiClient.clearToken();
    }
  }
}
