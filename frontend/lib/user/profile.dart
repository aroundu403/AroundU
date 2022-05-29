import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../../main.dart';
import 'my_event.dart';
import 'package:aroundu/json/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<UseInfo> fetchUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User has not logged in");
  }

  String token = await user.getIdToken();
  final response = await http.get(Uri(host: backendAddress, path: "/user"),
      // queryParameters: {"eventid": "3"}),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return UseInfo.fromJson(jsonDecode(response.body)["data"]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load event');
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  late Future<UseInfo> _user;
  final cardtext = ["CREATED EVENTS", "MY EVENTS", "SETTINGS"];

  final ScrollController _controller = ScrollController();
  final ScrollPhysics _physics = const ClampingScrollPhysics();

  @override
  void initState() {
    super.initState();
    _user = fetchUser();
  }

  final image = "images/scenary.jpg";
  @override
  Widget build(BuildContext context) {
    return Material(
        // child: SingleChildScrollView(
        child: Column(children: [
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
            SizedBox(
              width: 150,
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 100,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage(image),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(15)),
            FutureBuilder<UseInfo>(
                future: _user,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return UserDetailHelper(userInfo: snapshot.data!);
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('No User Information',
                            style: TextStyle(
                                color: Color.fromARGB(255, 81, 65, 143),
                                fontStyle: FontStyle.italic,
                                fontSize: 20)));
                  }
                  return const CircularProgressIndicator();
                }),
            const Padding(padding: EdgeInsets.all(10)),
            Expanded(
                child: ListView.builder(
                    controller: _controller,
                    physics: _physics,
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: cardtext.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (buildContext, index) {
                      return Container(
                          margin: const EdgeInsets.all(8),
                          width: 343,
                          height: 100,
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
                                      builder: (context) => const MyEventPage(),
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
                                  child: Center(
                                      child: Text(cardtext[index],
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 81, 65, 143),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24))))));
                    }))
          ]))
    ]));
  }
}

class UserDetailHelper extends StatefulWidget {
  const UserDetailHelper({Key? key, required this.userInfo}) : super(key: key);
  final UseInfo userInfo;

  @override
  State<UserDetailHelper> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetailHelper> {
  late UseInfo user = widget.userInfo;
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Column(children: [
          Text(user.userName.toString(),
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 32)),
          const Padding(padding: EdgeInsets.all(5)),
          Text(user.email.toString(),
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), fontSize: 24))
        ]));
  }
}
