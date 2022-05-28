/// Display the detial information of an event such as event name, location, start time,
/// end time, number of participants, description.
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../main.dart';
import 'package:aroundu/json/event.dart';

/// Get the most up-to-date event info given the event id
/// eventId: the id of the event
Future<EventInfo> fetchEvent(int id) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User has not logged in");
  }

  String token = await user.getIdToken();
  final response =  await http.get(
    Uri(
      host: backendAddress, 
      path: "/event/id", 
      queryParameters: {"eventid": id.toString()}
    ),
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
    body: jsonEncode({
      "event_id": eventId
    })
  );
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
    body: jsonEncode({
      "event_id": eventId
    })
  );
  if (response.statusCode == 200) {
    // After user has joined the event, refesh the event info
    return await fetchEvent(eventId);
  } else {
    throw Exception('Failed to quit event.');
  }
}

class EventPage extends StatefulWidget {
  const EventPage({required this.eventId, Key? key}) : super(key: key);
  final int eventId;
  @override
  EventState createState() => EventState();
}

class EventState extends State<EventPage> {
  late Future<EventInfo> _event;

  @override
  void initState() {
    super.initState();
    _event = fetchEvent(widget.eventId);
  }

  void updateEvent(Future<EventInfo> event){
    setState(() {
      _event = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            const Padding(padding: EdgeInsets.all(15)),
            // back to preview page button
            Row(
              children: [
                const Padding(padding: EdgeInsets.all(5)),
                Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.chevron_left,
                          size: 36,
                          color: Color.fromARGB(255, 81, 65, 143),
                        )))
              ],
            ),
            const SizedBox(height: 4),
            FutureBuilder<EventInfo>(
                future: _event,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return EventDetailHelper(eventInfo: snapshot.data!);
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Event not found',
                            style: TextStyle(
                                color: Color.fromARGB(255, 81, 65, 143),
                                fontStyle: FontStyle.italic,
                                fontSize: 20)));
                  }
                  return const CircularProgressIndicator();
                }),
          ],
        ),
        FutureBuilder<EventInfo>(
          future: _event,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var event = snapshot.data!;
              // Todo add mode full
              var buttonMode = event.currNumParticipants < event.maxParticipants ? EventButtonMode.join : EventButtonMode.leave;
              return Align(
                alignment: Alignment.bottomCenter,
                child: JoinLeaveEventButton(
                  mode: buttonMode, 
                  eventId: event.eventId, 
                  updateEvent: updateEvent
                )
              );
            } else {
              return const SizedBox();
            }
          }
        )
      ],
    ));
  }
}

class EventDetailHelper extends StatefulWidget {
  const EventDetailHelper({Key? key, required this.eventInfo})
      : super(key: key);
  final EventInfo eventInfo;

  @override
  State<EventDetailHelper> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetailHelper> {
  final image = "images/scenary.jpg";
  late EventInfo event = widget.eventInfo;
  bool showMore = false;

  final List<String> participants = [
    "images/scenary.jpg",
    "images/tree.jpg",
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/tree.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        // Event Title
        Row(
          children: [
            const Padding(padding: EdgeInsets.all(16)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(event.eventName,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 81, 65, 143),
                      fontWeight: FontWeight.bold,
                      fontSize: 27)),
            )
          ],
        ),
        // number of spot avaible
        Row(
          children: [
            const Padding(padding: EdgeInsets.all(18)),
            Align(
              alignment: Alignment.topLeft,
              child: event.currNumParticipants >= event.maxParticipants
                  ? const Text("Closed",
                      style: TextStyle(color: Colors.red, fontSize: 15))
                  : Text(
                      (event.maxParticipants - event.currNumParticipants)
                              .toString() +
                          " spots available",
                      style:
                          const TextStyle(color: Colors.green, fontSize: 15)),
            )
          ],
        ),
        // Event images
        Container(
          width: 343,
          height: 150,
          child: Row(
            children: [
              Expanded(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0), //or 15.0
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(image), fit: BoxFit.fill)), // TODO
                ),
              )),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // start time and end time widget
        Row(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            const Align(
                alignment: Alignment.topLeft,
                child: Icon(Icons.access_time_rounded,
                    color: Color.fromARGB(255, 81, 65, 143))),
            const Padding(padding: EdgeInsets.all(5)),
            Column(
              children: [
                Text(event.startTime,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 81, 65, 143),
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                Text(event.endTime,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 81, 65, 143),
                        fontWeight: FontWeight.bold,
                        fontSize: 18))
              ],
            )
          ],
        ),
        const SizedBox(height: 10),
        // number of participant
        Row(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            const Align(
                alignment: Alignment.topLeft,
                child: Icon(Icons.people_alt_outlined,
                    color: Color.fromARGB(255, 81, 65, 143))),
            const Padding(padding: EdgeInsets.all(5)),
            Text(event.currNumParticipants.toString() + " people joined",
                style: const TextStyle(
                    color: Color.fromARGB(255, 81, 65, 143),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const Padding(padding: EdgeInsets.all(12)),
            SizedBox(
                width: 50,
                height: 25,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Align(
                        widthFactor: 0.6,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 12,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundImage: AssetImage(participants[index]),
                          ),
                        ),
                      );
                    })),
            TextButton(
              onPressed: () {
                setState(() {
                  showMore = !showMore;
                });
              },
              child: showMore
                  ? const Text("hide all",
                      style: TextStyle(
                          color: Color.fromARGB(255, 190, 114, 230),
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                          fontSize: 15))
                  : const Text("show all",
                      style: TextStyle(
                          color: Color.fromARGB(255, 190, 114, 230),
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                          fontSize: 15)),
            )
          ],
        ),
        if (showMore)
          SizedBox(
            height: 100.0,
            width: 350,
            child: GridView.builder(
                itemCount: participants.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 8,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage(participants[index]), // TODO
                    ),
                  );
                }),
          ),
        const SizedBox(height: 10),
        // event address
        Row(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            const Align(
                alignment: Alignment.topLeft,
                child: Icon(Icons.location_on_outlined,
                    color: Color.fromARGB(255, 81, 65, 143))),
            const Padding(padding: EdgeInsets.all(5)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Text(event.address,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 81, 65, 143),
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // event description
        Row(
          children: const [
            Padding(padding: EdgeInsets.all(10)),
            Align(
                alignment: Alignment.topLeft,
                child: Icon(Icons.event_note_outlined,
                    color: Color.fromARGB(255, 81, 65, 143))),
            Padding(padding: EdgeInsets.all(5)),
            Text("Event Details",
                style: TextStyle(
                    color: Color.fromARGB(255, 81, 65, 143),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(event.description,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
            )
          ],
        ),
        const Padding(padding: EdgeInsets.all(15)),
      ]),
    );
  }
}

enum EventButtonMode { join, leave, full }

class JoinLeaveEventButton extends StatelessWidget {
  const JoinLeaveEventButton({Key? key, required this.mode, required this.updateEvent, required this.eventId}) : super(key: key);

  final EventButtonMode mode;
  final int eventId;
  final Function updateEvent;

  @override
  Widget build(BuildContext context) {
    var boxShadow = BoxShadow(
      color: const Color.fromARGB(255, 120, 117, 117).withOpacity(.5),
      blurRadius: 20.0, // soften the shadow
      spreadRadius: 0.0, //extend the shadow
      offset: const Offset(5.0, 8.0),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: SizedBox(
          width: 343,
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [boxShadow]
                  ),
                  child: mode == EventButtonMode.full ? 
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 80, 77, 77), 
                            Color.fromARGB(255, 120, 117, 117),
                        ])),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Full",
                          style: TextStyle(
                            color: Color.fromARGB(255, 243, 241, 241),
                            fontWeight:FontWeight.bold,
                            fontSize: 22
                          )))),
                  )
              : ClipRRect(
                borderRadius: BorderRadius.circular(20.0), //or 15.0
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: mode == EventButtonMode.leave ?
                        [
                          const Color(0xffff1fa7),
                          const Color.fromARGB(255, 172, 115, 248),
                        ]
                        : 
                        [
                          const Color.fromARGB(255, 81, 65, 143),
                          const Color.fromARGB(255, 172, 115, 248)
                        ],
                    )
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all(Colors.transparent),
                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: mode == EventButtonMode.leave ? 
                    const Text("Leave Event",
                      style: TextStyle(
                        color:Color.fromARGB(255,243,241,241),
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                      ))
                    : 
                    const Text(
                      "Join Event",
                      style: TextStyle(
                        color:Color.fromARGB(255,243,241,241),
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                    )),
                    onPressed: () {
                      if (mode == EventButtonMode.join) {
                        updateEvent(joinEvent(eventId));
                      } else {
                        updateEvent(quitEvent(eventId));
                      }
                    },
                  ))),
          ),
        ),
      ],
    )));
  }
}