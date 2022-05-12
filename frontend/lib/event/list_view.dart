import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_service.dart';
import 'eventdetail.dart';

// ignore: must_be_immutable
class ListViewHome extends StatefulWidget {
  ListViewHome({Key? key}) : super(key: key);

  @override
  State<ListViewHome> createState() => _ListViewHomeState();
}

class _ListViewHomeState extends State<ListViewHome> {
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

  final List<String> titles = [
    "Title 0",
    "Title 2",
    "Title 3",
    "Title 4",
    "Title 4",
    "Title 4",
    "Title 4",
    "Title 4",
    "Title 4",
    "Title 4",
    "Title 4",
    "Title 4",
    "Title 4",
    "Title 4",
    "Title 4",
    "Title 4"
  ];

  final List<String> subtitles = [
    "subtitle 1",
    "subtitle 2",
    "subtitle 3",
    "subtitle 4",
    "subtitle 4",
    "subtitle 4",
    "subtitle 4",
    "subtitle 4",
    "subtitle 4",
    "subtitle 4",
    "subtitle 4",
    "subtitle 4",
    "subtitle 4",
    "subtitle 4",
    "subtitle 4",
    "subtitle 4"
  ];

  final List<String> participant = [
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg"
  ];

  final List<List<String>> participants = [
    ["images/scenary.jpg"],
    [
      "images/scenary_red.jpg",
      "images/scenary_red.jpg",
      "images/scenary_red.jpg"
    ],
    ["images/waterfall.jpg", "images/waterfall.jpg", "images/waterfall.jpg"],
    [],
    [
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
      "images/tree.jpg",
      "images/tree.jpg",
      "images/tree.jpg"
    ],
    ["images/tree.jpg", "images/tree.jpg", "images/tree.jpg"],
    ["images/tree.jpg", "images/tree.jpg", "images/tree.jpg"],
    ["images/tree.jpg", "images/tree.jpg", "images/tree.jpg"],
    ["images/tree.jpg", "images/tree.jpg", "images/tree.jpg"],
    ["images/tree.jpg", "images/tree.jpg", "images/tree.jpg"],
    ["images/tree.jpg", "images/tree.jpg", "images/tree.jpg"],
    ["images/tree.jpg", "images/tree.jpg", "images/tree.jpg"],
    ["images/tree.jpg", "images/tree.jpg", "images/tree.jpg"],
    ["images/tree.jpg", "images/tree.jpg", "images/tree.jpg"],
    ["images/tree.jpg", "images/tree.jpg", "images/tree.jpg"],
    ["images/tree.jpg", "images/tree.jpg", "images/tree.jpg"],
    []
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
          )
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            const Padding(padding: EdgeInsets.all(30)),
            const Text("Event List",
                style: TextStyle(
                  color: Color.fromARGB(255, 81, 65, 143),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 36
                )
            ),
            images.isNotEmpty
              ? ListView.builder(
                  controller: _controller,
                  physics: _physics,
                  itemCount: images.length,
                  // ignore: avoid_types_as_parameter_names
                  itemBuilder: (buildContext, index) {
                    return Container(
                        margin: const EdgeInsets.all(8),
                        width: 343,
                        height: 130,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color.fromARGB(255, 120, 117, 117)
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
                        child: GestureDetector(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EventPage(),
                                  ),
                                ),
                            // },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // if you need this
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
                                        10.0), //or 15.0
                                    child: Container(
                                      height: 90.0,
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

                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.end,
                                              children: <Widget>[
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
                                                Column(children: [
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.all(
                                                              3)),
                                                  Row(children: [
                                                    const Icon(
                                                        Icons.location_pin,
                                                        color:
                                                            Color.fromARGB(
                                                                255,
                                                                81,
                                                                65,
                                                                143)),
                                                    Text(subtitles[index],
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
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.all(
                                                              3)),
                                                  SizedBox(
                                                      height: 45.0,
                                                      width: 300.0,
                                                      child: participants[
                                                                  index]
                                                              .isNotEmpty
                                                          ? SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 100,
                                                              child: ListView
                                                                  .builder(
                                                                      scrollDirection: Axis
                                                                          .horizontal,
                                                                      itemCount: participants[index]
                                                                          .length,
                                                                      itemBuilder: (context,
                                                                          index1) {
                                                                        return Align(
                                                                          widthFactor: 0.6,
                                                                          child: CircleAvatar(
                                                                            backgroundColor: Colors.white,
                                                                            child: CircleAvatar(
                                                                              radius: 18,
                                                                              backgroundImage: AssetImage(participants[index][index1]),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }))
                                                          : Column(
                                                              children: const [
                                                                  Padding(
                                                                      padding:
                                                                          EdgeInsets.all(3)),
                                                                  Text(
                                                                      'text("")',
                                                                      textAlign: TextAlign
                                                                          .left,
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(255, 150, 149, 152),
                                                                          fontStyle: FontStyle.italic,
                                                                          fontSize: 12))
                                                                ]))
                                                ])
                                              ])))
                                ]))));
                  },
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                )
              : const Center(
                  child: Text('No Events Posted Currently',
                      style: TextStyle(
                          color: Color.fromARGB(255, 81, 65, 143),
                          fontStyle: FontStyle.italic,
                          fontSize: 20))),
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: const Text("Sign out"),
          )
        ])));
  }
}
