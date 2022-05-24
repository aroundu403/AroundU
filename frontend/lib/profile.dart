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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(children: [
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
      ])
    ]));
  }
}
