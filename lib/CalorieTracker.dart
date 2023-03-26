import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ApiServices/FoodDatabaseUtil.dart';
import 'package:eat_local/Firebase_auth.dart';

class CalorieTracker extends StatefulWidget {
  const CalorieTracker({super.key});

  @override
  _CalorieTrackerState createState() => _CalorieTrackerState();
}

class _CalorieTrackerState extends State<CalorieTracker> {
  User? _currentUser;
  late FirebaseFirestore _firestore;

  List<String> foods = [];
  List<int> calories = [];
  int todaysCalories = 0;
  int dailyAverage = 0;
  int weeklyTotal = 0;
  final fieldText = TextEditingController();


  @override
  void initState() {
    super.initState();
    getCurrentUser().then((user) {
      setState(() {
        _currentUser = user;
      });
    });
    getFirestore().then((firestore) {
      setState(() {
        _firestore = firestore!;

        _getFirebaseListOfMeals().then((meals) {
          setState(() {
            foods = meals;
          });
        });

        _getFirebaseListOfCalories().then((cals) {
          setState(() {
            calories = cals;
          });
        });

        _getFirebaseTodaysCalories().then((cals) {
          setState(() {
            todaysCalories = cals;

            _calculateWeeklyTotal().then((total) {
              setState(() {
                weeklyTotal = total;

                _calculateWeeklyAverage().then((avg) {
                  setState(() {
                    dailyAverage = avg;
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  void clearText() {
    fieldText.clear();
  }

  void _addFirebaseDailyTotal() async {
    int index = await _getNumOfFields();
    _firestore.collection('calorie tracker').doc(_currentUser?.email).set({
      'day ${index} total': 0
    }, SetOptions(merge: true));
  }

  void _clearFirebaseMealTracker() async {
    await _firestore.collection('meal tracker').doc(_currentUser?.email).set(
      {
        'meals' : [],
        'calories' : []
      }
    );
    setState(() {
      todaysCalories = 0;
    });
  }

  Future<List<String>> _getFirebaseListOfMeals() async {
    DocumentSnapshot snapshot = await _firestore.collection('meal tracker').doc(_currentUser?.email).get();

    try {
      List<dynamic> mealsDynamic = snapshot.get('meals');
      final List<String> meals = mealsDynamic.map((e) => e.toString()).toList();
      return meals;

    } catch (e) {
      print(e);
      print("CREATING MEAL TRACKER DOCUMENT");
      await _firestore.collection('meal tracker').doc(_currentUser?.email).set(
          {
            'meals' : foods,
            'calories' : calories
          }
      );
    }
    return [];
  }

  Future<List<int>> _getFirebaseListOfCalories() async {
    DocumentSnapshot snapshot = await _firestore.collection('meal tracker').doc(_currentUser?.email).get();
    List<int> caloriesList = snapshot.get('calories').cast<int>();
    return caloriesList;
  }
  
  void _updateFirebaseMealTracker() async {
    await _firestore.collection('meal tracker').doc(_currentUser?.email).update({
      'meals' : foods,
      'calories' : calories
    });
  }
  
  Future<int> _getFirebaseTodaysCalories() async {
    int lastDay = await _getNumOfFields();
    DocumentSnapshot snapshot = await _firestore.collection('calorie tracker').doc(_currentUser?.email).get();
    try {
      int todaysCalories = snapshot.get('day ${lastDay - 1} total');
      return todaysCalories;
    } catch (e) {
      print(e);
      print("CREATING CALORIE TRACKER DOCUMENT");
      await _firestore.collection('calorie tracker').doc(_currentUser?.email).set(
          {
            'day 0 total': 0
          }
      );
    }

    return 0;
  }

  Future<int> _calculateWeeklyTotal() async {
    int weeklyTotal = 0;
    int lastIndex = await _getNumOfFields() - 1;

    DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('calorie tracker')
        .doc(_currentUser?.email)
        .get();

    if (lastIndex >= 6) {
      for (var i = 0; i <= 6; i++) {
        int ithDayValue = snapshot.get('day ${lastIndex - i} total');
        weeklyTotal += ithDayValue;
      }
      return weeklyTotal;
    } else {
      for (var i = lastIndex; i >= 0; i--) {
        int ithDayValue = snapshot.get('day ${lastIndex - i} total');
        weeklyTotal += ithDayValue;
      }
      return weeklyTotal;
    }
  }

  Future<int> _calculateWeeklyAverage() async {
    int weeklyTotal = await _calculateWeeklyTotal();
    int totalDays = await _getNumOfFields();

    if (totalDays < 7) {
      return weeklyTotal ~/ totalDays;
    } else {
      return weeklyTotal ~/ 7;
    }
  }

  void _updateFirebaseCalorieTracker() async {
    int index = await _getNumOfFields();
    _firestore.collection('calorie tracker').doc(_currentUser?.email).update({'day ${index-1} total': todaysCalories});
  }

  Future<int> _getNumOfFields() async {
    final DocumentReference docRef = _firestore.collection('calorie tracker').doc(_currentUser?.email);

    DocumentSnapshot documentSnapshot = await docRef.get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      int numFields = data.length;
      return numFields;
    } else {
      return 0;
    }
  }

  void _updateTotalCalories() {
    int temp = 0;
    for (var i = 0; i<calories.length; i++) {
      temp += calories[i];
    }
    todaysCalories = temp;
  }

  void _addFoods(String food, double cals) {
    setState(() {
      if (cals == 0.0) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid food item.'),
              duration: Duration(seconds: 3),
            )
        );
      } else {
        foods.add(food);
        calories.add(cals.toInt());
        _updateTotalCalories();
        _updateFirebaseMealTracker();
        _updateFirebaseCalorieTracker();
        _calculateWeeklyTotal().then((total) {
          setState(() {
            weeklyTotal = total;
          });
        });
        _calculateWeeklyAverage().then((avg) {
          setState(() {
            dailyAverage = avg;
          });
        });
      }
    });
  }

  void _removeFoods(int index) async {
    setState(() {
      foods.removeAt(index);
      calories.removeAt(index);
      _updateTotalCalories();
      _updateFirebaseMealTracker();
      _updateFirebaseCalorieTracker();
      _calculateWeeklyTotal().then((total) {
        setState(() {
          weeklyTotal = total;
        });
      });
      _calculateWeeklyAverage().then((avg) {
        setState(() {
          dailyAverage = avg;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: 300,
                width: 360,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        "Today's Calories",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 12),
                        height: 48,
                        width: 112,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            todaysCalories.toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Average past 7 days",
                        style: TextStyle(
                          color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 12),
                        height: 48,
                        width: 112,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            dailyAverage.toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Total past 7 days",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 12),
                        height: 48,
                        width: 112,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            weeklyTotal.toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              height: 500,
              width: 360,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const Center(
                      child: Text(
                        "Track today's meals",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextField(
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          _addFoods(value, await fetchData(value));
                          clearText();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please type in a meal.'),
                                duration: Duration(seconds: 3),
                              )
                          );
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color.fromRGBO(0, 0, 0, 100),
                        ),
                        hintText: 'Enter a meal',
                      ),
                      controller: fieldText,
                    ),
                  ),

                  Container(
                      height: 320,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ListView.builder(
                        itemCount: foods.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: ListTile(
                                title: Text(foods[index]),
                                subtitle: Text("~${calories[index]} Kcal."),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    _removeFoods(index);
                                  },
                                ),
                              )
                          );
                        },
                      )
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _addFirebaseDailyTotal();
                      _clearFirebaseMealTracker();
                      setState(() {
                        foods = [];
                        calories = [];
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5.0,
                    ),
                    child: Container(
                      width: 300,
                      height: 20,
                      alignment: Alignment.center,
                      child: const Text(
                        "Submit today's calories and clear table",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
