import 'dart:async';
import 'dart:convert';

import 'package:eat_local/ApiServices/AutocompleteUtil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../LocationData.dart';
import 'NetworkUtil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class GoogleMapUtil {
  static String apiKey = dotenv.env['API_KEY']!;

  static Future<List<double>> getLatLng(Map<String, dynamic>? startingPlace) async {
    late double lat;
    late double lng;

    if (startingPlace == null) {
      Position currentPosition = await Geolocator.getCurrentPosition();
      lat = currentPosition.latitude;
      lng = currentPosition.longitude;
    } else {
      var startingLocation = startingPlace['geometry']['location'];
      lat = startingLocation['lat'];
      lng = startingLocation['lng'];
    }

    return [lat, lng];
  }

  static Future<GoogleMap> googleMap(Map<String, dynamic>? startingPlace, Completer<GoogleMapController> mapController, BuildContext context) async {
    LocationData provider = Provider.of<LocationData>(context);
    List<double> latLng = await getLatLng(startingPlace);

    double lat = latLng[0];
    double lng = latLng[1];

    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      markers: provider.markers.where((marker) => marker != null).map((marker) => marker!).toSet(),
      initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 15),
      onMapCreated: (GoogleMapController controller) {
          mapController.complete(controller);
      },
    );
  }

  static void currentLocation(Completer<GoogleMapController> mapController) async {
    final GoogleMapController controller = await mapController.future;
    Position? currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: currentLocation != null
            ? LatLng(currentLocation.latitude!, currentLocation.longitude!)
            : const LatLng(0, 0),
        zoom: 15,
      ),
    ));
  }

  static void changeLocation(double lat, double lng, Completer<GoogleMapController> mapController) async {
    final GoogleMapController controller = await mapController.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(lat, lng),
        zoom: 15,
      ),
    ));
  }

  static Future<List<AutocompletePrediction>> placeAutocomplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {"input": query, "key": apiKey, "components": "country:th"});

    String? response = await NetworkUtil.fetchUrl(uri);

    if (response != null) {
      AutoCompleteResponse result =
          AutoCompleteResponse.parseAutocomplete(response);
      return result.predictions ?? [];
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    Uri uri = Uri.https("maps.googleapis.com", "maps/api/place/details/json",
        {"place_id": placeId, "key": apiKey});

    String? response = await NetworkUtil.fetchUrl(uri);

    if (response != null) {
      final parsed = json.decode(response);
      final results = parsed['result'] as Map<String, dynamic>;

      return results;
    }
    return null;
  }
}
