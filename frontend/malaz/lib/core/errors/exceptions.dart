// core/errors/exceptions.dart
/// Represents errors that occur during data fetching or processing.
class ServerException implements Exception {
  final String? message;
  ServerException([this.message]);
  @override
  String toString() => 'ServerException: ${message ?? ''}';
}

/// Represents errors that occur when there is no internet connection.
class NetworkException implements Exception {}

/// Represents errors that occur when there is no cached data available.
class CacheException implements Exception {
  final String? message;
  CacheException([this.message]);
  @override
  String toString() => 'CacheException: ${message ?? ''}';
}

/// Can be used for other general exceptions.
class GeneralException implements Exception {}

/// Represents errors that occur when login credentials are wrong
class InvalidCredentialsException implements Exception {
  final String? message;
  InvalidCredentialsException([this.message]);
  @override
  String toString() => 'InvalidCredentialsException: ${message ?? ''}';
}