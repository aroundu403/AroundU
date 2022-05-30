// This file contains the functions that call the backend APIs.
import 'package:firebase_auth/firebase_auth.dart';

import '../json/event.dart';
import 'package:http/http.dart' as http;
import '../json/user.dart';
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

/// Get the most up-to-date event info given the event id
/// eventId: the id of the event
Future<EventInfo> fetchEvent(int id) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User has not logged in");
  }

  String token = await user.getIdToken();
  final response = await http.get(
    Uri(
        host: backendAddress,
        path: "/event/id",
        queryParameters: {"eventid": id.toString()}),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    return EventInfo.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load event');
  }
}

/// Add the user to the event participiant list and return the up-to-date event info
/// eventId: the id of the event that this user is joining
/// throws execption when fail to join event or encounter network errors
Future<EventInfo> joinEvent(int eventId) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User has not logged in");
  }

  String token = await user.getIdToken();
  final response = await http.post(
      Uri(
        host: backendAddress,
        path: "/event/guest",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"event_id": eventId}));
  if (response.statusCode == 200) {
    return fetchEvent(eventId);
  } else {
    throw Exception('Failed to update event.');
  }
}

/// remove the user to the event participiant list and return the up-to-date event info
/// eventId: the id of the event that this user is leaving
/// throws execption when fail to leave event or encounter network errors
Future<EventInfo> quitEvent(int eventId) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User has not logged in");
  }

  String token = await user.getIdToken();
  final response = await http.delete(
      Uri(
        host: backendAddress,
        path: "/event/guest",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"event_id": eventId}));
  if (response.statusCode == 200) {
    // After user has joined the event, refesh the event info
    return await fetchEvent(eventId);
  } else {
    throw Exception('Failed to quit event.');
  }
}

// Get the user name and email form the backend APi
Future<UseInfo> fetchUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User has not logged in");
  }

  String token = await user.getIdToken();
  final response =
      await http.get(Uri(host: backendAddress, path: "/user"), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return UseInfo.fromJson(jsonDecode(response.body)["data"]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load event');
  }
}