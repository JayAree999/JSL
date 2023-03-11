import 'package:flutter/material.dart';


class SavedButtons extends StatelessWidget {
  final Function(bool) onToggle;
  final bool isRestaurantListSelected;

  SavedButtons({
    required this.onToggle,
    required this.isRestaurantListSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => onToggle(true),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              isRestaurantListSelected ? Color(0xFFEA3F30) : Colors.white,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              isRestaurantListSelected ? Colors.white : Color(0xFFA6A6A6),
            ),
          ),
          child: Text('Restaurants'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => onToggle(false),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              !isRestaurantListSelected ? Color(0xFFEA3F30) : Colors.white,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              !isRestaurantListSelected ? Colors.white : Color(0xFFA6A6A6),
            ),
          ),
          child: Text('Places'),
        ),
      ],
    );
  }
}
