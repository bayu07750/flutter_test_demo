import 'package:flutter_test_demo/model/todo.dart';
import 'package:flutter_test_demo/network/network_data_source.dart';
import 'package:flutter_test_demo/network/utils/network_error.dart';
import 'package:fpdart/src/either.dart';

class FakeNetworkDataSource implements NetworkDataSource {
  static final Todo _todo1 = Todo(
    userId: 1,
    id: 1,
    title: 'Learning Flutter',
    completed: false,
  );

  var noInternetError = false;
  var serverError = false;
  var unkownError = false;

  static final List<Todo> todos = [FakeNetworkDataSource._todo1];

  @override
  Future<Either<NetworkError, Todo>> fetchTodoById(int id) async {
    if (noInternetError) {
      return Left(NetworkError.noInternet);
    }

    if (serverError) {
      return Left(NetworkError.server);
    }

    if (unkownError) {
      return Left(NetworkError.unknown);
    }

    return Right(_todo1);
  }

  @override
  Future<Either<NetworkError, List<Todo>>> fetchTodos() async {
    if (noInternetError) {
      return Left(NetworkError.noInternet);
    }

    if (serverError) {
      return Left(NetworkError.server);
    }

    if (unkownError) {
      return Left(NetworkError.unknown);
    }

    return Future.value(Right(todos));
  }
}
