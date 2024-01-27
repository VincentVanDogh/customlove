class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}

class WrongPasswordException implements Exception {
  final String message = "Wrong Password";

  WrongPasswordException();
}

class WrongEmailException implements Exception {
  final String message = "Wrong Email";

  WrongEmailException();
}

class NoNetworkException implements Exception {
  final String message = "No Network";

  NoNetworkException();
}

class InvalidRegistrationInputsException implements Exception {
  final String message = "Provided invalid inputs during the registration process";

  InvalidRegistrationInputsException();
}

class ServerNotRunningException implements Exception {
  final String message = "Make sure your backend is running";

  ServerNotRunningException();
}
