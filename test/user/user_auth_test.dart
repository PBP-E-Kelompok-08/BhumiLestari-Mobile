import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:bhumilestari_mobile/config/api_endpoints.dart';
import 'package:bhumilestari_mobile/main.dart';
import 'package:bhumilestari_mobile/navigation/app_route_names.dart';
import 'package:bhumilestari_mobile/navigation/app_router.dart';
import 'package:bhumilestari_mobile/services/api_client.dart';
import 'package:bhumilestari_mobile/services/api_exception.dart';
import 'package:bhumilestari_mobile/services/auth_service.dart';
import 'package:bhumilestari_mobile/services/auth_token_store.dart';
import 'package:bhumilestari_mobile/user/user_session.dart';

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

  test('register mengirim field lengkap dan menyimpan token', () async {
    final store = _MemoryTokenStore();
    final auth = AuthService(ApiClient(
      baseUrl: baseUrl,
      tokenStore: store,
      client: MockClient((request) async {
        expect(request.url.path, ApiEndpoints.register);
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['role'], 'seller');
        expect(body['store_name'], 'Toko Hijau');
        expect(body['otp_code'], '123456');
        expect(body['confirm_password'], 'rahasia123');
        return http.Response(
          jsonEncode({
            'token': 'tok-123',
            'user': {'email': 'a@b.c', 'role': 'seller'},
          }),
          201,
        );
      }),
    ));

    final session = await auth.register(
      role: 'seller',
      fullName: 'Budi',
      storeName: 'Toko Hijau',
      email: 'a@b.c',
      otpCode: '123456',
      password: 'rahasia123',
      confirmPassword: 'rahasia123',
    );

    expect(session.token, 'tok-123');
    expect(session.user['role'], 'seller');
    expect(store.token, 'tok-123');
  });

  test('sendOtp mengembalikan pesan detail dari server', () async {
    final auth = AuthService(ApiClient(
      baseUrl: baseUrl,
      tokenStore: _MemoryTokenStore(),
      client: MockClient((request) async {
        expect(request.url.path, ApiEndpoints.sendOtp);
        expect(request.headers.containsKey('authorization'), isFalse);
        return http.Response(
            jsonEncode({'detail': 'Kode OTP telah dikirim.'}), 200);
      }),
    ));

    expect(await auth.sendOtp('a@b.c'), 'Kode OTP telah dikirim.');
  });

  test('register gagal melempar ApiException berisi error per field', () async {
    final auth = AuthService(ApiClient(
      baseUrl: baseUrl,
      tokenStore: _MemoryTokenStore(),
      client: MockClient((_) async => http.Response(
            jsonEncode({
              'otp_code': ['Kode OTP salah atau sudah kadaluarsa'],
            }),
            400,
          )),
    ));

    try {
      await auth.register(
        role: 'buyer',
        fullName: 'Budi',
        username: 'budi',
        email: 'a@b.c',
        otpCode: '000000',
        password: 'x',
        confirmPassword: 'x',
      );
      fail('Harusnya melempar ApiException');
    } on ApiException catch (e) {
      expect(apiErrorMessage(e), 'Kode OTP salah atau sudah kadaluarsa');
    }
  });

  test('apiErrorMessage mengutamakan detail', () {
    const e = ApiException(
      message: 'Permintaan API gagal.',
      statusCode: 400,
      data: {'detail': 'Email atau password salah!'},
    );
    expect(apiErrorMessage(e), 'Email atau password salah!');
  });

  test('router mendaftarkan halaman login dan register', () {
    expect(
      AppRouter.routes.keys,
      containsAll([AppRouteNames.login, AppRouteNames.register]),
    );
  });

  testWidgets('tab Pengguna saat belum login menampilkan Login & Sign Up', (
    WidgetTester tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Pengguna'));
    await tester.pumpAndSettle();

    expect(find.text('Kamu belum login'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Login'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Sign Up'), findsOneWidget);
  });
}
