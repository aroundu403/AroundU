import 'package:aroundu/json/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import '../event/event_detail.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'package:aroundu/json/event.dart';

import 'dart:convert';

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

class MyEventPage extends StatefulWidget {
  const MyEventPage({Key? key}) : super(key: key);

  @override
  MyEventState createState() => MyEventState();
}

class MyEventState extends State<MyEventPage> {
  final ScrollController _controller = ScrollController();
  final ScrollPhysics _physics = const ClampingScrollPhysics();

  late Future<List<EventInfo>> participatedEvents;
  late Future<List<EventInfo>> createdEvents;
  @override
  void initState() {
    super.initState();
    participatedEvents = fetchUserParticipatedEvent();
    createdEvents = fetchUserCreatedEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // ignore: prefer_const_literals_to_create_immutables
            colors: [
              Color.fromARGB(255, 81, 65, 143),
              Color.fromARGB(255, 92, 74, 210),
              Color.fromARGB(210, 112, 188, 236),
            ],
          )),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(15)),
              // back to preview page button
              Row(children: [
                const Padding(padding: EdgeInsets.all(5)),
                Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.chevron_left,
                          size: 36,
                          color: Colors.white,
                        )))
              ]),
              const Padding(padding: EdgeInsets.all(5)),

              FutureBuilder<List<EventInfo>>(
                  future: createdEvents,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CreatedEvents(createdEvents: snapshot.data!);
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text('No Created Events Currently',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 81, 65, 143),
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20)));
                    }
                    return const CircularProgressIndicator();
                  }),
              FutureBuilder<List<EventInfo>>(
                  future: participatedEvents,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ParticipatedEvents(
                          participatedEvents: snapshot.data!);
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text('No Events to participate Currently',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 81, 65, 143),
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20)));
                    }
                    return const CircularProgressIndicator();
                  }),
            ],
          ),
        )
      ],
    )));
  }
}

class CreatedEvents extends StatefulWidget {
  const CreatedEvents({Key? key, required this.createdEvents})
      : super(key: key);
  final List<EventInfo> createdEvents;

  @override
  State<CreatedEvents> createState() => _CreatedEventListState();
}

class _CreatedEventListState extends State<CreatedEvents> {
  final List<String> images = [
    "images/scenary.jpg",
    "images/scenary_red.jpg",
    "images/waterfall.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg"
  ];

  final ScrollController _controller = ScrollController();
  final ScrollPhysics _physics = const ClampingScrollPhysics();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: const [
          Padding(padding: EdgeInsets.all(16)),
          Align(
            alignment: Alignment.topLeft,
            child: Text("My Created Events",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40)),
          ),
          Padding(padding: EdgeInsets.only(right: 230)),
          Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.access_alarm_outlined,
                color: Color(0xff8DFFF2), size: 40),
          )
        ],
      ),
      SizedBox(
          height: 400,
          child: ListView.builder(
              controller: _controller,
              physics: _physics,
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              itemCount: widget.createdEvents.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (buildContext, index) {
                return Container(
                    margin: const EdgeInsets.all(8),
                    width: 343,
                    height: 150,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 120, 117, 117)
                              .withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: const Offset(
                            5.0,
                            8.0,
                          ),
                        )
                      ],
                    ),
                    child: GestureDetector(
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventPage(
                                  eventId: widget.createdEvents[index].eventId,
                                ),
                              ),
                            ),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(35), // if you need this
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(children: [
                              const Padding(padding: EdgeInsets.all(8)),
                              Expanded(
                                  child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(15.0), //or 15.0
                                child: Container(
                                  height: 110.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(images[
                                              index]), // TODO image process
                                          fit: BoxFit.fill)),
                                ),
                              )),
                              const Padding(padding: EdgeInsets.all(8)),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                                padding: EdgeInsets.all(5)),
                                            Text(
                                                widget.createdEvents[index]
                                                    .eventName,
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 81, 65, 143),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                            const Padding(
                                                padding: EdgeInsets.all(30)),
                                            Column(children: [
                                              const Padding(
                                                  padding: EdgeInsets.all(3)),
                                              Row(children: [
                                                const Icon(
                                                    Icons.people_alt_outlined,
                                                    color: Colors.grey),
                                                Text(
                                                    " " +
                                                        widget
                                                            .createdEvents[
                                                                index]
                                                            .currNumParticipants
                                                            .toString() +
                                                        " people joined",
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 81, 65, 143),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16))
                                              ]),
                                              // const Padding(
                                              //     padding:
                                              //         EdgeInsets.all(3)),
                                            ])
                                          ])))
                            ]))));
              })),
      const Padding(padding: EdgeInsets.all(5))
    ]);
  }
}

class ParticipatedEvents extends StatefulWidget {
  const ParticipatedEvents({Key? key, required this.participatedEvents})
      : super(key: key);
  final List<EventInfo> participatedEvents;

  @override
  State<ParticipatedEvents> createState() => _ParticipatedEventListState();
}

class _ParticipatedEventListState extends State<ParticipatedEvents> {
  final List<String> images = [
    "images/scenary.jpg",
    "images/scenary_red.jpg",
    "images/waterfall.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg"
  ];

  final ScrollController _controller = ScrollController();
  final ScrollPhysics _physics = const ClampingScrollPhysics();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: const [
          Padding(padding: EdgeInsets.all(16)),
          Align(
            alignment: Alignment.topLeft,
            child: Text("Upcoming Events",
                style: TextStyle(
                    color: Color(0xff8DFFF2),
                    fontWeight: FontWeight.bold,
                    fontSize: 28)),
          ),
        ],
      ),
      SizedBox(
            height: 400,
            child: GridView.builder(
                controller: _controller,
                physics: _physics,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.participatedEvents.length,
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 120, 117, 117)
                                .withOpacity(.5),
                            blurRadius: 20.0, // soften the shadow
                            spreadRadius: 0.0, //extend the shadow
                            offset: const Offset(
                              5.0,
                              8.0,
                            ),
                          )
                        ],
                      ),
                      child: GestureDetector(
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EventPage(eventId: 3),
                                ),
                              ),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25), // if you need this
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Column(children: [
                                const Padding(padding: EdgeInsets.all(8)),
                                Row(children: [
                                  const Padding(padding: EdgeInsets.all(8)),
                                  Expanded(
                                      child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(10.0), //or 15.0
                                    child: Container(
                                      height: 130,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(images[
                                                  index]), // TODO: image process
                                              fit: BoxFit.fill)),
                                    ),
                                  )),
                                  const Padding(padding: EdgeInsets.all(8)),
                                ]),
                                const Padding(padding: EdgeInsets.all(8)),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(children: [
                                          Text(
                                              widget.participatedEvents[index]
                                                  .eventName,
                                              style:
                                                  const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 81, 65, 143),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18)),
                                          Text(
                                              widget.participatedEvents[index]
                                                  .startTime,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16)),
                                        ])))
                              ]))));
                }),
          )
    ]);
  }
}
