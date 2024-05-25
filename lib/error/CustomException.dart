class CustomException implements Exception {
  final ErrorDomain domain;
  final ErrorType type;
  final String msg;

  CustomException({required this.domain, required this.type, required this.msg});
}

enum ErrorDomain {
  ACCOUNT,
  MATE,
  MATE_APPLY,
}

enum ErrorType {
  LIMIT_OVER,
  INVALID_INPUT,
}