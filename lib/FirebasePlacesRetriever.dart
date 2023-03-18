import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseDemo extends StatefulWidget {
  @override
  _FirebaseDemo createState() => _FirebaseDemo();
}

class _FirebaseDemo extends State<FirebaseDemo> {
  Future<List<DocumentSnapshot>> fetchPlaces() async {
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('places');
    QuerySnapshot querySnapshot = await collectionReference.get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: fetchPlaces(),
      builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final places = snapshot.data!;
          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (BuildContext context, int index) {
              final place = places[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.place),
                    title: Text(place['name']),
                    subtitle: Text('Address ${index + 1}'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Geometry:'),
                            content: SingleChildScrollView(
                              child: Text(place['geometry'].toString()),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
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
