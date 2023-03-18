import 'package:eat_local/main.dart';
import 'package:flutter/material.dart';
import 'ApiServices/AutocompleteUtil.dart';
import 'DimissKeyboard.dart';
import 'ApiServices/GoogleMapUtil.dart';

class LocationScreen extends StatefulWidget {
  final Map<String, dynamic>? startingPlace;
  const LocationScreen({Key? key, required this.startingPlace}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // For fitting the screen
  late double width;
  late double safeHeight;

  // Controller for text field
  final TextEditingController searchController = TextEditingController();

  // For search autocomplete
  bool showSearchItems = false;
  List<AutocompletePrediction> predictions = [];

  // Current place
  Map<String, dynamic>? currentPlace;

  @override
  void dispose() {
    searchController.dispose();
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
                          future: googleMap(widget.startingPlace),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data;
                            }
                            return const Text("loading...");
                          },
                        )),
                    allButtons(),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: safeHeight / 3 * 2 - 30,
                    ),
                    Container(
                      width: width,
                      height: safeHeight / 3 + 30,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Image(
                                  image:
                                      AssetImage("assets/images/bigSearch.png"),
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                              Container(
                                width: 256,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  color: const Color(0xfffffcfc),
                                ),
                                child: const Center(
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text(
                                      "Select Distance",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: safeHeight / 3 - 80,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  listItem(context),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  listItem(context),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  listItem(context),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  listItem(context),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget allButtons() {
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

    Widget searchBox() {
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
                      placeAutocomplete(text).then((value) {
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
                    currentPlace = null;
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

    Widget saveButton() {
      return GestureDetector(
        onTap: () {
          if (currentPlace == null) { return; }
          MyApp.fireStore.collection('places').add(currentPlace!);
          currentPlace = null;
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
      );
    }

    Widget locButton() {
      return GestureDetector(
        onTap: currentLocation,
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

    return SizedBox(
      height: safeHeight / 3 * 2,
      width: width,
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
                  searchBox(),
                  saveButton()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [searchItems()],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              locButton(),
              Container(height: 50)
            ],
          ),
        ],
      ),
    );
  }

  Widget listItem(context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/restaurant"),
      child: Container(
        height: 65,
        width: width - 30,
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
            Row(
              children: [
                const SizedBox(
                  width: 65,
                  height: 65,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image(
                      image: AssetImage("assets/images/burger1.png"),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(
                      width: 70,
                      height: 20,
                      child: Text(
                        "Best Burger",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.50,
                      child: Text(
                        "2.5km",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              width: 60,
              height: 40,
              child: Image(
                image: AssetImage("assets/images/favorite.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchItems() {
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
                      final placeDetails = await getPlaceDetails(predictions[index].placeId!);
                      if (placeDetails == null) { return; }

                      // Move Camera
                      final location = placeDetails['geometry']['location'];
                      changeLocation(location['lat'], location['lng']);

                      // Hide suggestion box
                      setState(() {
                        showSearchItems = false;
                        currentPlace = placeDetails;
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
}
