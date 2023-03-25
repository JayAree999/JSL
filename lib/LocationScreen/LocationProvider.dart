import 'package:eat_local/LocationData.dart';
import 'package:eat_local/LocationScreen/LocationScreenn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatelessWidget {
  final Map<String, dynamic>? startingPlace;

  const LocationScreen({Key? key, this.startingPlace}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationData(),
      child: LocationScreenn(startingPlace: startingPlace),
    );
  }
}
