/// Display the detial information of an event such as event name, location, start time,
/// end time, number of participants, description.
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:async';
import '../main.dart';
import 'package:aroundu/json/event.dart';

Future<EventInfo> fetchEvent() async {
  final response = await http.get(
    Uri(host: backendAddress, path: "/event/list"),
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return EventInfo.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load event');
  }
}

// Future<Event> createEvent(String title) async {
//   final response = await http.post(
//     Uri.parse('https://aroundu-403.uw.r.appspot.com/'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'event_name': title,
//     }),
//   );

//   if (response.statusCode == 201) {
//     // If the server did return a 201 CREATED response,
//     // then parse the JSON.
//     return Event.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to create event.');
//   }
// }

// class Event {
//   // final int userId;
//   // final int id;
//   // final String title;

//   final int event_id;
//   final String event_code;
//   final String event_name;
//   final String description;
//   final String host_id;
//   final int isPublic; // 1 for public, 0 for private
//   final int isDeleted; // 1 for deleted, 0 for not deleted

// final String location_name;
// final double latitude;
// final double longitude;
// final int max_participants;
// final int curr_num_participants;

// final String photoID;
// final String icon;
// final String address;

// final String start_time;
// final String end_time;
// final String created_at;
// final String deleted_at;
// final String updated_at;

// const Event({
//   // required this.userId,
//   // required this.id,
//   // required this.title,
//   required this.event_id,
//   required this.event_code,
//   required this.event_name,
//   required this.description,
//   required this.host_id,
//   required this.isPublic, // 1 for public, 0 for private
//   required this.isDeleted, // 1 for deleted, 0 for not deleted

//   required this.location_name,
//   required this.latitude,
//   required this.longitude,
//   required this.max_participants,
//   required this.curr_num_participants,
//   required this.photoID,
//   required this.icon,
//   required this.address,
//   required this.start_time,
//   required this.end_time,
//   required this.created_at,
//   required this.deleted_at,
//   required this.updated_at,
// });

// factory Event.fromJson(Map<String, dynamic> json) {
//   return Event(
//     // userId: json['userId'],
//     // id: json['id'],
//     // title: json['title'],

//     event_id: json['event_id'],
//     event_code: json['event_code'],
//     event_name: json['event_name'],
//     description: json['description'],
// host_id: json['host_id'],
// isPublic: json['isPublic'], // 1 for public, 0 for private
// isDeleted: json['isDeleted'], // 1 for deleted, 0 for not deleted

// location_name: json['location_name'],
// latitude: json['latitude'],
// longitude: json['longitude'],
// max_participants: json['max_participants'],
// curr_num_participants: json['curr_num_participants'],

// photoID: json['photoID'],
// icon: json['icon'],
// address: json['address'],
// start_time: json['start_time'],
// end_time: json['end_time'],
// created_at: json['created_at'],
// deleted_at: json['deleted_at'],
// updated_at: json['updated_at'],
//     );
//   }
// }

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  EventState createState() => EventState();
}

class EventState extends State<EventPage> {
  late Future<EventInfo> futureEvent;
  @override
  void initState() {
    super.initState();
    futureEvent = fetchEvent();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EventInfo>(
        future: futureEvent,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return EventDetailHelper(eventInfo: snapshot.data!);
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('No Events Posted Currently',
                    style: TextStyle(
                        color: Color.fromARGB(255, 81, 65, 143),
                        fontStyle: FontStyle.italic,
                        fontSize: 20)));
          }
          return const CircularProgressIndicator();
        });
  }

  // */
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Fetch Data Example',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Fetch Data Example'),
  //       ),
  //       body: Center(
  //         child: FutureBuilder<Event>(
  //           future: futureEvent,
  //           builder: (context, snapshot) {
  //             if (snapshot.hasData) {
  //               return Text(snapshot.data!.event_name);
  //             } else if (snapshot.hasError) {
  //               return Text('${snapshot.error}');
  //             }

  //             // By default, show a loading spinner.
  //             return const CircularProgressIndicator();
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
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
  // final int capacity = 7;
  bool joinedIn = false;
  int size = 5;
  bool show = false;
  // @override
  // void initState() {
  //   EventInfo event = widget.eventInfo;
  // }

  late EventInfo event = widget.eventInfo;

  final List<String> participants = [
    "images/scenary.jpg",
    "images/tree.jpg",
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/tree.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: [
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
              // Event Title
              Row(
                children: [
                  const Padding(padding: EdgeInsets.all(16)),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(event.event_name,
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
                    child: event.max_participants >= event.curr_num_participants
                        ? const Text("Closed",
                            style: TextStyle(color: Colors.red, fontSize: 15))
                        : Text(
                            (event.curr_num_participants -
                                        event.max_participants)
                                    .toString() +
                                " spots available",
                            style: const TextStyle(
                                color: Colors.green, fontSize: 15)),
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
                                image: AssetImage(image),
                                fit: BoxFit.fill)), // TODO
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
                      Text(event.start_time,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 81, 65, 143),
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      Text(event.end_time,
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
                  Text(
                      event.curr_num_participants.toString() + " people joined",
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
                                  backgroundImage:
                                      AssetImage(participants[index]),
                                ),
                              ),
                            );
                          })),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        show = !show;
                      });
                    },
                    child: show
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
              if (show)
                SizedBox(
                  height: 100.0,
                  width: 350,
                  child: GridView.builder(
                      itemCount: participants.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                            backgroundImage:
                                AssetImage(participants[index]), // TODO
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
                  Text(event.address,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 81, 65, 143),
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
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
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16)),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.all(15)),
            ]),
          )),
      bottomNavigationBar: SizedBox(
          width: 343,
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 120, 117, 117)
                            .withOpacity(.5),
                        blurRadius: 20.0, // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: const Offset(
                          5.0, // Move to right 10  horizontally
                          8.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: !joinedIn &&
                          event.max_participants >= event.curr_num_participants
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20.0), //or 15.0
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
                                  child: Text("Full",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 243, 241, 241),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)))),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20.0), //or 15.0
                          child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: joinedIn
                                    ? [
                                        const Color(0xffff1fa7),
                                        const Color.fromARGB(
                                            255, 172, 115, 248),
                                      ]
                                    : [
                                        const Color.fromARGB(255, 81, 65, 143),
                                        const Color.fromARGB(255, 172, 115, 248)
                                      ],
                              )),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  shadowColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: joinedIn
                                    ? const Text("Leave Event",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 243, 241, 241),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22))
                                    : const Text("Join Event",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 243, 241, 241),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22)),
                                onPressed: () {
                                  setState(() {
                                    if (joinedIn) {
                                      size--; // TODO
                                    } else {
                                      size++; // TODO
                                    }
                                    joinedIn = !joinedIn;
                                  });
                                },
                              ))),
                ),
              ),
            ],
          )),
    );
  }
}
