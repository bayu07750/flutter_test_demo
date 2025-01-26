import 'package:flutter/material.dart';
import 'package:flutter_test_demo/model/todo.dart';
import 'package:flutter_test_demo/provider/detail_provider.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DetailProvider(networkDataSource: context.read())..getTodoDetail(id),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('Detail'),
          ),
          body: Stack(
            children: [
              // loading
              () {
                final isLoading = context.select<DetailProvider, bool>((value) => value.state.isLoading);
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SizedBox();
              }(),

              // error
              () {
                final error = context.select<DetailProvider, String?>((value) => value.state.messageError);
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
                            context.read<DetailProvider>().getTodoDetail(id);
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
                final todo = context.select<DetailProvider, Todo?>((value) => value.state.todo);
                if (todo == null) {
                  return SizedBox();
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Title: ${todo.title}'),
                      Text('Completed: ${todo.completed}'),
                    ],
                  ),
                );
              }(),
            ],
          ),
        );
      },
    );
  }
}
