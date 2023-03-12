import 'package:eat_local/LocationScreenn.dart';
import 'package:eat_local/RestaurantScreen.dart';
import 'package:flutter/material.dart';
import 'package:eat_local/SavedPage.dart';
import 'package:eat_local/LoginScreen.dart';
import 'package:eat_local/RegisterScreen.dart';

void main() {
  runApp(MyApp());
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
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
        '/location': (context) => LocationScreen(),
        '/restaurant': (context) => RestaurantScreen(),
      },
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
    );
  }
}
