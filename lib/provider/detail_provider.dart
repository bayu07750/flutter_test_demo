import 'package:flutter/material.dart';
import 'package:flutter_test_demo/network/network_data_source.dart';
import 'package:flutter_test_demo/provider/detail_state.dart';
import 'package:flutter_test_demo/utils/error_message.dart';

class DetailProvider extends ChangeNotifier {
  final NetworkDataSource _networkDataSource;

  DetailProvider({required NetworkDataSource networkDataSource}) : _networkDataSource = networkDataSource;

  var _state = DetailState.initial;

  DetailState get state => _state;

  getTodoDetail(int id) async {
    _state = _state.copyWith(isLoading: true);

    final result = await _networkDataSource.fetchTodoById(id);
    result.fold(
      (error) {
        _state = _state.copyWith(isLoading: false, messageError: error.message);
      },
      (todo) {
        _state = _state.copyWith(isLoading: false, todo: todo);
      },
    );

    notifyListeners();
  }
}
