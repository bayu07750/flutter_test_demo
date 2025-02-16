// ignore_for_file: avoid_print

import 'package:flutter_test_demo/network/imp/http_network_data_source.dart';
import 'package:flutter_test_demo/network/network_data_source.dart';
import 'package:flutter_test_demo/network/utils/network_logger_interceptor.dart';
import 'package:flutter_test_demo/notification/local_notification_service.dart';
import 'package:flutter_test_demo/utils/random.dart';
import 'package:flutter_test_demo/work/one_off_task_worker.dart';
import 'package:flutter_test_demo/work/periodic_task_worker.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void onExecutedWorker() {
  Workmanager().executeTask((task, inputData) async {
    final NetworkDataSource networkDataSource = HttpNetworkDataSource(
      client: InterceptedClient.build(
        interceptors: [
          NetworkLoggerInterceptor(),
        ],
      ),
    );

    print(task);

    // Handling OneOffTask
    if (task == OneOffTaskWorker.taskName ||
        task == OneOffTaskWorker.uniqueName ||
        task == Workmanager.iOSBackgroundTask) {
      print("inputData: $inputData");
      final String payload = inputData!['data'] ?? '';
      final int id = int.tryParse(payload) ?? -1;
      if (id != -1) {
        final result = await networkDataSource.fetchTodoById(id);
        result.fold(
          (error) {
            // Ignore Error
          },
          (todo) {
            // show notification
            final localNotificationService = LocalNotificationService()
              ..init()
              ..configureLocalTimeZone();

            localNotificationService.showNotification(
              id: Random.generateRandom(),
              title: todo.title,
              body: todo.completed.toString(),
              payload: todo.id.toString(),
            );
          },
        );
      }
    }

    // Handling PeriodicTask
    if (task == PeriodicTaskWorker.taskName || task == PeriodicTaskWorker.uniqueName) {
      int randomNumber = Random.generateRandom();
      final result = await networkDataSource.fetchTodoById(randomNumber);
      result.fold(
        (error) {
          // Ignore Error
        },
        (todo) {
          // show notification
          final localNotificationService = LocalNotificationService()
            ..init()
            ..configureLocalTimeZone();

          localNotificationService.showNotification(
            id: Random.generateRandom(),
            title: todo.title,
            body: todo.completed.toString(),
            payload: todo.id.toString(),
          );
        },
      );
    }

    return Future.value(true);
  });
}
