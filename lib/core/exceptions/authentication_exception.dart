/// An exception that is thrown when an authentication error occurs.
class AuthenticationException implements Exception {
  /// Creates an instance of [AuthenticationException] with the provided [message].
  AuthenticationException(this.message);

  /// The error message associated with the exception.
  final String message;

  @override
  String toString() => "AuthenticationException: $message";
}
