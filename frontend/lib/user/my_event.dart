import 'package:aroundu/component/event_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
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
    return Container(
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
      child: ListView(
        children: [
          const Padding(padding: EdgeInsets.all(10)),
          Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: const Text(
                    "My Events",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40
                  )),
                ),
              ),
              FutureBuilder<List<EventInfo>>(
                future: createdEvents,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return MyEvents(createdEvents: snapshot.data!);
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                      width: 100,
                      child: Center(
                        child: Text('No Created Events Currently',
                          style: TextStyle(
                            color: Color.fromARGB(255, 81, 65, 143),
                            fontStyle: FontStyle.italic,
                            fontSize: 20))),
                    );
                  }
                  return const Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator()
                    ),
                  );
                }),
            ],
          ),
          Column(
            children: [
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
              FutureBuilder<List<EventInfo>>(
                future: participatedEvents,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ParticipatedEvents(
                      participatedEvents: snapshot.data!);
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'No Events to participate Currently',
                        style: TextStyle(
                          color: Color.fromARGB(255, 81, 65, 143),
                          fontStyle: FontStyle.italic,
                          fontSize: 20
                        )));
                  }
                  return const SizedBox();
                }),
            ],
          )
    ]));
  }
}

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key, required this.createdEvents})
      : super(key: key);
  final List<EventInfo> createdEvents;

  @override
  State<MyEvents> createState() => _MyEventListState();
}

class _MyEventListState extends State<MyEvents> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _controller,
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
                color: const Color.fromARGB(255, 120, 117, 117).withOpacity(.5),
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
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(children: [
                const Padding(padding: EdgeInsets.all(8)),
                Expanded(
                  flex: 1,
                  child: EventImage(eventId: widget.createdEvents[index].eventId),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.all(8)),
                        Text(
                          widget.createdEvents[index].eventName,
                          style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          )),
                        const Padding(padding: EdgeInsets.all(25)),
                        Column(children: [
                          const Padding( padding: EdgeInsets.all(3)),
                          Row(
                            children: [
                              const Icon(
                                Icons.people_alt_outlined,
                                color: Colors.grey
                              ),
                              Text(" " +
                                widget.createdEvents[index]
                                .currNumParticipants
                                .toString() +
                                " people joined",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 81, 65, 143),
                                  fontWeight:FontWeight.bold,
                                  fontSize: 16
                                ))
                          ]),
                        ])
                        ])))
                ]))));
            });
  }
}

class ParticipatedEvents extends StatelessWidget {
  const ParticipatedEvents({Key? key, required this.participatedEvents})
      : super(key: key);
  final List<EventInfo> participatedEvents;

  String formatDateTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    return sprintf("%02i-%02i %02i:%02i", [dateTime.month, dateTime.day, dateTime.hour, dateTime.minute]);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: participatedEvents.length,
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
                color: const Color.fromARGB(255, 120, 117, 117).withOpacity(.5),
                blurRadius: 20.0, // soften the shadow
                spreadRadius: 0.0, //extend the shadow
                offset: const Offset(5.0,8.0),
              )
            ],
          ),
          child: GestureDetector(
            onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  EventPage(eventId: participatedEvents[index].eventId),
              ),
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                  Expanded(
                    flex: 6,
                    child: EventImage(eventId: participatedEvents[index].eventId)
                  ),
                  const Expanded(
                    flex: 1, 
                    child: SizedBox()
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      participatedEvents[index].eventName,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 81, 65, 143),
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                  ))),
                  Expanded(
                    flex: 1,
                    child: Text(
                      formatDateTime(participatedEvents[index].startTime),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                  )))
                ]),
              ))));
      });
  }
}
