/// This is a helper data provider class that fetches data from Google Map Place API
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../json/place.dart';

class PlaceApiProvider {
  PlaceApiProvider();

  // get api key from env config file
  static String apiKey = dotenv.env['apiKeyMap']!;
  // we need this proxy server to add cors header to the response returned by Google Place API.
  static String corsProxy = "cors-anywhere.herokuapp.com";
  static String googleAPIHost = "maps.googleapis.com";

  final String host = kIsWeb ? corsProxy : googleAPIHost;
  final String pathPrefix = kIsWeb ? "/https://" + googleAPIHost : "";

  // Get list of auto-complete suggestions of places based on user input
  Future<List<AddressSuggestion>> fetchSuggestions(String input) async {
    final response = await http.get(
      Uri(
        scheme: "https",
        host: host,
        path: pathPrefix + "/maps/api/place/autocomplete/json",
        queryParameters: {
          "input": input,
          "key": apiKey,
          "language": "en",
          "region": "us",
          "longitdue": "-122.303200",
          "latitude": "47.655548",
        }),
      headers: {"X-Requested-With": "XMLHttpRequest"});

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<AddressSuggestion>((p) => AddressSuggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  /// Get the detailed place information based on place ID.
  Future<Place> getPlaceDetailFromId(String placeId) async {
    final response = await http.get(
      Uri(
        scheme: "https",
        host: host,
        path: pathPrefix + "/maps/api/place/details/json",
        queryParameters: {
          "place_id": placeId,
          "key": apiKey,
        }
      ),
      headers: {"X-Requested-With": "XMLHttpRequest"}
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return Place.fromJson(result['result']);
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}