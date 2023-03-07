import 'package:equatable/equatable.dart';
import 'package:triple_resources/triple_resources.dart';

class MockStore extends ReactorStore<MockFailure, MockState> {
  MockStore() : super(MockState());
}

class MockState extends Equatable {
  final String description;
  final int number;

  const MockState({this.description = '', this.number = 0});

  @override
  List<Object> get props => [description, number];

  MockState copyWith({
    String? description,
    int? number,
  }) {
    return MockState(
      description: description ?? this.description,
      number: number ?? this.number,
    );
  }

  @override
  String toString() => '$description,$number';
}

class MockFailure extends Equatable implements Exception {
  final String message;

  const MockFailure([this.message = 'Test Failure']);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}
