// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_test_demo/model/todo.dart';

class DetailState {
  final bool isLoading;
  final Todo? todo;
  final String? messageError;

  static final initial = DetailState(isLoading: false, todo: null, messageError: null);

  DetailState({required this.isLoading, required this.todo, required this.messageError});

  @override
  String toString() => 'DetailState(isLoading: $isLoading, todo: $todo, messageError: $messageError)';

  @override
  bool operator ==(covariant DetailState other) {
    if (identical(this, other)) return true;

    return other.isLoading == isLoading && other.todo == todo && other.messageError == messageError;
  }

  @override
  int get hashCode => isLoading.hashCode ^ todo.hashCode ^ messageError.hashCode;

  DetailState copyWith({
    bool? isLoading,
    Todo? todo,
    String? messageError,
  }) {
    return DetailState(
      isLoading: isLoading ?? this.isLoading,
      todo: todo ?? this.todo,
      messageError: messageError ?? this.messageError,
    );
  }
}
