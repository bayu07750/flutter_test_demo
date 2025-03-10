// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_test_demo/app_router.dart';
import 'package:flutter_test_demo/model/todo.dart';
import 'package:flutter_test_demo/notification/local_notification_service.dart';
import 'package:flutter_test_demo/provider/home_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _configureSelectNotificationSubject();
    super.initState();
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    super.dispose();
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) {
      final id = int.tryParse(payload ?? '-1') ?? -1;
      if (id != -1) {
        Navigator.pushNamed(
          context,
          AppRouter.detail,
          arguments: id,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(context.read())..getTodos(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('Todos'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.notification);
                },
                icon: const Icon(Icons.notifications),
              ),
            ],
          ),
          body: Stack(
            children: [
              // loading
              () {
                final isLoading = context.select<HomeProvider, bool>((value) => value.state.isLoading);
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SizedBox();
              }(),

              // error
              () {
                final error = context.select<HomeProvider, String?>((value) => value.state.messageError);
                if (error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 12,
                      children: [
                        Text(error),
                        ElevatedButton(
                          onPressed: () {
                            context.read<HomeProvider>().getTodos();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return SizedBox();
              }(),

              // content
              () {
                final todos = context.select<HomeProvider, List<Todo>>((value) => value.state.todos);
                return ListView.separated(
                  itemCount: todos.length,
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRouter.detail,
                          arguments: todos[index].id,
                        );
                      },
                      child: ListTile(
                        title: Text(todos[index].title),
                        subtitle: Text('complted: ${todos[index].completed}'),
                      ),
                    );
                  },
                );
              }(),
            ],
          ),
        );
      },
    );
  }
}
