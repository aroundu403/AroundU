// This file contains the functions that call the backend APIs.
import '../json/event.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'dart:convert';

// fetch the list of event from the backend API
Future<List<EventInfo>> fetchEvents() async {
    final response = await http.get(
      Uri(host: backendAddress, path: "/event/list"),
    );

    if (response.statusCode == 200) {
      var jsonEvents = jsonDecode(response.body)['data'] as List;
      // prase the json strings into event objects
      return jsonEvents.map((event) => EventInfo.fromJson(event)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load events');
    }
  }