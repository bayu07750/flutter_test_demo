import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_demo/network/imp/http_network_data_source.dart';
import 'package:flutter_test_demo/network/network_config.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

final class MockHttpClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late HttpNetworkDataSource dataSource;

  final http.Response successResponse = http.Response('''
[
  {
    "userId": 1,
    "id": 1,
    "title": "delectus aut autem",
    "completed": false
  }
]
''', 200);
  final int todoId = 1;
  final http.Response successTodoDetailResponse = http.Response('''
{
    "userId": 1,
    "id": $todoId,
    "title": "delectus aut autem",
    "completed": false
}
''', 200);
  final http.Response serverErrorResponse = http.Response('', 500);

  setUp(
    () {
      client = MockHttpClient();
      dataSource = HttpNetworkDataSource(client: client);
    },
  );

  group(
    'todos',
    () {
      // positive test case
      test(
        'should return Right todos when request was succefully',
        () async {
          // Arrange
          when(() => client.get(Uri.parse(NetworkConfig.ROUTE_TODOS))).thenAnswer(
            (invocation) async {
              return successResponse;
            },
          );

          // Act
          final result = await dataSource.fetchTodos();

          // Assert
          expect(result.isRight(), true);
        },
      );
    },
  );

  group(
    'todo detail',
    () {
      test(
        'should return Right todo when request was succesfully',
        () async {
          // Arrange
          when(() => client.get(Uri.parse("${NetworkConfig.ROUTE_TODOS}/$todoId"))).thenAnswer(
            (invocation) async {
              return successTodoDetailResponse;
            },
          );

          // Act
          final result = await dataSource.fetchTodoById(todoId);

          // Assert
          expect(result.isRight(), true);
        },
      );
    },
  );
}
