/// display the user information and log out button.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../auth/auth_service.dart';
import 'package:aroundu/json/user.dart';
import '../event/api_calls.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  late Future<UseInfo> _user;

  @override
  void initState() {
    super.initState();
    _user = fetchUser();
  }

  final image = "images/scenary.jpg";
  @override
  Widget build(BuildContext context) {
    return Material(
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
            const Padding(padding: EdgeInsets.all(160)),
            SizedBox(
                width: 260,
                height: 50,
                child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 120, 117, 117)
                            .withOpacity(.5),
                        blurRadius: 20.0, // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: const Offset(5.0, 8.0),
                      )
                    ]),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0), //or 15.0
                        child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 81, 65, 143),
                                Color.fromARGB(255, 172, 115, 248)
                              ],
                            )),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: const Center(
                                  child: Text("Sign out",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20))),
                              onPressed: () {
                                context.read<AuthenticationService>().signOut();
                              },
                            )))))
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
                  color: Color.fromARGB(255, 255, 255, 255), fontSize: 20))
        ]));
  }
}
