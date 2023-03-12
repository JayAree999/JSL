import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late double width;
  late double safeHeight;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;

    safeHeight = height - padding.top - padding.bottom;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: safeHeight / 3 * 2,
                  width: width,
                  child: const FittedBox(
                    fit: BoxFit.fill,
                    child: Image(
                      image: AssetImage("assets/images/map.png"),
                    ),
                  ),
                ),
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
                              image: AssetImage("assets/images/bigSearch.png"),
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
                        height: safeHeight/3-80,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              listItem(),
                              const SizedBox(
                                height: 10,
                              ),
                              listItem(),
                              const SizedBox(
                                height: 10,
                              ),
                              listItem(),
                              const SizedBox(
                                height: 10,
                              ),
                              listItem(),
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
              top: safeHeight/3 * 2 - 45,
              left: 25,
              child: Container(
                width: width-50,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Image(
                      image: AssetImage("assets/images/arrow.png"),
                    ),
                  ),
                  Container(
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
                        const SizedBox(
                          width: 136,
                          child: Opacity(
                            opacity: 0.50,
                            child: Text(
                              "Search Places...",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Image(
                      image: AssetImage("assets/images/save.png"),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 70,
                height: 50,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Image(
                  image: AssetImage("assets/images/location.png"),
                ),
              ),
              Container(height: 50)
            ],
          ),
        ],
      ),
    );
  }

  Widget listItem() {
    return Container(
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
                    image:
                    AssetImage("assets/images/burger1.png"),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start,
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
    );
  }
}
