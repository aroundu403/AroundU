import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../main.dart';
import 'package:aroundu/json/event.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  //final EventButtonMode mode = EventButtonMode.join;
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  final image = "images/scenary.jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          // ignore: prefer_const_literals_to_create_immutables
          colors: [
            Color.fromARGB(64, 82, 66, 144),
            Color.fromARGB(206, 99, 139, 198),
            Color.fromARGB(210, 112, 188, 236),
          ],
        )),
        child: Column(
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
            Container(
              width: 150,
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 70,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage(image),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(15)),
            const Align(
              alignment: Alignment.topCenter,
              child: Text("George",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
            ),
            Padding(padding: EdgeInsets.all(5)),

            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: SizedBox(
                        width: 343,
                        height: 60,
                        child: Row(children: [
                          Expanded(
                              child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 120, 117, 117)
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
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(20.0), //or 15.0
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ],
                                          )),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                            ),
                                            child: const Text("My Events",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        236, 81, 65, 143),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22)),
                                            onPressed: () {
                                              // TODO state management and send network request
                                            },
                                          )))))
                        ]))))
          ],
        ),
      )
    ]));
  }
}
