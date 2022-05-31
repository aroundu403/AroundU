/// Display the event detail information on a single page
import 'package:aroundu/component/event_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sprintf/sprintf.dart';
import 'dart:async';
import 'package:aroundu/json/event.dart';
import 'api_calls.dart';

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

  void refreshEvent() {
    setState(() {
      _event = fetchEvent(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
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
        ),
        FutureBuilder<EventInfo>(
            future: _event,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var event = snapshot.data!;
                // if this event isn't create by this user, show the button
                if (FirebaseAuth.instance.currentUser!.uid != event.hostId) {
                  List<String> participants = event.participantIds;
                  User? user = FirebaseAuth.instance.currentUser;

                  var userJoined = participants.contains(user?.uid);
                  EventButtonMode buttonMode;
                  // if user has joined this event, then the button will be in leave mod
                  if (userJoined) {
                    buttonMode = EventButtonMode.leave;
                  } else if (event.currNumParticipants >= event.maxParticipants) {
                    buttonMode = EventButtonMode.full;
                  } else {
                    buttonMode = EventButtonMode.join;
                  }
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: JoinLeaveEventButton(
                      mode: buttonMode,
                      eventId: event.eventId,
                      updateEvent: refreshEvent,
                    ));
                } else {
                  return const SizedBox();
                }
              } else {
                return const SizedBox();
              }
            })
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
  bool showMore = false;

  String formatDateTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    return sprintf("%02i-%02i-%02i %02i:%02i", [
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute
    ]);
  }

  @override
  Widget build(BuildContext context) {
    EventInfo event = widget.eventInfo;
    var purpleBoldFont = const TextStyle(
        color: Color.fromARGB(255, 81, 65, 143),
        fontWeight: FontWeight.bold,
        fontSize: 18);

    var userProfileImages = Row(
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Icon(Icons.people_alt_outlined,
              color: Color.fromARGB(255, 81, 65, 143))),
        const SizedBox(width: 10),
        Text(event.currNumParticipants.toString() + " people joined",
          style: const TextStyle(
            color: Color.fromARGB(255, 81, 65, 143),
            fontWeight: FontWeight.bold,
            fontSize: 18)),
        const SizedBox(width: 24),
        event.currNumParticipants > 0 ?
          Row(
            children: [
              SizedBox(
                width: 60,
                child: SizedBox(
                  width: double.infinity,
                  height: 25,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: event.currNumParticipants <= 3 ? event.currNumParticipants : 3,
                    itemBuilder: (context, index) {
                      return const Align(
                        widthFactor: 0.6,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: AssetImage("images/tree.jpg"),
                        ),
                      );
              }))),
              TextButton(
                onPressed: () {
                  setState(() {showMore = !showMore;});
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
                      fontSize: 15
              )))]
        ) : const SizedBox()
      ],
    );

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Column(children: [
          // Event Title
          Align(
            alignment: Alignment.topLeft,
            child: Text(event.eventName,
                style: const TextStyle(
                    color: Color.fromARGB(255, 81, 65, 143),
                    fontWeight: FontWeight.bold,
                    fontSize: 27)),
          ),
          // number of spot avaible
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.topLeft,
            child: event.currNumParticipants >= event.maxParticipants
                ? const Text("Full",
                    style: TextStyle(color: Colors.red, fontSize: 15))
                : Text(
                    (event.maxParticipants - event.currNumParticipants)
                            .toString() +
                        " spots available",
                    style: const TextStyle(color: Colors.green, fontSize: 15)),
          ),
          const SizedBox(height: 20),
          // Event images
          Container(
              height: 200,
              alignment: Alignment.center,
              child:
                  EventImage(eventId: event.eventId, boxFit: BoxFit.contain)),
          const SizedBox(height: 20),
          // start time and end time widget
          Row(
            children: [
              const Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.access_time_rounded,
                      color: Color.fromARGB(255, 81, 65, 143))),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(formatDateTime(event.startTime), style: purpleBoldFont),
                  Text(formatDateTime(event.endTime), style: purpleBoldFont)
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          // number of participant
          userProfileImages,
          if (showMore)
            event.currNumParticipants > 0
              ? Container(
                height: 60.0,
                width: 350,
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                    itemCount: event.currNumParticipants,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 8,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage("images/tree.jpg"),
                        ),
                      );
                    }),
                  )
                : const SizedBox(),
          showMore ? const SizedBox() : const SizedBox(height: 10),
          // event address
          Row(
            children: [
              const Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.location_on_outlined,
                      color: Color.fromARGB(255, 81, 65, 143))),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(event.address,
                      style: purpleBoldFont, overflow: TextOverflow.clip)),
            ],
          ),
          const SizedBox(height: 10),
          // event description
          Row(
            children: [
              const Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.event_note_outlined,
                      color: Color.fromARGB(255, 81, 65, 143))),
              const Padding(padding: EdgeInsets.all(5)),
              Text("Event Details", style: purpleBoldFont),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Padding(padding: EdgeInsets.all(10)),
              Expanded(
                child: Text(event.description,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(color: Colors.black, fontSize: 16)),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.all(15)),
        ]),
      ),
    );
  }
}

enum EventButtonMode { join, leave, full }

class JoinLeaveEventButton extends StatefulWidget {
  const JoinLeaveEventButton(
      {required this.mode,
      required this.updateEvent,
      required this.eventId,
      Key? key})
      : super(key: key);
  final EventButtonMode mode;
  final int eventId;
  final Function updateEvent;
  @override
  JoinLeaveEventButtonState createState() => JoinLeaveEventButtonState();
}

class JoinLeaveEventButtonState extends State<JoinLeaveEventButton> {
  late EventButtonMode mode;
  late int eventId;
  late Function updateEvent;
  @override
  void initState() {
    super.initState();
    mode = widget.mode;
    eventId = widget.eventId;
    updateEvent = widget.updateEvent;
  }

  void _joinOrLeaveEvent() async {
    if (mode == EventButtonMode.join) {
      await joinEvent(eventId);
      setState(() {
        mode = EventButtonMode.leave;
      });
      updateEvent();
      Fluttertoast.showToast(
        msg: "Joined Event",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withAlpha(150),
        timeInSecForIosWeb: 3,
        fontSize: 20.0
      );
    } else {
      await quitEvent(eventId);
      setState(() {
        mode = EventButtonMode.join;
      });
      updateEvent();
      Fluttertoast.showToast(
        msg: "Left Event",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withAlpha(150),
        timeInSecForIosWeb: 3,
        fontSize: 20.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var boxShadow = BoxShadow(
      color: const Color.fromARGB(255, 120, 117, 117).withOpacity(.5),
      blurRadius: 20.0, // soften the shadow
      spreadRadius: 0.0, //extend the shadow
      offset: const Offset(5.0, 8.0),
    );

    var fullButtom = ClipRRect(
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
          child: Text("Full",
            style: TextStyle(
              color: Color.fromARGB(255, 243, 241, 241),
              fontWeight: FontWeight.bold,
              fontSize: 22
      )))),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(boxShadow: [boxShadow]),
              child: mode == EventButtonMode.full ? fullButtom
                : ClipRRect(
                  borderRadius: BorderRadius.circular(20.0), //or 15.0
                  child: Container(
                    padding: const EdgeInsets.all(5),
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
                      )),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                          shadowColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: mode == EventButtonMode.leave ?
                         const Text("Leave Event",
                          style: TextStyle(
                            color: Color.fromARGB(
                                255, 243, 241, 241),
                            fontWeight: FontWeight.bold,
                            fontSize: 22
                          ))
                          : 
                          const Text("Join Event",
                            style: TextStyle(
                              color: Color.fromARGB(255, 243, 241, 241),
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                          )),
                        onPressed: _joinOrLeaveEvent
                      ))),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ));
  }
}
