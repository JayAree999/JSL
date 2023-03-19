import 'dart:convert';
import 'dart:ffi';

import 'NetworkUtil.dart';

String appID = 'c73ea968';
String apiKey = '001203d4dd20065bf95a470feb5e1b84';

Future<String> fetchData(String query) async {
  Uri uri = Uri.https(
      "api.edamam.com",
      "/api/food-database/v2/parser",
      {
        "app_id": appID,
        "app_key": apiKey,
        "ingr": query,
        "nutrition-type": "cooking",
        "category": "generic-meals"
      }
  );

  String? response = await NetworkUtil.fetchUrl(uri);

  if (response != null) {
    var responseData = json.decode(response);
    var nutrientsMap = responseData["hints"][0]["food"]["nutrients"];
    final results = nutrientsMap["ENERC_KCAL"] as String;
    return results;
  }
  return "Error";
}