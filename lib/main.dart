import 'package:flutter/material.dart';
import 'package:eat_local/SavedPage.dart';
import 'package:eat_local/LoginScreen.dart';
import 'package:eat_local/RegisterScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat Local',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/saved': (context) => SavedPage(),
      }
    );
  }
}
