import 'package:flutter/material.dart';

class CalorieTracker extends StatefulWidget {
  @override
  _CalorieTrackerState createState() => _CalorieTrackerState();
}

class _CalorieTrackerState extends State<CalorieTracker> {

  List<String> foods = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
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
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 12),
                    height: 48,
                    width: 112,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        "1337",
                        style: TextStyle(
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
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 12),
                    height: 48,
                    width: 112,
                    color: Colors.white,
                    child: Center(
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

          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            height: 400,
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
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: TextField(
                    onSubmitted: (value) {
                      foods.add(value);
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
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 12),
                  height: 250,
                  width: double.infinity,
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(foods[index])
                      );
                    },
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}