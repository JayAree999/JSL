import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_local/ApiServices/RestaurantUtil.dart';
import 'package:eat_local/LocationData.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../DimissKeyboard.dart';
import '../ApiServices/GoogleMapUtil.dart';
import '../LocalDatabase/RestaurantDatabse.dart';
import 'AllButtons.dart';
import 'BottomContainer.dart';

class LocationScreenn extends StatefulWidget {
  final Map<String, dynamic>? startingPlace;

  const LocationScreenn({Key? key, required this.startingPlace})
      : super(key: key);

  @override
  State<LocationScreenn> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreenn> {
  // For fitting the screen
  late double width;
  late double safeHeight;

  // GoogleMap controller
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  // Current Place
  Map<String, dynamic>? currentPlace;

  // Parameters for BottomContainer
  late Future<List<Restaurant>> nearbyRestaurants;
  late Future<List<double>> latLng;

  // Map's marker
  late Marker currentMarker;
  late Marker restaurantMarker;

  @override
  void initState() {
    super.initState();
    currentPlace = widget.startingPlace;
    nearbyRestaurants = getNearbyRestaurants(currentPlace);
    latLng = GoogleMapUtil.getLatLng(currentPlace);
    latLng.then((latLng) {
      currentMarker = Marker(
          markerId: const MarkerId("current place"),
          position: LatLng(latLng[0], latLng[1]),
          icon:
              BitmapDescriptor.defaultMarker);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LocationData provider = Provider.of<LocationData>(context, listen: false);

      latLng.then((latLng) => provider.setAll(safeHeight, width, mapController,
          currentPlace, nearbyRestaurants, latLng, currentMarker));
    });
  }

  @override
  void dispose() {
    mapController.future.then((value) => value.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;

    safeHeight = height - padding.top - padding.bottom;

    return DismissKeyboard(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Stack(
                  children: [
                    SizedBox(
                        height: safeHeight / 3 * 2,
                        width: width,
                        child: FutureBuilder(
                          future: GoogleMapUtil.googleMap(
                              widget.startingPlace, mapController, context),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data;
                            }
                            return const Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xffea3f30)));
                          },
                        )),
                    const AllButtons(),
                  ],
                ),
                const BottomContainer(),
                orangeBar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget orangeBar() {
    return Positioned(
      top: safeHeight / 3 * 2 - 45,
      left: 25,
      child: Container(
        width: width - 50,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffea3f30),
        ),
      ),
    );
  }
}
