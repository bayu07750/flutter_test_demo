import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_demo/network/utils/network_error.dart';
import 'package:flutter_test_demo/provider/home_provider.dart';
import 'package:flutter_test_demo/provider/home_state.dart';
import 'package:flutter_test_demo/utils/error_message.dart';

import '../network/imp/fake_network_data_source.dart';

void main() {
  late FakeNetworkDataSource networkDataSource;
  late HomeProvider homeProvider;

  setUp(
    () {
      networkDataSource = FakeNetworkDataSource();
      homeProvider = HomeProvider(networkDataSource);
    },
  );

  test(
    'should return empty when provide intialized',
    () {
      final result = homeProvider.state;

      expect(result, HomeState.initial);
    },
  );

  test(
    'should return Right todos when request was succesfully',
    () async {
      // Act
      await homeProvider.getTodos();

      // Assert
      final state = homeProvider.state;
      expect(state.todos, isNotEmpty);
    },
  );

  test(
    'should return error when no internet connection',
    () async {
      // Arrange
      networkDataSource.noInternetError = true;

      // Act
      await homeProvider.getTodos();

      // Assert
      final state = homeProvider.state;
      expect(state.messageError, isNotNull);
      expect(state.messageError, equals(NetworkError.noInternet.message));
    },
  );

  test(
    'should return error when server not available',
    () async {
      // Arrange
      networkDataSource.serverError = true;

      // Act
      await homeProvider.getTodos();

      // Assert
      final state = homeProvider.state;
      expect(state.messageError, isNotNull);
      expect(state.messageError, equals(NetworkError.server.message));
    },
  );
}
