import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'CalorieTracker.dart';
import 'SavedHeader.dart';
import 'SavedButtons.dart';
import 'SavedRestaurantList.dart';
import 'SavedPlaceList.dart';
import 'CalorieButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedPage extends StatefulWidget {
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  bool _isRestaurantListSelected = false;
  bool isCalorieTrackerSelected = false;
  void toggleCalorieTracker(bool value) {
    setState(() {
      isCalorieTrackerSelected = value;
    });
  }

  void _toggleList(bool value) {
    setState(() {
      _isRestaurantListSelected = value;
      isCalorieTrackerSelected = false;
    });
  }

  Future<bool> _onWillPop() async {
    return false; // Disables the back button
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
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
                  CalorieButton(
                    onPressed: () {
                      toggleCalorieTracker(!isCalorieTrackerSelected);
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  isCalorieTrackerSelected
                      ? 'Calorie Tracker' :

                  _isRestaurantListSelected
                      ? 'Saved Restaurants'
                      : 'Saved Places',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: isCalorieTrackerSelected
                    ? _buildCalorieTracker()
                    : _isRestaurantListSelected
                    ? SavedRestaurantList()
                    : SavedPlaceList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildCalorieTracker() {
  return CalorieTracker();
}