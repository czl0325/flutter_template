class SkipException implements Exception {
  int? code;
  String? message;
  SkipException({this.code, this.message});

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "$message";
  }
}

class MsgException implements Exception {
  int code;
  String message;
  MsgException(this.code, this.message);

  @override
  String toString() {
    return message;
  }
}
