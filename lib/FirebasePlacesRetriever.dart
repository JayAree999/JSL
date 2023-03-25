import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'LocationScreen/LocationProvider.dart';

Future<List<Map<String, dynamic>>> fetchDataFromFirestore() async {
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('places');
  QuerySnapshot querySnapshot = await collectionReference.get();
  List<Map<String, dynamic>> documents = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  return documents;
}

class FirebaseDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firestore Data List'),
        ),
        body: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchDataFromFirestore(),
            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _buildContent(context, snapshot);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    List<Map<String, dynamic>>? documents = snapshot.data;
    if (documents != null) {
      return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(documents[index]['place']['name'] ?? 'No name'),
            subtitle: Text('Formatted address: ${documents[index]['place']['formatted_address']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationScreen(startingPlace: documents[index]['place']),
                ),
              );
            },
          );
        },
      );
    } else {
      return const Text('No data');
    }
  }
}
