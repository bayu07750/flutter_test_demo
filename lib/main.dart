// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_demo/app_router.dart';
import 'package:flutter_test_demo/network/imp/http_network_data_source.dart';
import 'package:flutter_test_demo/network/network_data_source.dart';
import 'package:flutter_test_demo/network/utils/network_logger_interceptor.dart';
import 'package:flutter_test_demo/presentation/detail_page.dart';
import 'package:flutter_test_demo/presentation/home_page.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

void main() async {
  Logger.root.level = kDebugMode || kProfileMode ? Level.ALL : Level.OFF;
  Logger.root.onRecord.listen((record) {
    print('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<NetworkDataSource>(
      create: (context) => HttpNetworkDataSource(
        client: InterceptedClient.build(interceptors: [NetworkLoggerInterceptor()]),
      ),
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
            useMaterial3: true,
          ),
          initialRoute: AppRouter.initial,
          routes: {
            AppRouter.initial: (context) => HomePage(),
            AppRouter.detail: (context) {
              final id = ModalRoute.of(context)!.settings.arguments as int;
              return DetailPage(id: id);
            },
          },
        );
      },
    );
  }
}
