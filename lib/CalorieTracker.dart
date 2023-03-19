import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ApiServices/FoodDatabaseUtil.dart';
import 'package:eat_local/firebase_auth.dart';



class CalorieTracker extends StatefulWidget {
  const CalorieTracker({super.key});

  @override
  _CalorieTrackerState createState() => _CalorieTrackerState();
}

class _CalorieTrackerState extends State<CalorieTracker> {
  String currentUserId = '';
  User? _currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> foods = [];
  List<int> calories = [];
  int totalCalories = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser().then((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  void _updateTotal() {
    _firestore.collection('calorie tracker').doc(_currentUser?.email).set({'daily total': [totalCalories]});
  }

  void _addDaily() {
    _firestore.collection('calorie tracker').doc(_currentUser?.email).update({'daily total': FieldValue.arrayUnion([totalCalories])});
  }

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> _getData() async {
    final data = await _firestore.collection('calorie tracker').doc(_currentUser!.email).snapshots();
    return data;
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
        _calculateTotalCalories();
      }
    });
  }

  void _removeFoods(int index) {
    setState(() {
      foods.removeAt(index);
      calories.removeAt(index);
      _calculateTotalCalories();
    });
  }

  void _calculateTotalCalories() {
    int temp = 0;
    for (var i = 0; i<calories.length; i++) {
      temp += calories[i];
    }
    totalCalories = temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              height: 225,
              width: 290,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "Today's Calories",
                      style: TextStyle(
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
                          totalCalories.toString(),
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
                      "Daily average this week",
                      style: TextStyle(
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
                      child: const Center(
                        child: Text(
                          "1630",
                          style: TextStyle(
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
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            height: 500,
            width: 290,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "What did you eat today?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: TextField(
                    onSubmitted: (value) async {
                      _addFoods(value, await fetchData(value));
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
                  ),
                ),

                Container(
                  height: 366,
                  width: double.infinity,
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                            title: Text(foods[index]),
                            subtitle: Text("~${calories[index]} Kcal."),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _removeFoods(index);
                              },
                            ),
                          )
                      );
                    },
                  )
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // _updateTotal();
              _addDaily();
              print(_getData());
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }
}