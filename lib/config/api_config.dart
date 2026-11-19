abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://sultan-noor-bhumilestari.pws.cs.ui.ac.id',
  );

  static Uri buildUri(
    String path, {
    Map<String, String>? queryParameters,
    String? baseUrlOverride,
  }) {
    final rawBaseUrl = baseUrlOverride ?? baseUrl;
    final normalizedBaseUrl = rawBaseUrl.endsWith('/')
        ? rawBaseUrl
        : '$rawBaseUrl/';
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    final uri = Uri.parse(normalizedBaseUrl).resolve(normalizedPath);
    return queryParameters == null
        ? uri
        : uri.replace(queryParameters: queryParameters);
  }
}
