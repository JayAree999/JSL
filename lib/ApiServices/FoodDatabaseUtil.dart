import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'NetworkUtil.dart';

String appID = dotenv.env['FOOD_APP_ID']!;
String apiKey = dotenv.env['FOOD_API_KEY']!;

Future fetchData(String query) async {
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

  try {
    String? response = await NetworkUtil.fetchUrl(uri);

    if (response != null) {
      var responseData = json.decode(response);
      var nutrientsMap = responseData["hints"][0]["food"]["nutrients"];
      final results = nutrientsMap["ENERC_KCAL"];
      return results;
    }

  } catch (e) {
    return 0.0;
  }
}