import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String code;
  final String message;

  const Failure({required this.code, required this.message});

  @override
  List<Object> get props => [code, message];
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(
      {String message = '', String code = 'UNEXPECTED_ERROR'})
      : super(message: message, code: code);
}
