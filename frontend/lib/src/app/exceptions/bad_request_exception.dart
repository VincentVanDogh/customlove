class BadRequestException implements Exception {
  final String message;

  BadRequestException(this.message);
}