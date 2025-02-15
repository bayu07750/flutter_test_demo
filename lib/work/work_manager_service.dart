// ignore_for_file: avoid_print

import 'package:flutter_test_demo/main.dart';
import 'package:workmanager/workmanager.dart';

/// A service class to manage Workmanager tasks.
class WorkmanagerService {
  final Workmanager _workmanager;

  /// Constructor for [WorkmanagerService].
  /// If no [Workmanager] instance is provided, a default instance is used.
  WorkmanagerService([Workmanager? workmanager]) : _workmanager = workmanager ??= Workmanager();

  /// Initializes the Workmanager with the [callbackDispatcher].
  Future<void> init() async {
    await _workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  /// Registers a one-off task with the Workmanager.
  Future<void> runOneOffTask({
    required String payload,
  }) async {
    await _workmanager.registerOneOffTask(
      'com.example.flutter_test_demo.oneoff',
      'run.oneoff',
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      initialDelay: const Duration(seconds: 5),
      inputData: {
        "data": payload,
      },
    );
  }

  /// Registers a periodic task with the Workmanager.
  Future<void> runPeriodicTask() async {
    await _workmanager.registerPeriodicTask(
      'com.example.myapp.periodic',
      'run.periodic',
      frequency: const Duration(minutes: 16),
      initialDelay: Duration.zero,
      inputData: {
        "data": "This is a valid payload from periodic task workmanager",
      },
    );
  }

  /// Cancels all tasks registered with the Workmanager.
  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
