class CustomHttpException implements Exception {
  final String message;
  final bool isError;
  final int? statusCode;

  CustomHttpException({
    required this.message,
    this.statusCode,
    this.isError = true,
  });

  @override
  String toString() {
    return message;
  }

  int? toInt() {
    return statusCode;
  }
}
