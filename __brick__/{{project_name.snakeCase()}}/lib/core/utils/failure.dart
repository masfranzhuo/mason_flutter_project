abstract class Failure {
  final String code;
  final String message;

  const Failure({required this.code, required this.message});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    String message = '',
    String code = 'UNEXPECTED_ERROR',
  }) : super(message: message, code: code);
}

class InternetConnectionFailure extends Failure {
  const InternetConnectionFailure({
    String message = '',
    String code = 'INTERNET_CONNECTION_ERROR',
  }) : super(message: message, code: code);
}

class LocalStorageFailure extends Failure {
  const LocalStorageFailure({
    String message = '',
    String code = 'LOCAL_STORAGE_ERROR',
  }) : super(message: message, code: code);
}

class FormFieldFailure extends Failure {
  const FormFieldFailure({
    required String type,
    String message = '',
    String code = 'FORM_FIELD_ERROR',
  }) : super(message: message, code: code);
}
