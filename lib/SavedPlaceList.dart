import 'package:flutter/material.dart';

class SavedPlaceList extends StatefulWidget {
  @override
  _SavedPlaceListState createState() => _SavedPlaceListState();
}

class _SavedPlaceListState extends State<SavedPlaceList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
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
              leading: Icon(Icons.place),
              title: Text('Place ${index + 1}'),
              subtitle: Text('Address ${index + 1}'),
            ),
          ),
        );
      },
    );
  }
}
