import 'package:flutter_test_demo/work/work_manager_service.dart';

class PeriodicTaskWorker {
  static const String uniqueName = 'PeriodicTaskWorker';
  static const String taskName = 'runPeriodicTask';

  final WorkmanagerService _workmanagerService;

  PeriodicTaskWorker({required WorkmanagerService workmanagerService}) : _workmanagerService = workmanagerService;

  Future<void> runPeriodicTask({
    Duration frequency = const Duration(minutes: 15),
    String? payload,
  }) async {
    await _workmanagerService.runPeriodicTask(
      uniqueName: uniqueName,
      taskName: taskName,
      frequency: frequency,
      payload: payload,
    );
  }

  Future<void> cancelPeriodicTask() async {
    await _workmanagerService.cancelTaskByName(
      uniqueName: uniqueName,
    );
  }
}
