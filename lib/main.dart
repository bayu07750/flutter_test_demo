// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_demo/app_router.dart';
import 'package:flutter_test_demo/network/imp/http_network_data_source.dart';
import 'package:flutter_test_demo/network/network_data_source.dart';
import 'package:flutter_test_demo/network/utils/network_logger_interceptor.dart';
import 'package:flutter_test_demo/notification/local_notification_service.dart';
import 'package:flutter_test_demo/presentation/detail_page.dart';
import 'package:flutter_test_demo/presentation/home_page.dart';
import 'package:flutter_test_demo/presentation/notification_page.dart';
import 'package:flutter_test_demo/provider/notification_provider.dart';
import 'package:flutter_test_demo/work/one_off_task_worker.dart';
import 'package:flutter_test_demo/work/periodic_task_worker.dart';
import 'package:flutter_test_demo/work/work_manager_service.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  String route = AppRouter.initial;
  String? payload;

  /// This block checks if the application was launched as a result of a notification click 
  /// while the app was in the background. If so, it retrieves the notification response data,
  /// sets the appropriate routing to navigate to the detail view, and extracts any payload
  /// associated with the notification. The use of the null-aware operator ensures that if
  /// the notification launch details are unavailable, the app does not crash, defaulting the
  /// condition to false.
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final notificationResponse = notificationAppLaunchDetails!.notificationResponse;
    route = AppRouter.detail;
    payload = notificationResponse?.payload;
  }

  /// Registers and configures the global logger for the application.
  ///
  /// Sets the logging level based on the app's build mode:
  /// - In debug or profile mode, logging is enabled at the most verbose level ([Level.ALL]).
  /// - Otherwise, logging is disabled ([Level.OFF]).
  ///
  /// Also sets up a listener on the logger's records that prints each log entry
  /// with details including the logger name, log level, timestamp, and message.
  Logger.root.level = kDebugMode || kProfileMode ? Level.ALL : Level.OFF;
  Logger.root.onRecord.listen((record) {
    print('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(MyApp(
    initialRoute: route,
    payload: payload,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute, this.payload});

  final String initialRoute;
  final String? payload;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NetworkDataSource>(
          create: (context) {
            return HttpNetworkDataSource(
              client: InterceptedClient.build(
                interceptors: [NetworkLoggerInterceptor()],
              ),
            );
          },
        ),
        Provider(
          create: (context) {
            return LocalNotificationService()
              ..init()
              ..configureLocalTimeZone();
          },
          lazy: false,
        ),
        Provider(
          create: (context) {
            return WorkmanagerService()..init();
          },
          lazy: false,
        ),
        Provider(
          create: (context) {
            return OneOffTaskWorker(workmanagerService: context.read());
          },
        ),
        Provider(
          create: (context) {
            return PeriodicTaskWorker(workmanagerService: context.read());
          },
        ),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
            useMaterial3: true,
          ),
          initialRoute: initialRoute,
          routes: {
            AppRouter.initial: (context) {
              return HomePage();
            },
            AppRouter.notification: (context) {
              return ChangeNotifierProvider(
                  create: (context) {
                    return NotificationProvider(localNotificationService: context.read())..requestPermission();
                  },
                  builder: (context, child) {
                    return const NotificationPage();
                  },
              );
            },
            AppRouter.detail: (context) {
              final int id;

              if (payload != null) {
                id = int.tryParse(payload!) ?? -1;
              } else {
                id = ModalRoute.of(context)!.settings.arguments as int;
              }

              return DetailPage(id: id);
            },
          },
        );
      },
    );
  }
}
