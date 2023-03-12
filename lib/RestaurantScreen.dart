import 'package:flutter/material.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  late double width;
  late double safeHeight;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    var padding = MediaQuery
        .of(context)
        .viewPadding;

    safeHeight = height - padding.top - padding.bottom;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: safeHeight / 2,
                  width: width,
                  child: const FittedBox(
                    fit: BoxFit.fill,
                    child: Image(
                      image: AssetImage("images/bigBurger.png"),
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
                          const Text(
                            "Best Burger",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Description",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Most delicious burgers in this town its so good, very nutritious and juicy and good and makes you happy when you eat it.",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Location",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Bangplad Bangkok Thailand",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "More info",
                              style: TextStyle(
                                color: Color(0xffea3f30),
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
                  Container(
                    width: 80,
                    height: 50,
                    padding: const EdgeInsets.only(left: 30),
                    decoration: BoxDecoration(
                      // color: Colors.pink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.fill,
                      child: Image(
                        image: AssetImage("images/arrow.png"),
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 60,
                    padding: const EdgeInsets.only(right: 30, top: 10),
                    decoration: BoxDecoration(
                      // color: Colors.pink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.fill,
                      child: Image(
                        image: AssetImage("images/redFavorite.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
