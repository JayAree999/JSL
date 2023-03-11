import 'package:flutter/material.dart';
class SavedRestaurantList extends StatefulWidget {
  @override
  _SavedRestaurantListState createState() => _SavedRestaurantListState();
}

class _SavedRestaurantListState extends State<SavedRestaurantList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(Icons.restaurant),
            title: Text('Restaurant ${index + 1}'),
            subtitle: Text('Address ${index + 1}'),
          ),
        );
      },
    );
  }
}
