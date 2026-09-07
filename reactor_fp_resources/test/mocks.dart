import 'package:equatable/equatable.dart';

class const MockFailure([final String message = 'Test Failure'])
    extends Equatable
    implements Exception {
  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}
