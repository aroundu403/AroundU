import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aroundu/auth/home_page.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  EventState createState() => EventState();
}

class EventState extends State<EventPage> {
  final image = "images/scenary.jpg";
  bool joinedIn = false;
  final int capacity = 7;
  int size = 5;
  bool show = false;
  final List<String> participants = [
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/scenary.jpg",
    "images/scenary.jpg",
    "images/tree.jpg",
    "images/tree.jpg",
    "images/tree.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(padding: const EdgeInsets.all(15)),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.all(5)),
                  Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage())),
                          child: Icon(
                            Icons.chevron_left,
                            size: 36,
                            color: const Color.fromARGB(255, 81, 65, 143),
                          )))
                ],
              ),
              Padding(padding: const EdgeInsets.all(2)),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.all(16)),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Crystal Ski Carpool",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 81, 65, 143),
                            fontWeight: FontWeight.bold,
                            fontSize: 27)),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.all(18)),
                  Align(
                    alignment: Alignment.topLeft,
                    child: size >= capacity
                        ? Text("Closed",
                            style: TextStyle(color: Colors.red, fontSize: 15))
                        : Text(
                            (capacity - size).toString() + " spots available",
                            style:
                                TextStyle(color: Colors.green, fontSize: 15)),
                  )
                ],
              ),
              Container(
                width: 343,
                height: 100,
                child: Expanded(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0), //or 15.0
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(image), fit: BoxFit.fill)),
                  ),
                )),
              ),
              Padding(padding: const EdgeInsets.all(5)),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.all(10)),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Icon(Icons.access_time_rounded,
                          color: const Color.fromARGB(255, 81, 65, 143))),
                  Padding(padding: const EdgeInsets.all(5)),
                  Column(
                    children: [
                      Text("Start Time : Sat, 04/02, 13:00 ",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 81, 65, 143),
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      Text("End Time   : Sun, 04/03, 14:00",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 81, 65, 143),
                              fontWeight: FontWeight.bold,
                              fontSize: 18))
                    ],
                  )
                ],
              ),
              Padding(padding: const EdgeInsets.all(5)),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.all(10)),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Icon(Icons.people_alt_outlined,
                          color: const Color.fromARGB(255, 81, 65, 143))),
                  Padding(padding: const EdgeInsets.all(5)),
                  Text(size.toString() + " people joined",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 81, 65, 143),
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Padding(padding: const EdgeInsets.all(12)),
                  SizedBox(
                      width: 50,
                      height: 25,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Align(
                              widthFactor: 0.6,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 12,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundImage:
                                      AssetImage(participants[index]),
                                ),
                              ),
                            );
                          })),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        show = !show;
                      });
                    },
                    child: show
                        ? Text("hide all",
                            style: TextStyle(
                                color: Color.fromARGB(255, 190, 114, 230),
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                                fontSize: 15))
                        : Text("show all",
                            style: TextStyle(
                                color: Color.fromARGB(255, 190, 114, 230),
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                                fontSize: 15)),
                  )
                ],
              ),
              if (show)
                SizedBox(
                  height: 100.0,
                  width: 350,
                  child: GridView.builder(
                      itemCount: participants.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 1.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 8,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundImage: AssetImage(participants[index]),
                          ),
                        );
                      }),
                ),
              Padding(padding: const EdgeInsets.all(5)),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.all(10)),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Icon(Icons.location_on_outlined,
                          color: const Color.fromARGB(255, 81, 65, 143))),
                  Padding(padding: const EdgeInsets.all(5)),
                  Text("4510 21st Ave NE",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 81, 65, 143),
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ],
              ),
              Padding(padding: const EdgeInsets.all(5)),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.all(10)),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Icon(Icons.event_note_outlined,
                          color: const Color.fromARGB(255, 81, 65, 143))),
                  Padding(padding: const EdgeInsets.all(5)),
                  Text("Event Details",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 81, 65, 143),
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ],
              ),
              Padding(padding: const EdgeInsets.all(5)),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.all(10)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Congue mauris rhoncus aenean vel. Eleifend mi in nulla posuere sollicitudin. Diam ut venenatis tellus in metus vulputate eu scelerisque felis. At ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget. Et ultrices neque ornare aenean euismod elementum nisi quis eleifend. Sit amet consectetur adipiscing elit ut aliquam purus. Amet nisl suscipit adipiscing bibendum. Pellentesque habitant morbi tristique senectus et netus et. Imperdiet proin fermentum leo vel orci porta non pulvinar neque. Nibh venenatis cras sed felis eget velit aliquet. Vel pharetra vel turpis nunc eget lorem dolor. Bibendum neque egestas congue quisque.",
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  )
                ],
              ),
              Padding(padding: const EdgeInsets.all(15)),
            ]),
          )),
      bottomNavigationBar: Container(
          width: 343,
          height: 60,
          child: Expanded(
            child: Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 120, 117, 117).withOpacity(.5),
                    blurRadius: 20.0, // soften the shadow
                    spreadRadius: 0.0, //extend the shadow
                    offset: Offset(
                      5.0, // Move to right 10  horizontally
                      8.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: !joinedIn && size >= capacity
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20.0), //or 15.0
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Color.fromARGB(255, 80, 77, 77),
                                Color.fromARGB(255, 120, 117, 117),
                              ])),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("Full",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 243, 241, 241),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22)))),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20.0), //or 15.0
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: joinedIn
                                ? [
                                    const Color(0xffff1fa7),
                                    Color.fromARGB(255, 172, 115, 248),
                                  ]
                                : [
                                    const Color.fromARGB(255, 81, 65, 143),
                                    Color.fromARGB(255, 172, 115, 248)
                                  ],
                          )),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: joinedIn
                                ? Text("I'm In !!",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 243, 241, 241),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22))
                                : Text("Join Event !",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 243, 241, 241),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22)),
                            onPressed: () {
                              setState(() {
                                if (joinedIn) {
                                  size--;
                                } else {
                                  size++;
                                }
                                joinedIn = !joinedIn;
                              });
                            },
                          ))),
            ),
          )),
    );
  }
}
