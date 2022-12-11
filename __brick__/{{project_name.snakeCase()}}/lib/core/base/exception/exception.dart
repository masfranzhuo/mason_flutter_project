abstract class BaseException implements Exception {
  final String code;
  final String message;

  const BaseException({required this.code, this.message = ''});
}

class AppException extends BaseException {
  const AppException({
    String code = 'UNEXPECTED_ERROR',
    super.message,
  }) : super(code: code);
}

class InternetConnectionException extends AppException {
  const InternetConnectionException({
    String code = 'INTERNET_CONNECTION_ERROR',
    super.message,
  }) : super(code: code);
}

class NetworkException extends AppException {
  const NetworkException({
    String code = 'NETWORK_ERROR',
    super.message,
  }) : super(code: code);
}

class LocalException extends AppException {
  const LocalException({
    String code = 'LOCAL_ERROR',
    super.message,
  }) : super(code: code);
}

class FormFieldException extends AppException {
  const FormFieldException({
    required String type,
    String code = 'FORM_FIELD_ERROR',
    super.message,
  }) : super(code: code);
}
