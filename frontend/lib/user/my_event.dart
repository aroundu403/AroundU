import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../../main.dart';
import 'package:aroundu/json/event.dart';
import 'profile.dart';
import '../event/event_detail.dart';

class MyEventPage extends StatefulWidget {
  const MyEventPage({Key? key}) : super(key: key);

  @override
  MyEventState createState() => MyEventState();
}

class MyEventState extends State<MyEventPage> {
  final ScrollController _controller = ScrollController();
  final ScrollPhysics _physics = const ClampingScrollPhysics();

  final images = [
    "images/scenary.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg"
  ];
  final titles = [
    "Dinner at the Ave",
    "Friday movie night",
    "Friday movie night",
    "Friday movie night",
    "Friday movie night",
    "Friday movie night",
    "Friday movie night"
  ];
  final sizes = [0, 3, 0, 0, 0, 0, 0];

  final upcomingimages = [
    "images/scenary.jpg",
    "images/tree.jpg",
    "images/waterfall.jpg"
  ];

  final upcomingevents = ["Coffee Chat", "Cherry Blossom", "Cherry Blossom"];
  final times = ["Apr 30,  14:30", "May 02,  14:30", "May 02,  14:30"];

  @override
  void initState() {
    super.initState();
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
              Row(
                children: const [
                  Padding(padding: EdgeInsets.all(16)),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("My Events",
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
              Expanded(
                  child: ListView.builder(
                      controller: _controller,
                      physics: _physics,
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: images.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (buildContext, index) {
                        return Container(
                            margin: const EdgeInsets.all(8),
                            width: 343,
                            height: 150,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 120, 117, 117)
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
                                        builder: (context) => const EventPage(eventId: 3,),
                                      ),
                                    ),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          35), // if you need this
                                      side: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(children: [
                                      const Padding(padding: EdgeInsets.all(8)),
                                      Expanded(
                                          child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            15.0), //or 15.0
                                        child: Container(
                                          height: 110.0,
                                          width: 90.0,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image:
                                                      AssetImage(images[index]),
                                                  fit: BoxFit.fill)),
                                        ),
                                      )),
                                      const Padding(padding: EdgeInsets.all(8)),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.all(5)),
                                                    Text(titles[index],
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    81,
                                                                    65,
                                                                    143),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18)),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.all(30)),
                                                    Column(children: [
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3)),
                                                      Row(children: [
                                                        const Icon(
                                                            Icons
                                                                .people_alt_outlined,
                                                            color: Colors.grey),
                                                        Text(
                                                            " " +
                                                                sizes[index]
                                                                    .toString() +
                                                                " people joined",
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        81,
                                                                        65,
                                                                        143),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16))
                                                      ]),
                                                      // const Padding(
                                                      //     padding:
                                                      //         EdgeInsets.all(3)),
                                                    ])
                                                  ])))
                                    ]))));
                      })),
              const Padding(padding: EdgeInsets.all(5)),
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
              Expanded(
                  child: GridView.builder(
                      controller: _controller,
                      physics: _physics,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: upcomingevents.length,
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 120, 117, 117)
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
                                        builder: (context) => const EventPage(eventId: 3),
                                      ),
                                    ),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          25), // if you need this
                                      side: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(children: [
                                      const Padding(padding: EdgeInsets.all(8)),
                                      Row(children: [
                                        const Padding(
                                            padding: EdgeInsets.all(8)),
                                        Expanded(
                                            child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10.0), //or 15.0
                                          child: Container(
                                            height: 130,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        upcomingimages[index]),
                                                    fit: BoxFit.fill)),
                                          ),
                                        )),
                                        const Padding(
                                            padding: EdgeInsets.all(8)),
                                      ]),
                                      const Padding(padding: EdgeInsets.all(8)),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                              padding: const EdgeInsets.all(5),
                                              child: Column(children: [
                                                Text(upcomingevents[index],
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 81, 65, 143),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18)),
                                                Text(times[index],
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16)),
                                              ])))
                                    ]))));
                      }))
            ],
          ),
        )
      ],
    )));
  }
}
