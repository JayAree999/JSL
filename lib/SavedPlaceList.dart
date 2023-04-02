import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'LocationScreen/LocationProvider.dart';

class SavedPlaceList extends StatefulWidget {
  @override
  _SavedPlaceListState createState() => _SavedPlaceListState();
}

String currentUserId = '';
String apiKey = dotenv.env['API_KEY']!;

class _SavedPlaceListState extends State<SavedPlaceList> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('places')
            .where("userId", isEqualTo: currentUserId)
            .snapshots(),
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
                Map<String, dynamic> place =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                return Dismissible(
                  key: ValueKey(snapshot.data!.docs[index].id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    // Remove the item from Firestore
                    FirebaseFirestore.instance
                        .collection('places')
                        .doc(snapshot.data!.docs[index].id)
                        .delete();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                        // Remove any padding from the ListTile
                        leading: SizedBox(
                          height: 150,
                          width: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: place['place']['photos'] != null &&
                                      place['place']['photos'].isNotEmpty
                                  ? Image.network(
                                      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place['place']['photos'][0]['photo_reference']}&key=$apiKey',
                                      fit: BoxFit.cover,
                                      height:
                                          50, // Adjust the height of the image
                                      width:
                                          50, // Adjust the width of the image
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Icon(Icons.image_not_supported);
                                      },
                                    )
                                  : Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        title: Text(
                          place['place']['name'] ?? 'No name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              child: Text(
                                '${place['place']['formatted_address'] ?? 'No address'}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.delete, color: Color(0xffea3f30),),
                        // Add a delete icon on the right
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationScreen(
                                startingPlace: place['place'],
                              ),
                            ),
                          );
                        },
                      ),
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
