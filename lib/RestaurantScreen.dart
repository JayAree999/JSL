import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_local/ApiServices/RestaurantUtil.dart';
import 'package:eat_local/LocalDatabase/RestaurantDatabse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantScreen({Key? key, required this.restaurant})
      : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  late double width;
  late double safeHeight;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;

    safeHeight = height - padding.top - padding.bottom;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: getRestaurantDetail(
              widget.restaurant.branchId.toStringAsFixed(0)),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xffea3f30)));
            }

            Map<String, dynamic>? restaurantDetail = snapshot.data!;

            return Stack(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: safeHeight / 2,
                      width: width,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Image.network(
                          widget.restaurant.image,
                          errorBuilder: (context, object, stackTrace) {
                            return Container(
                                color: const Color(0xffea3f30),
                                width: 65,
                                height: 65,
                                child: const Icon(Icons.restaurant));
                          },
                        ),
                      ),
                    ),
                    allButtons(),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: safeHeight / 2 - 22,
                    ),
                    Container(
                      width: width,
                      height: safeHeight / 2 + 22,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.restaurant.title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                ),
                              ),
                              getInfoByField(
                                  restaurantDetail, 'menu_q', 'Menus'),
                              getInfoByField(restaurantDetail, 'product_q',
                                  'Qualified Ingredients'),
                              getInfoByField(
                                  restaurantDetail, 'address', 'Location'),
                              getInfoByField(
                                  restaurantDetail, 'tel', 'Contact'),
                              getInfoByField(
                                  restaurantDetail, 'opentime', 'Open Hours'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getInfoByField(
      Map<String, dynamic> restaurantDetail, String field, String name) {
    return restaurantDetail.containsKey(field) &&
            restaurantDetail[field].toString().isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                restaurantDetail[field],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
            ],
          )
        : const SizedBox();
  }

  Widget allButtons() {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 80,
                      height: 50,
                      padding: const EdgeInsets.only(left: 30),
                      decoration: BoxDecoration(
                        // color: Colors.pink,
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
                      child: const FittedBox(
                        fit: BoxFit.fill,
                        child: Image(
                          image: AssetImage("assets/images/arrow.png"),
                        ),
                      ),
                    ),
                  ),
                  _auth.currentUser != null
                      ? GestureDetector(
                          onTap: () async {
                            User? currentUser = _auth.currentUser;

                            var query = await fireStore
                                .collection('restaurants')
                                .where('name',
                                    isEqualTo: widget.restaurant.title)
                                .where('userId',
                                    isEqualTo: _auth.currentUser!.uid)
                                .get();

                            if (query.size > 0) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    'This Restaurant Had Already Been Saved.'),
                                duration: Duration(
                                    seconds:
                                        3), // Change the duration as needed
                              ));
                              return;
                            }

                            Map<String, dynamic> data = {
                              'userId': currentUser!.uid,
                              'restaurant': widget.restaurant.toJson(),
                              'name': widget.restaurant.title
                            };
                            fireStore.collection('restaurants').add(data);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Restaurant Saved.'),
                              duration: Duration(
                                  seconds: 3), // Change the duration as needed
                            ));
                          },
                          child: Container(
                            width: 80,
                            height: 60,
                            padding: const EdgeInsets.only(right: 30, top: 10),
                            decoration: BoxDecoration(
                              // color: Colors.pink,
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
                            child: const FittedBox(
                              fit: BoxFit.fill,
                              child: Image(
                                image:
                                    AssetImage("assets/images/redFavorite.png"),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
