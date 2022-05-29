/// Display the events in list view with event title and image.
import 'package:aroundu/component/event_image.dart';
import 'package:aroundu/component/image_upload.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../auth/auth_service.dart';
import '../main.dart';
import 'dart:convert';
import 'package:aroundu/json/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'event_detail.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ListViewHome extends StatefulWidget {
  ListViewHome({Key? key}) : super(key: key);

  @override
  State<ListViewHome> createState() => _ListViewHomeState();
}

class _ListViewHomeState extends State<ListViewHome> {
  final List<String> participant = [
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg"
  ];

  late Future<List<EventInfo>> _events;
  @override
  void initState() {
    super.initState();
    _events = _fetchEvents();
  }

  // fetch the list of event from the backend API
  Future<List<EventInfo>> _fetchEvents() async {
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
            Color.fromARGB(255, 197, 240, 207),
            Color.fromARGB(255, 163, 232, 236),
          ],
        )),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(30)),
                const Text("Event List",
                style: TextStyle(
                  color: Color.fromARGB(255, 81, 65, 143),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 36)),
            // build the list view once the event list data arrives
              FutureBuilder<List<EventInfo>>(
                future: _events,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return EventList(events: snapshot.data!);
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('No Events Posted Currently',
                        style: TextStyle(
                          color: Color.fromARGB(255, 81, 65, 143),
                          fontStyle: FontStyle.italic,
                          fontSize: 20)));
                  }
                  return const CircularProgressIndicator();
                }),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: const Text("Sign out"),
            )
                    ])),
        ));
  }
}

class EventList extends StatefulWidget {
  const EventList({Key? key, required this.events}) : super(key: key);
  final List<EventInfo> events;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {

  final ScrollController _controller = ScrollController();
  final ScrollPhysics _physics = const ClampingScrollPhysics();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: ListView.builder(
        controller: _controller,
        physics: _physics,
        itemCount: widget.events.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (buildContext, index) {
          return Container(
            margin: const EdgeInsets.all(8),
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventPage(eventId: 15), //eventId: widget.events[index].eventId),
                ),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 140),
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 12, right: 12),
                    child: EventCardLayout(
                      eventInfo: widget.events[index],
                    ),
                  ),
                ))));
        }),
  );
}
}

class EventCardLayout extends StatefulWidget {
const EventCardLayout(
    {Key? key, required this.eventInfo})
    : super(key: key);

final EventInfo eventInfo;

@override
State<EventCardLayout> createState() => _EventCardLayoutState();
}

class _EventCardLayoutState extends State<EventCardLayout> {
@override
Widget build(BuildContext context) {
  return Row(
    children: [
    Expanded(
      flex: 2,
      child: EventImage(eventId: widget.eventInfo.eventId)
    ),
    const SizedBox(width: 4),
    Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.eventInfo.eventName,
              overflow: TextOverflow.clip,
              style: const TextStyle(
                color: Color.fromARGB(255, 81, 65, 143),
                fontWeight: FontWeight.bold,
                fontSize: 18)
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.location_pin,
                color: Color.fromARGB(255, 81, 65, 143)
              ),
              Expanded(
                child: Text(
                  widget.eventInfo.address,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 81, 65, 143),
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),
                ),
              )
          ]),
          const SizedBox(height: 10),
          SizedBox(
            width: 300.0,
            child: widget.eventInfo.participantIds.length > 0 ?
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.eventInfo.participantIds.length,
                  itemBuilder: (context,index1) {
                    return const Align(
                      widthFactor: 0.6,
                      child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage("images/tree.jpg"),
                      ),
                    ),
                  );
                  }
                )
            )
            : const SizedBox()
          )
          ]))
    ]);
  }
}
