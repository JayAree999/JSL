import 'package:flutter/material.dart';
import 'CalorieTracker.dart';

class CalorieButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalorieTracker()),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2B2B2B)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        child: Text('Calorie Tracker'),
      ),
    );
  }
}
