/// An exception that is thrown when an authentication error occurs.
class AuthenticationException implements Exception {
  /// Creates an instance of [AuthenticationException] with the provided [message].
  AuthenticationException(
    this.message, {
    this.type = AuthenticationErrorType.authenticationFailed,
  });

  /// The error message associated with the exception.
  final String? message;

  /// The type of authentication error that occurred.
  ///
  final AuthenticationErrorType type;

  @override
  String toString() => "AuthenticationException: $message (Type: $type)";
}

// TODO(everyone): Add more specific error types if needed
/// An enum representing the different types of authentication errors.
enum AuthenticationErrorType {
  /// Indicates that the user cancelled the authentication process.
  userCancelled,

  /// Indicates that the authentication process failed due to an error.
  authenticationFailed,

  /// Indicates that the authentication process was successful.
  authenticationSuccessful,
}
