import 'package:flutter/material.dart';
import 'package:flutter_test_demo/notification/local_notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final LocalNotificationService _localNotificationService;

  bool _isNotificationGranted = false;

  NotificationProvider({required LocalNotificationService localNotificationService})
      : _localNotificationService = localNotificationService;

  bool get isNotificationGranted => _isNotificationGranted;

  requestPermission() async {
    _isNotificationGranted = (await _localNotificationService.requestPermission()) ?? false;
    notifyListeners();
  }
}
