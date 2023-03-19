import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'LocationScreenn.dart';

class SavedPlaceList extends StatefulWidget {
  @override
  _SavedPlaceListState createState() => _SavedPlaceListState();
}

class _SavedPlaceListState extends State<SavedPlaceList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('places').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No data'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> place = snapshot.data!.docs[index].data() as Map<String, dynamic>;
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
                    title: Text(place['place']['name'] ?? 'No name'),
                    subtitle: Flexible(
                      child: Text(
                        'Formatted address: ${place['place']['formatted_address'] ?? 'No address'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationScreen(startingPlace: place['place']),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
