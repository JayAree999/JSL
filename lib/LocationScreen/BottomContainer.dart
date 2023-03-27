import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_local/LocationData.dart';
import 'package:eat_local/RestaurantScreen.dart';
import 'package:eat_local/Firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../ApiServices/GoogleMapUtil.dart';
import '../LocalDatabase/RestaurantDatabse.dart';

class BottomContainer extends StatefulWidget {
  const BottomContainer({Key? key}) : super(key: key);

  @override
  State<BottomContainer> createState() => _BottomContainerState();
}

class _BottomContainerState extends State<BottomContainer> {
  // Dropdown
  final List<String> list = ['1 km', '5 km', '10 km', '20 km'];
  String? dropdownValue;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    LocationData provider = Provider.of<LocationData>(context);

    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Image(
                image: AssetImage("assets/images/bigSearch.png"),
                height: 30,
                width: 30,
              ),
            ),
            const SizedBox(width: 20),
            const Text(
              "Nearby Restaurants",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: provider.safeHeight / 3 + 75,
          child: SingleChildScrollView(
            primary: false,
            child: FutureBuilder<List<Restaurant>>(
                future: provider.restaurants,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    ));
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("No Restaurant"));
                  }

                  if (snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Restaurant"));
                  }

                  double lat = provider.latLng[0];
                  double lng = provider.latLng[1];

                  snapshot.data!.sort((a, b) => Geolocator.distanceBetween(
                          lat, lng, a.latitude, a.longitude)
                      .compareTo(Geolocator.distanceBetween(
                          lat, lng, b.latitude, b.longitude)));

                  List<Widget> restaurants = [];

                  for (var restaurant in snapshot.data!) {
                    double distance = Geolocator.distanceBetween(lat, lng,
                            restaurant.latitude, restaurant.longitude) /
                        1000;
                    restaurants.add(listItem(context, restaurant, distance));
                    restaurants.add(const SizedBox(height: 10));
                  }
                  if (restaurants.isNotEmpty) {
                    restaurants.removeLast();
                  }

                  return Column(
                    children: restaurants,
                  );
                }),
          ),
        )
      ],
    );
  }

  Widget listItem(context, Restaurant restaurant, double distance) {
    LocationData provider = Provider.of<LocationData>(context);

    return GestureDetector(
      onLongPress: () async {
        User? currentUser = await getCurrentUser();
        if (currentUser == null) {
          return;
        }

        var query = await fireStore
            .collection('restaurants')
            .where('name', isEqualTo: restaurant.title)
            .where('userId', isEqualTo: _auth.currentUser!.uid)
            .get();

        if (query.size > 0) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('This Restaurant Had Already Been Saved.'),
            duration: Duration(seconds: 3), // Change the duration as needed
          ));
          return;
        }

        Map<String, dynamic> data = {
          'userId': currentUser.uid,
          'restaurant': restaurant.toJson(),
          'name': restaurant.title
        };
        fireStore.collection('restaurants').add(data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Restaurant Saved.'),
          duration: Duration(seconds: 3), // Change the duration as needed
        ));
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RestaurantScreen(restaurant: restaurant)));
      },
      child: Container(
        height: 65,
        width: provider.width - 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3f000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                restaurant.image,
                errorBuilder: (context, object, stackTrace) {
                  return const SizedBox(
                      width: 65, height: 65, child: Icon(Icons.restaurant));
                },
                width: 65,
                height: 65,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        restaurant.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.50,
                    child: Text(
                      "${distance.toStringAsFixed(1)} km",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  double lat = restaurant.latitude;
                  double lng = restaurant.longitude;
                  GoogleMapUtil.changeLocation(
                      lat, lng, provider.mapController);
                  provider.setMarker(
                      Marker(
                          markerId: const MarkerId("restaurant place"),
                          position: LatLng(lat, lng),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueCyan)),
                      1);
                },
                child: const SizedBox(
                    width: 60,
                    height: 40,
                    child: Icon(
                      Icons.my_location,
                      color: Colors.grey,
                    ))),
          ],
        ),
      ),
    );
  }
}
