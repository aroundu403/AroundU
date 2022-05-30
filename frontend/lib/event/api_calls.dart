// This file contains the functions that call the backend APIs.
import 'package:firebase_auth/firebase_auth.dart';

import '../json/event.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'dart:convert';

// fetch the list of events from the backend API
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

// fetch the list of events that this user signed up for 
Future<List<EventInfo>> fetchUserParticipatedEvent() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User has not logged in");
  }

  String token = await user.getIdToken();
  final response = await http.get(
    Uri(
      host: backendAddress,
      path: "/event/guest",
    ),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
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

// get the list of events that were created by this user
Future<List<EventInfo>> fetchUserCreatedEvent() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User has not logged in");
  }

  String token = await user.getIdToken();
  final response = await http.get(
    Uri(
      host: backendAddress,
      path: "/event/created",
    ),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
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