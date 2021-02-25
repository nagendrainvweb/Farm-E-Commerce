class ApiErrorException implements Exception {
  final messgae;

  ApiErrorException(this.messgae);

  @override
  String toString() {
    return messgae;
  }
}
