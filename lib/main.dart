import 'package:flutter/material.dart';
import 'package:eat_local/SavedPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: MediaQuery(
        data: MediaQueryData(),
        child: SavedPage(),
      ),
    );
  }
}
