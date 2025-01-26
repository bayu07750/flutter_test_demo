import 'package:flutter_test_demo/model/todo.dart';
import 'package:flutter_test_demo/network/utils/network_error.dart';
import 'package:fpdart/fpdart.dart';

abstract class NetworkDataSource {
  Future<Either<NetworkError, List<Todo>>> fetchTodos();
  Future<Either<NetworkError, Todo>> fetchTodoById(int id);
}
