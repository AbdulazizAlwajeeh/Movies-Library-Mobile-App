enum LoginStatus {
  success,
  invalidCredentials,
  unauthorized,
  serverError,
  networkError,
}

class LoginResult {
  final LoginStatus status;

  const LoginResult({required this.status});
}
