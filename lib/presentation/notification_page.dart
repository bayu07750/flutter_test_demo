import 'package:flutter/material.dart';
import 'package:flutter_test_demo/notification/local_notification_service.dart';
import 'package:flutter_test_demo/provider/notification_provider.dart';
import 'package:flutter_test_demo/utils/random.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Notification permission: ${context.watch<NotificationProvider>().isNotificationGranted}'),
          ElevatedButton(
            onPressed: () {
              _showNotification(context);
            },
            child: const Text('Show Notification'),
          ),
          ElevatedButton(
            onPressed: () {
              _scheduleNotification(context);
            },
            child: Text('Bangunkan Sholat Shubuh'),
          ),
          ElevatedButton(
            onPressed: () {
              _cancelScheduleNotification(context);
            },
            child: Text('Jangan Bangunkan Sholat Shubuh'),
          ),
        ],
      ),
    );
  }

  void _showNotification(BuildContext context) {
    final notificationService = context.read<LocalNotificationService>();
    final todoId = Random.generateRandom();
    final title = 'Todo $todoId';
    final body = 'This is the body of Todo $todoId';
    notificationService.showNotification(
      id: Random.generateRandom(),
      title: title,
      body: body,
      payload: todoId.toString(),
    );
  }

  void _scheduleNotification(BuildContext context) {
    final notificationService = context.read<LocalNotificationService>();
    notificationService.scheduleForPrayShubuh(id: 1001);
  }

  void _cancelScheduleNotification(BuildContext context) {
    final notificationService = context.read<LocalNotificationService>();
    notificationService.cancelNotification(1000);
  }
}
