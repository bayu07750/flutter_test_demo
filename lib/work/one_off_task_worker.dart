import 'package:flutter_test_demo/work/work_manager_service.dart';

class OneOffTaskWorker {
  static const String uniqueName = 'OneOffTaskWorker';
  static const String taskName = 'runOneOffTask';

  final WorkmanagerService _workmanagerService;

  OneOffTaskWorker({required WorkmanagerService workmanagerService}) : _workmanagerService = workmanagerService;

  Future<void> runOneOffTask({
    required String payload,
    Duration initialDelay = const Duration(seconds: 3),
  }) async {
    await _workmanagerService.runOneOffTask(
      payload: payload,
      uniqueName: uniqueName,
      taskName: taskName,
      initialDelay: initialDelay,
    );
  }
}
