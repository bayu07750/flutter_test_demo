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
import 'package:flutter_test_demo/utils/random.dart';
import 'package:flutter_test_demo/work/work_manager_service.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final NetworkDataSource networkDataSource = HttpNetworkDataSource(
      client: InterceptedClient.build(
        interceptors: [
          NetworkLoggerInterceptor(),
        ],
      ),
    );

    if (task == 'com.example.flutter_test_demo.oneoff' ||
        task == 'run.oneoff' ||
        task == Workmanager.iOSBackgroundTask) {
      print("inputData: $inputData");
      final String payload = inputData!['data'] ?? '';
      final int id = int.tryParse(payload) ?? -1;
      if (id != -1) {
        final result = await networkDataSource.fetchTodoById(id);
        result.fold(
          (error) {
            /// TODO ignore
          },
          (todo) {
            /// TODO show notification
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
    } else if (task == 'run.periodic' || task == 'com.example.myapp.periodic') {
      int randomNumber = Random.generateRandom();
      final result = await networkDataSource.fetchTodoById(randomNumber);
      result.fold(
        (error) {
          /// TODO ignore
        },
        (todo) {
          /// TODO show notification
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  String route = AppRouter.initial;
  String? payload;

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final notificationResponse = notificationAppLaunchDetails!.notificationResponse;
    route = AppRouter.detail;
    payload = notificationResponse?.payload;
  }

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
        )
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
            AppRouter.initial: (context) => HomePage(),
            AppRouter.notification: (context) => ChangeNotifierProvider(
                  create: (context) {
                    return NotificationProvider(localNotificationService: context.read())..requestPermission();
                  },
                  builder: (context, child) {
                    return const NotificationPage();
                  },
                ),
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
