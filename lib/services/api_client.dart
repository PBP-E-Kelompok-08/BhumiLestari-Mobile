import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:bhumilestari_mobile/config/api_config.dart';
import 'package:bhumilestari_mobile/services/api_exception.dart';
import 'package:bhumilestari_mobile/services/auth_token_store.dart';

class ApiClient {
  ApiClient({
    http.Client? client,
    AuthTokenStore? tokenStore,
    this.baseUrl = ApiConfig.baseUrl,
    this.timeout = const Duration(seconds: 20),
  }) : _client = client ?? http.Client(),
       tokenStore = tokenStore ?? SecureAuthTokenStore();

  final http.Client _client;
  final AuthTokenStore tokenStore;
  final String baseUrl;
  final Duration timeout;

  Future<Object?> getJson(
    String path, {
    Map<String, String>? queryParameters,
    bool authenticated = true,
  }) => _send(
    'GET',
    path,
    queryParameters: queryParameters,
    authenticated: authenticated,
  );

  Future<Object?> postJson(
    String path, {
    Object? body,
    bool authenticated = true,
  }) => _send('POST', path, body: body, authenticated: authenticated);

  Future<Object?> patchJson(
    String path, {
    Object? body,
    bool authenticated = true,
  }) => _send('PATCH', path, body: body, authenticated: authenticated);

  Future<Object?> deleteJson(String path, {bool authenticated = true}) =>
      _send('DELETE', path, authenticated: authenticated);

  Future<void> saveToken(String token) => tokenStore.write(token);
  Future<void> clearToken() => tokenStore.delete();
  Future<bool> hasToken() async =>
      (await tokenStore.read())?.isNotEmpty ?? false;

  Future<Object?> _send(
    String method,
    String path, {
    Map<String, String>? queryParameters,
    Object? body,
    required bool authenticated,
  }) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (body != null) {
      headers['Content-Type'] = 'application/json';
    }
    if (authenticated) {
      final token = await tokenStore.read();
      if (token == null || token.isEmpty) {
        throw const ApiException(
          message: 'Sesi login tidak ditemukan. Silakan login kembali.',
          statusCode: 401,
        );
      }
      headers['Authorization'] = 'Token $token';
    }

    final uri = ApiConfig.buildUri(
      path,
      queryParameters: queryParameters,
      baseUrlOverride: baseUrl,
    );
    final encodedBody = body == null ? null : jsonEncode(body);

    try {
      final response = switch (method) {
        'GET' => _client.get(uri, headers: headers),
        'POST' => _client.post(uri, headers: headers, body: encodedBody),
        'PATCH' => _client.patch(uri, headers: headers, body: encodedBody),
        'DELETE' => _client.delete(uri, headers: headers),
        _ => throw ArgumentError.value(method, 'method'),
      };
      return _handleResponse(await response.timeout(timeout));
    } on TimeoutException {
      throw const ApiException(
        message: 'Permintaan ke server melewati batas waktu.',
      );
    } on http.ClientException catch (error) {
      throw ApiException(
        message: 'Tidak dapat terhubung ke server: ${error.message}',
      );
    }
  }

  Object? _handleResponse(http.Response response) {
    Object? data;
    if (response.body.isNotEmpty) {
      try {
        data = jsonDecode(response.body);
      } on FormatException {
        throw ApiException(
          message: 'Server mengembalikan respons yang tidak valid.',
          statusCode: response.statusCode,
          data: response.body,
        );
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    final detail = data is Map<String, dynamic> ? data['detail'] : null;
    throw ApiException(
      message: detail is String ? detail : 'Permintaan API gagal.',
      statusCode: response.statusCode,
      data: data,
    );
  }

  void close() => _client.close();
}
