import 'dart:async';
import 'dart:convert';

import 'package:eat_local/ApiServices/AutocompleteUtil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'NetworkUtil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiKey = dotenv.env['API_KEY']!;

Location location = Location();
final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

Future<GoogleMap> googleMap(Map<String, dynamic>? startingPlace) async {
  late double lat;
  late double lng;

  if (startingPlace == null) {
    LocationData currentPosition = await location.getLocation();
    lat = currentPosition.latitude!;
    lng = currentPosition.longitude!;
  } else {
    var startingLocation = startingPlace!['geometry']['location'];
    lat = startingLocation['lat'];
    lng = startingLocation['lng'];
  }

  return GoogleMap(
    mapType: MapType.normal,
    myLocationEnabled: true,
    myLocationButtonEnabled: false,
    zoomControlsEnabled: false,
    initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 15
    ),
    onMapCreated: (GoogleMapController controller) {
      if(!_controller.isCompleted){
        _controller.complete(controller);
      }
    },
  );
}

void currentLocation() async {
  final GoogleMapController controller = await _controller.future;
  LocationData? currentLocation;
  try {
    currentLocation = await location.getLocation();
  } on Exception {
    currentLocation = null;
  }

  controller.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(
      bearing: 0,
      target: currentLocation != null ? LatLng(currentLocation.latitude!, currentLocation.longitude!) : const LatLng(0, 0),
      zoom: 15,
    ),
  ));
}

void changeLocation(double lat, double lng) async {
  final GoogleMapController controller = await _controller.future;

  controller.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(
      bearing: 0,
      target: LatLng(lat, lng),
      zoom: 15,
    ),
  ));
}

Future<List<AutocompletePrediction>> placeAutocomplete(String query) async {
  Uri uri = Uri.https(
    "maps.googleapis.com",
    "maps/api/place/autocomplete/json",
    {
      "input": query,
      "key": apiKey,
      "components": "country:th"
    }
  );

  String? response = await NetworkUtil.fetchUrl(uri);

  if (response != null) {
    AutoCompleteResponse result = AutoCompleteResponse.parseAutocomplete(response);
    return result.predictions?? [];
  }
  return [];
}

Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
  Uri uri = Uri.https(
    "maps.googleapis.com",
    "maps/api/place/details/json",
    {
      "place_id": placeId,
      "key": apiKey
    }
  );

  String? response = await NetworkUtil.fetchUrl(uri);

  if (response != null) {
    final parsed = json.decode(response);
    final results = parsed['result'] as Map<String, dynamic>;

    return results;
  }
  return null;
}