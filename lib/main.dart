import 'package:flutter/material.dart';
import 'package:password_manager/providers/notifier.dart';
import 'package:password_manager/screens/passwords.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey),
      initialRoute: '/',
      routes: {
        '/': (context) => ChangeNotifierProvider(
            create: (context) => PasswordNotifier(),
            child: const PasswordPage()),
      },
    );
  }
}
