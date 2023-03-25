import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'LocalDatabase/RestaurantDatabse.dart';

class LocationData with ChangeNotifier {
  double _safeHeight = double.infinity;
  late double _width = double.infinity;
  late Completer<GoogleMapController> _mapController;
  Map<String, dynamic>? _currentPlace;
  late Future<List<Restaurant>> _restaurants;
  late List<double> _latLng;
  final List<Marker?> _markers = [null, null];

  double get safeHeight => _safeHeight;

  void setSafeHeight(double value) {
    _safeHeight = value;
    notifyListeners();
  }

  double get width => _width;

  void setWidth(double value) {
    _width = value;
    notifyListeners();
  }

  Completer<GoogleMapController> get mapController => _mapController;

  void setMapController(Completer<GoogleMapController> value) {
    _mapController = value;
    notifyListeners();
  }

  Map<String, dynamic>? get currentPlace => _currentPlace;

  void setCurrentPlace(Map<String, dynamic>? value) {
    _currentPlace = value;
    notifyListeners();
  }

  Future<List<Restaurant>> get restaurants => _restaurants;

  void setRestaurants(Future<List<Restaurant>> value) {
    _restaurants = value;
    notifyListeners();
  }

  List<double> get latLng => _latLng;

  void setLatLng(List<double> value) {
    _latLng = value;
    notifyListeners();
  }


  List<Marker?> get markers => _markers;

  void setMarker(Marker? value, int index) {
    _markers[index] = value;
    notifyListeners();
  }

  void setAll(
      double safeHeight,
      double width,
      Completer<GoogleMapController> mapController,
      Map<String, dynamic>? currentPlace,
      Future<List<Restaurant>> restaurants,
      List<double> latLng,
      Marker currentMarker) {

    _safeHeight = safeHeight;
    _width = width;
    _mapController = mapController;
    _currentPlace = currentPlace;
    _restaurants = restaurants;
    _latLng = latLng;
    _markers[0] = currentMarker;
    notifyListeners();
  }

}
