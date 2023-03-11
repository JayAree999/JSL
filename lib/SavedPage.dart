import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'SavedHeader.dart';
import 'SavedButtons.dart';
import 'SavedRestaurantList.dart';
import 'SavedPlaceList.dart';
class SavedPage extends StatefulWidget {
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  bool _isRestaurantListSelected = true;

  void _toggleList(bool value) {
    setState(() {
      _isRestaurantListSelected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SavedHeader(),
            SizedBox(height: 20),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SavedButtons(
                    onToggle: _toggleList,
                    isRestaurantListSelected: _isRestaurantListSelected,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _isRestaurantListSelected ? 'Saved Restaurants' : 'Saved Places',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _isRestaurantListSelected
                  ? SavedRestaurantList()
                  : SavedPlaceList(),
            ),
          ],
        ),
      ),
    );
  }


}
