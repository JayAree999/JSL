import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LocationScreen/LocationProvider.dart';

class SavedRestaurantList extends StatefulWidget {
  @override
  _SavedRestaurantListState createState() => _SavedRestaurantListState();
}

String currentUserId = '';

class _SavedRestaurantListState extends State<SavedRestaurantList> {
  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  void _getCurrentUserId() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = await _auth.currentUser?.uid;
    if (user != null) {
      setState(() {
        currentUserId = user;
      });
    }
  }

  bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('restaurants')
            .where("userId", isEqualTo: currentUserId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> restaurant =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final Map<String, dynamic> result = {
                  "geometry": {
                    "location": {
                      "lat": restaurant["restaurant"]["latitude"],
                      "lng": restaurant["restaurant"]["longitude"]
                    }
                  }
                };
                return Dismissible(
                  key: ValueKey(snapshot.data!.docs[index].id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    // Remove the item from Firestore
                    FirebaseFirestore.instance
                        .collection('restaurants')
                        .doc(snapshot.data!.docs[index].id)
                        .delete();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      // Remove any padding from the ListTile
                      leading: restaurant['restaurant']['image'] != null &&
                              isValidUrl(restaurant['restaurant']['image'])
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                restaurant['restaurant']['image'].trim(),
                                width: 75,
                                height: 75,
                                fit: BoxFit.fill,
                              ),
                            )
                          : const Icon(Icons.image_not_supported),
                      title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(restaurant['name'] ?? 'No name')),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Remove the item from Firestore
                          FirebaseFirestore.instance
                              .collection('restaurants')
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LocationScreen(startingPlace: result)),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
