import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_local/FirebasePlacesRetriever.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eat_local/CalorieTracker.dart';
import 'package:eat_local/LocationScreenn.dart';
import 'package:eat_local/RestaurantScreen.dart';
import 'package:flutter/material.dart';
import 'package:eat_local/SavedPage.dart';
import 'package:eat_local/LoginScreen.dart';
import 'package:eat_local/RegisterScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        '/login': (context) => const LoginScreen(),
        '/place': (context) => FirebaseDemo(),
        '/register': (context) => const RegisterScreen(),
        '/saved': (context) => SavedPage(),
        '/location': (context) => const LocationScreen(startingPlace: null,),
        '/restaurant': (context) => const RestaurantScreen(),
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
