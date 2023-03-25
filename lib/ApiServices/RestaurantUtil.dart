import 'dart:convert';
import 'package:eat_local/LocalDatabase/RestaurantDatabse.dart';

import 'GoogleMapUtil.dart';
import 'NetworkUtil.dart';

Future<List<Map<String, dynamic>>> getRestaurantList() async {
  List<Map<String, dynamic>> restaurantList = [];
  const pageNumber = 43;

  for (var page = 1; page <= pageNumber; page++) {
    List<Map<String, dynamic>> tempList = [];
    Uri uri = Uri.http("www.qrestaurant.acfs.go.th", "webapp/api/shop.php", {
      "secret": "BกVฮdบBEwqภQR89พด9Lอย4ย4คษร5กVรi",
      "page": page.toString()
    });

    String? response = await NetworkUtil.fetchUrl(uri);

    if (response != null) {
      var responseData = json.decode(utf8.decode(response.codeUnits));
      var restaurantList = responseData["data"];
      for (var restaurant in restaurantList) {
        var requiredData = {
          "title": restaurant["title"],
          "branch_id": restaurant["branch_id"],
          "latitude": restaurant["latitude"],
          "longitude": restaurant["longitude"],
          "image": restaurant["image"],
        };

        tempList.add(requiredData);
      }
    }

    restaurantList.addAll(tempList);
  }

  return restaurantList;
}

void saveRestaurants() {
  final db = RestaurantDB.instance;
  db.isTableEmpty().then((empty) => {
        if (empty) {
          getRestaurantList()
              .then((restaurants) => {db.insertAll(restaurants)})
          }
      });
}

Future<List<Restaurant>> getNearbyRestaurants(Map<String, dynamic>? startingPlace) async {
  final db = RestaurantDB.instance;

  List<double> latLng = await GoogleMapUtil.getLatLng(startingPlace);

  double lat = latLng[0];
  double lng = latLng[1];

  return db.getRestaurantsInRange(lat, lng);
}

Future<Map<String, dynamic>?> getRestaurantDetail(String branchId) async {
  Uri uri = Uri.http("www.qrestaurant.acfs.go.th", "webapp/api/shop_detail.php", {
    "secret": "BกVฮdบBEwqภQR89พด9Lอย4ย4คษร5กVรi",
    "id": branchId
  });

  String? response = await NetworkUtil.fetchUrl(uri);

  if (response != null) {
    var data = json.decode(utf8.decode(response.codeUnits));
    return data;
  }

  return null;
}