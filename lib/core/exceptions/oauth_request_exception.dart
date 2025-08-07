/// This exception is thrown when an OAuth request fails, typically due to network issues or server errors.
class OAuthRequestException implements Exception {
  /// Constructs an [OAuthRequestException] with a message and an optional status code.
  OAuthRequestException(this.message, {this.statusCode});

  /// Exception thrown when an OAuth request fails.
  final String message;

  /// Optional status code associated with the request failure.
  final int? statusCode;

  @override
  String toString() =>
      'OAuthRequestException: $message${statusCode != null ? ' (Status Code: $statusCode)' : ''}';
}
