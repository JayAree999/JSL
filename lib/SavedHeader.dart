import 'package:flutter/material.dart';

import 'LocationScreenn.dart';
import 'LoginScreen.dart';

class SavedHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationScreen()),
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/locimage.png',
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Eat Local',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/backimage.png',
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}