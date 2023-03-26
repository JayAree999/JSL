import 'package:flutter/material.dart';

class CalorieButton extends StatelessWidget {
  final VoidCallback onPressed;

  CalorieButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF39507A)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Text('Calorie Tracker'),
    );
  }
}
