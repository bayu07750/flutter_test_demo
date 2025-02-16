

import 'package:flutter_test_demo/work/worker_callback_dispatcker.dart';
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
      WorkerCallbackDispatcker.onExecutedWorker,
      isInDebugMode: true,
    );
  }

  
  /// Schedules a one-off background task using Workmanager.
  ///
  /// This method registers a uniquely identified background task that executes once
  /// after an optional initial delay. The task will only run when the device is connected
  /// to a network, as specified by the constraints. The provided [payload] is transmitted
  /// to the background execution environment as part of the task's input data.
  ///
  /// Parameters:
  /// - [payload]: The data to be processed by the task. This is often formatted as a JSON string
  ///   or another serialized format, ensuring that the task can retrieve all the necessary context.
  /// - [uniqueName]: A unique identifier for the task. This helps in preventing duplicate task
  ///   registrations and managing task lifecycle.
  /// - [taskName]: The designated name for the task. This corresponds to a specific operation
  ///   implemented within the Workmanager's task handling logic.
  /// - [initialDelay]: An optional duration to delay the execution of the task. By default, this is
  ///   set to 0 seconds, meaning the task is scheduled to run as soon as possible (provided the constraints
  ///   are met).
  ///
  /// Example:
  ///   await runOneOffTask(
  ///     payload: '{"action": "syncData"}',
  ///     uniqueName: 'sync_data_task',
  ///     taskName: 'syncData',
  ///     initialDelay: Duration(seconds: 10),
  ///   );
  Future<void> runOneOffTask({
    required String payload,
    required String uniqueName,
    required String taskName,
    Duration initialDelay = const Duration(seconds: 0),
  }) async {
    await _workmanager.registerOneOffTask(
      uniqueName,
      taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      initialDelay: initialDelay,
      inputData: {
        "data": payload,
      },
    );
  }

  /// This method schedules a periodic task identified by [uniqueName] and [taskName] to run
  /// at intervals defined by [frequency]. Note that [frequency] must be at least 15 minutes.
  /// The task starts immediately with no initial delay.
  ///
  /// An optional [payload] can be provided, which will be passed as input data under the key "data".
  ///
  /// Example:
  ///   await runPeriodicTask(
  ///     uniqueName: 'unique_task_id',
  ///     taskName: 'background_job',
  ///     frequency: Duration(minutes: 15), // Frequency must be at least 15 minutes.
  ///     payload: '{"user": "example"}',
  ///   );
  Future<void> runPeriodicTask({
    required String uniqueName,
    required String taskName,
    required Duration frequency,
    String? payload,
  }) async {
    await _workmanager.registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: frequency,
      initialDelay: frequency,
      inputData: {
        "data": payload,
      },
    );
  }

  Future<void> cancelTaskByName({
    required String uniqueName,
  }) async {
    await _workmanager.cancelByUniqueName(uniqueName);
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
