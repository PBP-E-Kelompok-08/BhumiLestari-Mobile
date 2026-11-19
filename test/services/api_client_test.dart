import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:bhumilestari_mobile/config/api_endpoints.dart';
import 'package:bhumilestari_mobile/services/api_client.dart';
import 'package:bhumilestari_mobile/services/api_exception.dart';
import 'package:bhumilestari_mobile/services/auth_service.dart';
import 'package:bhumilestari_mobile/services/auth_token_store.dart';

class _MemoryTokenStore implements AuthTokenStore {
  String? token;

  @override
  Future<void> delete() async => token = null;

  @override
  Future<String?> read() async => token;

  @override
  Future<void> write(String token) async => this.token = token;
}

void main() {
  const baseUrl = 'https://api.example.test';

  test('public request tidak mengirim authorization header', () async {
    final store = _MemoryTokenStore();
    final client = ApiClient(
      baseUrl: baseUrl,
      tokenStore: store,
      client: MockClient((request) async {
        expect(request.url.path, ApiEndpoints.products);
        expect(request.headers.containsKey('authorization'), isFalse);
        return http.Response(jsonEncode({'count': 0}), 200);
      }),
    );

    final response = await client.getJson(
      ApiEndpoints.products,
      authenticated: false,
    );

    expect(response, {'count': 0});
  });

  test('authenticated request mengirim token DRF', () async {
    final store = _MemoryTokenStore()..token = 'secret-token';
    final client = ApiClient(
      baseUrl: baseUrl,
      tokenStore: store,
      client: MockClient((request) async {
        expect(request.headers['authorization'], 'Token secret-token');
        return http.Response(jsonEncode({'id': 1}), 200);
      }),
    );

    await client.getJson(ApiEndpoints.profile);
  });

  test('authenticated request tanpa token ditolak sebelum dikirim', () async {
    final client = ApiClient(
      baseUrl: baseUrl,
      tokenStore: _MemoryTokenStore(),
      client: MockClient((_) async => http.Response('{}', 200)),
    );

    await expectLater(
      client.getJson(ApiEndpoints.profile),
      throwsA(
        isA<ApiException>().having(
          (error) => error.statusCode,
          'statusCode',
          401,
        ),
      ),
    );
  });

  test('error response diterjemahkan menjadi ApiException', () async {
    final client = ApiClient(
      baseUrl: baseUrl,
      tokenStore: _MemoryTokenStore(),
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'detail': 'Email atau password salah!'}),
          400,
        ),
      ),
    );

    await expectLater(
      client.postJson(
        ApiEndpoints.login,
        authenticated: false,
        body: {'email': 'user@example.com', 'password': 'wrong'},
      ),
      throwsA(
        isA<ApiException>()
            .having((error) => error.statusCode, 'statusCode', 400)
            .having(
              (error) => error.message,
              'message',
              'Email atau password salah!',
            ),
      ),
    );
  });

  test('login menyimpan token dari backend', () async {
    final store = _MemoryTokenStore();
    final service = AuthService(
      ApiClient(
        baseUrl: baseUrl,
        tokenStore: store,
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'token': 'login-token',
              'user': {'email': 'buyer@example.com', 'role': 'buyer'},
            }),
            200,
          ),
        ),
      ),
    );

    final session = await service.login(
      email: 'buyer@example.com',
      password: 'password',
    );

    expect(session.token, 'login-token');
    expect(session.user['role'], 'buyer');
    expect(store.token, 'login-token');
  });
}
