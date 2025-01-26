import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test_demo/model/todo.dart';
import 'package:flutter_test_demo/network/network_config.dart';
import 'package:flutter_test_demo/network/network_data_source.dart';
import 'package:flutter_test_demo/network/utils/network_error.dart';
import 'package:fpdart/src/either.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

final _log = Logger('HttpNetworkDataSource');

class HttpNetworkDataSource implements NetworkDataSource {
  final http.Client client;

  HttpNetworkDataSource({required this.client});

  @override
  Future<Either<NetworkError, List<Todo>>> fetchTodos() async {
    try {
      final uri = Uri.parse(NetworkConfig.ROUTE_TODOS);
      final response = await client.get(uri);
      final responseJson = response.body;
      _log.info(responseJson);
      final List<dynamic> responseJsonList = jsonDecode(responseJson);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        _log.info(responseJson);
        final todos = responseJsonList.map((e) => Todo.fromMap(e)).toList();
        return Right(todos);
      } else {
        _log.warning(responseJson);
        if (response.statusCode == 401) {
          return Left(NetworkError.unauthorized);
        } else if (response.statusCode == 403) {
          return Left(NetworkError.forbidden);
        } else if (response.statusCode == 404) {
          return Left(NetworkError.notFound);
        } else {
          return Left(NetworkError.unknown);
        }
      }
    } on SocketException catch (e) {
      _log.severe(e);
      return Left(NetworkError.noInternet);
    } on TimeoutException catch (e) {
      _log.severe(e);
      return Left(NetworkError.requestTimeout);
    } on FormatException catch (e) {
      _log.severe(e);
      return Left(NetworkError.serialization);
    } on HttpException catch (e) {
      _log.severe(e);
      return Left(NetworkError.server);
    } on http.ClientException catch (e) {
      _log.severe(e);
      return Left(NetworkError.clientError);
    } on Exception catch (e) {
      _log.severe(e);
      return Left(NetworkError.unknown);
    }
  }

  @override
  Future<Either<NetworkError, Todo>> fetchTodoById(int id) async {
    final uri = Uri.parse("${NetworkConfig.ROUTE_TODOS}/$id");
    return _handleHttpRequest(
      uri: uri,
      onSuccess: (responseJson) => Todo.fromJson(responseJson),
    );
  }

  Future<Either<NetworkError, T>> _handleHttpRequest<T>({
    required Uri uri,
    required T Function(String) onSuccess,
  }) async {
    try {
      final response = await client.get(uri).timeout(Duration(seconds: 10));

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        _log.info(response.body);
        return Right(onSuccess(response.body));
      } else {
        _log.warning(response.body);
        return Left(_mapHttpError(response.statusCode));
      }
    } on SocketException catch (e) {
      _log.severe(e);
      return Left(NetworkError.noInternet);
    } on TimeoutException catch (e) {
      _log.severe(e);
      return Left(NetworkError.requestTimeout);
    } on FormatException catch (e) {
      _log.severe(e);
      return Left(NetworkError.serialization);
    } on HttpException catch (e) {
      _log.severe(e);
      return Left(NetworkError.server);
    } on http.ClientException catch (e) {
      _log.severe(e);
      return Left(NetworkError.clientError);
    } on Exception catch (e) {
      _log.severe(e);
      return Left(NetworkError.unknown);
    }
  }

  NetworkError _mapHttpError(int statusCode) {
    switch (statusCode) {
      case 401:
        return NetworkError.unauthorized;
      case 403:
        return NetworkError.forbidden;
      case 404:
        return NetworkError.notFound;
      default:
        return NetworkError.unknown;
    }
  }
}
