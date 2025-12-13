/// Represents errors that occur during data fetching or processing.
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ServerException({
    required this.message,
    this.statusCode,
    this.errors,
  });
}

/// Represents errors that occur when there is no internet connection.
class NetworkException implements Exception {}

/// Represents errors that occur when there is no cached data available.
class CacheException implements Exception {}

/// Can be used for other general exceptions.
class GeneralException implements Exception {}

class UnauthenticatedException implements Exception {
  final String message;
  UnauthenticatedException(
      {this.message = 'Session expired, please login again'}); /// TODO: translate
}
