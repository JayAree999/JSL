import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_local/ApiServices/RestaurantUtil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../ApiServices/AutocompleteUtil.dart';
import '../ApiServices/GoogleMapUtil.dart';
import '../LocationData.dart';

class AllButtons extends StatefulWidget {
  double addedHeight;
  AllButtons({Key? key, required this.addedHeight}) : super(key: key);

  @override
  State<AllButtons> createState() => _AllButtonsState();
}

class _AllButtonsState extends State<AllButtons> {
  // Controller for text field
  final TextEditingController searchController = TextEditingController();

  // For search autocomplete
  bool showSearchItems = false;
  List<AutocompletePrediction> predictions = [];
  
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocationData provider = Provider.of<LocationData>(context);

    return SizedBox(
      height: provider.safeHeight / 3 * 2,
      width: provider.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  backButton(),
                  searchBox(context),
                  saveButton(context)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [searchItems(context)],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              locButton(context),
              Container(height: widget.addedHeight + 50)
            ],
          ),
        ],
      ),
    );
  }

  Widget searchItems(context) {
    LocationData provider = Provider.of<LocationData>(context);

    return !showSearchItems
        ? const SizedBox()
        : SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          height: 200,
          width: 200,
          child: predictions.isNotEmpty ? ListView.builder(
              itemCount: predictions.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    // Get place location
                    final placeDetails = await GoogleMapUtil.getPlaceDetails(predictions[index].placeId!);
                    if (placeDetails == null) { return; }

                    // Move Camera
                    final location = placeDetails['geometry']['location'];
                    GoogleMapUtil.changeLocation(location['lat'], location['lng'], provider.mapController);
                    updateMap(provider, placeDetails);

                    // Hide suggestion box
                    setState(() {
                      showSearchItems = false;
                      provider.setCurrentPlace(placeDetails);
                    });

                    // Hide keyboard
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(predictions[index].description!),
                  ),
                );
              }) : const Center(child: Text("No Suggestion")),
        ));
  }

  Widget backButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Image(
          image: AssetImage("assets/images/arrow.png"),
        ),
      ),
    );
  }

  Widget searchBox(context) {
    LocationData provider = Provider.of<LocationData>(context);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xffd9d9d9),
          width: 2,
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Image(
              image: AssetImage("assets/images/search.png"),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 136,
            child: Opacity(
              opacity: 0.50,
              child: TextField(
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    GoogleMapUtil.placeAutocomplete(text).then((value) {
                      setState(() {
                        predictions = value;
                        showSearchItems = true;
                      });
                    });
                  } else {
                    setState(() {
                      showSearchItems = false;
                      predictions = [];
                    });
                  }
                  provider.setCurrentPlace(null);
                },
                controller: searchController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    hintText: "Search Places...",
                    floatingLabelBehavior:
                    FloatingLabelBehavior.never,
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 7)),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget saveButton(context) {
    LocationData provider = Provider.of<LocationData>(context);

    return _auth.currentUser != null ? GestureDetector(
      onTap: () async {
        if (provider.currentPlace == null) { return; }
        var query = await fireStore.collection('places')
            .where('name', isEqualTo: provider.currentPlace!['name'])
            .where('userId', isEqualTo: _auth.currentUser!.uid).get();

        if (query.size > 0) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('This Place Had Already Been Saved.'),
            duration: Duration(seconds: 3), // Change the duration as needed
          ));
          return;
        }

        Map<String, dynamic> data = {
          'userId': _auth.currentUser!.uid,
          'place': provider.currentPlace!,
          'name': provider.currentPlace!['name'],
        };
        fireStore.collection('places').add(data);
        provider.setCurrentPlace(null);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Place Saved.'),
          duration: Duration(seconds: 3), // Change the duration as needed
        ));
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          child: Image.asset(
            'assets/images/save.png',
            height: 50,
            width: 50,
          ),
        ),
      ),
    ) : const SizedBox();
  }

  Widget locButton(context) {
    LocationData provider = Provider.of<LocationData>(context);

    return GestureDetector(
      onTap: () {
        GoogleMapUtil.currentLocation(provider.mapController);
        updateMap(provider, null);
        },
      child: Container(
        width: 70,
        height: 50,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          child: Image.asset(
            'assets/images/locimage.png',
            height: 50,
            width: 50,
          ),
        ),
      ),
    );
  }

  Future<void> updateMap(LocationData provider, Map<String, dynamic>? place) async {
    provider.setRestaurants(getNearbyRestaurants(place));
    provider.setCurrentPlace(place);

    List<double> latLng = await GoogleMapUtil.getLatLng(place);
    provider.setLatLng(latLng);
    provider.setMarker(
        Marker(
        markerId: const MarkerId("current place"),
        position: LatLng(latLng[0], latLng[1]),
        icon:
        BitmapDescriptor.defaultMarker), 0);
  }

}
