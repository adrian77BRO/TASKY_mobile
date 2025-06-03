import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/navigation/routes.dart';
import 'package:tasky/task/presentation/notifiers/task_notifier.dart';
import 'package:tasky/task/presentation/screens/form_screen.dart';
import 'package:tasky/task/presentation/screens/task_detail_screen.dart';
import 'package:tasky/task/presentation/screens/task_list_screen.dart';
import 'package:tasky/user/presentation/screens/login_screen.dart';
import 'package:tasky/user/presentation/notifiers/user_notifier.dart';
import 'package:tasky/user/presentation/screens/register_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
      ],
      child: const TaskyApp(),
    ),
  );
}

/*class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasky',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen()
    );
  }
}*/

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasky',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => LoginScreen(),
        AppRoutes.register: (_) => RegisterScreen(),
        AppRoutes.tasks: (_) => const TaskListScreen(),
        AppRoutes.taskForm: (_) => FormScreen(),
        AppRoutes.taskDetail: (_) => const TaskDetailScreen(),
      },
    );
  }
}
