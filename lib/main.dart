import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:eat_local/LocationScreenn.dart';
import 'package:eat_local/RestaurantScreen.dart';
import 'package:flutter/material.dart';
import 'package:eat_local/SavedPage.dart';
import 'package:eat_local/LoginScreen.dart';
import 'package:eat_local/RegisterScreen.dart';
import 'package:eat_local/CalorieTracker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
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
  static late FirebaseFirestore fireStore;

  void initFirebase() async {
    await Firebase.initializeApp();
    fireStore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    initFirebase();
    return MaterialApp(
      title: 'Eat Local',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/saved': (context) => SavedPage(),
        '/location': (context) => LocationScreen(),
        '/restaurant': (context) => RestaurantScreen(),
        '/calorie': (context) => CalorieTracker(),
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
