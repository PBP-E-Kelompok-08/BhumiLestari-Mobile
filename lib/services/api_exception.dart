class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode, this.data});

  final String message;
  final int? statusCode;
  final Object? data;

  @override
  String toString() => statusCode == null
      ? 'ApiException: $message'
      : 'ApiException ($statusCode): $message';
}
