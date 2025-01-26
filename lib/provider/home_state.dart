// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter_test_demo/model/todo.dart';

class HomeState {
  final bool isLoading;
  final List<Todo> todos;
  final String? messageError;

  static final initial = HomeState(isLoading: false, todos: []);

  HomeState({
    required this.isLoading,
    required this.todos,
    this.messageError,
  });

  HomeState copyWith({
    bool? isLoading,
    List<Todo>? todos,
    String? messageError,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      todos: todos ?? this.todos,
      messageError: messageError ?? this.messageError,
    );
  }

  @override
  String toString() => 'HomeState(isLoading: $isLoading, todos: $todos, messageError: $messageError)';

  @override
  bool operator ==(covariant HomeState other) {
    if (identical(this, other)) return true;

    return other.isLoading == isLoading && listEquals(other.todos, todos) && other.messageError == messageError;
  }

  @override
  int get hashCode => isLoading.hashCode ^ todos.hashCode ^ messageError.hashCode;
}
