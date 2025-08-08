/// This exception is thrown when an error occurs during the OAuth authentication process.
class OAuthException implements Exception {
  /// Creates an instance of [OAuthException].
  OAuthException({
    this.message,
    this.errorType = AuthenticationErrorType.serverError,
  });

  /// The error message describing the issue that occurred during authentication.
  final String? message;

  /// The type of error that occurred during the authentication process.
  final AuthenticationErrorType errorType;

  @override
  String toString() =>
      "OAuthException: ${message ?? 'An error occurred during OAuth authentication.'} (${errorType.toString().split('.').last})";
}

/// Enum representing different types of authentication errors.
enum AuthenticationErrorType {
  /// User cancelled the authentication process.
  userCancelled,

  /// Did not receive a token from the server.
  noTokenReceived,

  /// Did not receive a user code from the server.
  noUserCodeReceived,

  /// An error occurred on the server.
  serverError,
}
