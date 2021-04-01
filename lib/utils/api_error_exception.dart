class ApiErrorException implements Exception{

  final message;

  ApiErrorException(this.message);
  @override
  String toString() {
    return message;
  }
}