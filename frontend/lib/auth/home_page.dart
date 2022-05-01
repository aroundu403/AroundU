import 'package:aroundu/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

ThemeData THEME = ThemeData(
  primaryColor: const Color.fromARGB(255, 92, 74, 210), // 主色
  backgroundColor: const Color.fromARGB(255, 81, 65, 143), // 背景色
  focusColor: const Color(0xff8DFFF2), // 撞色
  highlightColor: const Color(0xffff1fa7), // 点缀色

  textTheme: const TextTheme(
    headline1: TextStyle(
        fontSize: 72.0,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 92, 74, 210)),
    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: THEME,
      home: ListViewHome(),
    );
  }
}

class ListViewHome extends StatelessWidget {
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
    "Title 1",
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
//   var _controller = ScrollController();
// ScrollPhysics _physics = ClampingScrollPhysics();

// @override
// void initState() {
//   super.initState();
//   _controller.addListener(() {
//     if (_controller.position.pixels <= 56)
//       setState(() => _physics = ClampingScrollPhysics());
//     else
//       setState(() => _physics = BouncingScrollPhysics());
//   });
// }
  ScrollController _controller = new ScrollController();
  ScrollPhysics _physics = ClampingScrollPhysics();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 81, 65, 143),
        // appBar: AppBar(
        //   // title: const Text("Event List"),
        //   // backgroundColor: const Color.fromARGB(255, 81, 65, 143), // 主色,
        // ),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(padding: const EdgeInsets.all(30)),
          const Text("Event List",
              style: TextStyle(
                  color: Color.fromARGB(255, 249, 248, 251),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 36)),
          images.isNotEmpty
              ? ListView.builder(
                  controller: _controller,
                  physics: _physics,
                  itemCount: images.length,
                  itemBuilder: (BuildContext, index) {
                    return Container(
                        width: 100,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(40), // if you need this
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(images[index]),
                              ),
                              title: Text(titles[index]),
                              subtitle: Row(children: [
                                Icon(Icons.location_pin),
                                Text(subtitles[index])
                              ]),
                              // subtitle: Text(subtitles[index]),
                              trailing: Icon(Icons.star)),
                        ));
                  },
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                )
              :
              // Column(
              //     mainAxisSize: MainAxisSize.min,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //         const Text('No Events Posted Currently',
              //             style: TextStyle(
              //                 color: const Color.fromARGB(255, 249, 248, 251),
              //                 fontStyle: FontStyle.italic,
              //                 fontSize: 20)),
              //       ]),
              const Center(
                  child: const Text('No Events Posted Currently',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 249, 248, 251),
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
