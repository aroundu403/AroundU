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
    ["images/tree.jpg", "images/tree.jpg", "images/tree.jpg"],
    []
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
        // backgroundColor: Color.fromARGB(255, 166, 250, 230),
        // appBar: AppBar(
        //   // title: const Text("Event List"),
        //   // backgroundColor: const Color.fromARGB(255, 81, 65, 143), // 主色,
        // ),
        body:
            // Center(
            //     child:
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 197, 240, 207),
                    Color.fromARGB(255, 163, 232, 236),
                  ],
                )),
                child: SingleChildScrollView(
                    child: Column(children: [
                  Padding(padding: const EdgeInsets.all(30)),
                  const Text("Event List",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 81, 65, 143),
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
                                margin: EdgeInsets.all(8),
                                width: 343,
                                height: 130,
                                decoration: new BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 120, 117, 117)
                                          .withOpacity(.5),
                                      blurRadius: 20.0, // soften the shadow
                                      spreadRadius: 0.0, //extend the shadow
                                      offset: Offset(
                                        5.0, // Move to right 10  horizontally
                                        8.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // if you need this
                                      side: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: ListTile(
                                        leading:
                                            // CircleAvatar(
                                            //   radius: 35,
                                            //   backgroundImage: AssetImage(images[index]),
                                            // ),
                                            ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10.0), //or 15.0
                                          child: Container(
                                              height: 130.0,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        images[index]),
                                                    fit: BoxFit.cover),
                                              )
                                              // Icon(Icons.volume_up, color: Colors.white, size: 50.0),

                                              ),
                                        ),
                                        minVerticalPadding: 16,
                                        title: Text(titles[index],
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 81, 65, 143),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        subtitle: Column(children: [
                                          Padding(
                                              padding: const EdgeInsets.all(3)),
                                          Row(children: [
                                            Icon(Icons.location_pin,
                                                color: const Color.fromARGB(
                                                    255, 81, 65, 143)),
                                            Text(subtitles[index],
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 81, 65, 143),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16))
                                          ]),
                                          // Row(children: [
                                          //   CircleAvatar(
                                          //     backgroundImage: AssetImage(images[index]),
                                          //   )
                                          // ]),
                                          // GridView.count(
                                          //   crossAxisCount: 5,
                                          //   children: List.generate(5, (index) {
                                          //     return Container(
                                          //       child: Image.asset('images/tree.jpg'),
                                          //     );
                                          //   }),
                                          // )
                                          //Stack(
                                          //alignment:new Alignment(x, y)
                                          //children: <Widget>[
                                          // new CircleAvatar(
                                          //   backgroundImage:
                                          //       AssetImage(images[index]),
                                          // ),
                                          //size: 36.0,
                                          //color: const Color.fromRGBO(
                                          //218, 165, 32, 1.0)),
                                          Padding(
                                              padding: const EdgeInsets.all(3)),
                                          Container(
                                              height: 45.0,
                                              width: 300.0,
                                              child: participants[index]
                                                          .length >
                                                      0
                                                  ? Row(children: [
                                                      Stack(
                                                          //alignment:new Alignment(x, y)
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 20,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                      participants[
                                                                              index]
                                                                          [0]),
                                                              //radius: 30,
                                                            ),
                                                            //List.generate(participants[index].length,(index2){
                                                            for (int i = 1;
                                                                i <
                                                                    participants[
                                                                            index]
                                                                        .length;
                                                                i++)
                                                              new Positioned(
                                                                left: 20.0,
                                                                child:
                                                                    new CircleAvatar(
                                                                  radius: 20,
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          participants[index]
                                                                              [
                                                                              i]),
                                                                  //radius: 30,
                                                                ),
                                                              )
                                                          ])
                                                    ])
                                                  // : Row(children: [
                                                  //     CircleAvatar(
                                                  //       radius: 15,
                                                  //       backgroundImage: AssetImage(
                                                  //           participants[index][0]),
                                                  //     )
                                                  //   ]),
                                                  : Column(children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3)),
                                                      const Text('text("")',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      150,
                                                                      149,
                                                                      152),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize: 12))
                                                    ]))

                                          // ListView.builder(
                                          //   controller: _controller,
                                          //   physics: _physics,
                                          //   // itemCount: images.length,
                                          //   itemBuilder: (BuildContext, index2) {
                                          //     return Container(
                                          //         child: CircleAvatar(
                                          //       backgroundImage: AssetImage(
                                          //           participants[index][index2]),
                                          //     ));
                                          //   },
                                          //   // padding: const EdgeInsets.all(8),
                                          //   shrinkWrap: true,
                                          //   scrollDirection: Axis.horizontal,
                                          // )
                                        ])
                                        // subtitle: Text(subtitles[index]),
                                        )));
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
                                  color: const Color.fromARGB(255, 81, 65, 143),
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20))),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthenticationService>().signOut();
                    },
                    child: const Text("Sign out"),
                  )
                ]))));
  }
}
