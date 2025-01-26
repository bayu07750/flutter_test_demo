import 'package:flutter/material.dart';
import 'package:flutter_test_demo/network/network_data_source.dart';
import 'package:flutter_test_demo/provider/home_state.dart';
import 'package:flutter_test_demo/utils/error_message.dart';

final class HomeProvider extends ChangeNotifier {
  final NetworkDataSource _networkDataSource;

  HomeProvider(this._networkDataSource);

  HomeState _state = HomeState.initial;

  HomeState get state => _state;

  Future<void> getTodos() async {
    _state = _state.copyWith(isLoading: true);

    final result = await _networkDataSource.fetchTodos();

    result.fold((error) {
      _state = _state.copyWith(isLoading: false, messageError: error.message);
    }, (todos) {
      _state = _state.copyWith(isLoading: false, todos: todos);
    });

    notifyListeners();
  }
}
