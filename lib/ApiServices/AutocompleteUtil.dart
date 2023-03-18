import 'dart:convert';

class AutocompletePrediction {
  final String? description;
  final String? placeId;

  AutocompletePrediction({this.description, this.placeId});

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['description'] as String?,
      placeId: json['place_id'] as String?,
    );
  }
}

class AutoCompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;

  AutoCompleteResponse({this.status, this.predictions});

  factory AutoCompleteResponse.fromJson(Map<String, dynamic> json) {
    return AutoCompleteResponse(
      status: json['status'] as String?,
      predictions: json['predictions'] != null
          ? json['predictions']
              .map<AutocompletePrediction>(
                  (json) => AutocompletePrediction.fromJson(json))
              .toList()
          : null,
    );
  }

  static AutoCompleteResponse parseAutocomplete(String responseBody) {
    final parsed = json.decode(responseBody);
    return AutoCompleteResponse.fromJson(parsed);
  }
}
