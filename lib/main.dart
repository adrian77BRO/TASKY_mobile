import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/user/presentation/screens/login_screen.dart';
import 'package:tasky/user/presentation/notifiers/user_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasky',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}