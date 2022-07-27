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
