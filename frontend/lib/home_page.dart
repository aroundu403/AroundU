/// This is the home page of AroundU which contains the map view and list view of events.
/// It also contains the access to other modules such as create event page and my event page
/// It will be the main page that users will interact with after they have signed in.
import 'package:aroundu/event/create_event_page.dart';
import 'package:aroundu/event/map_view.dart';
import 'package:aroundu/user/my_event.dart';
import 'package:aroundu/user/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'event/list_view.dart';

enum ViewMode { map, list }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ViewMode _viewMode = ViewMode.map;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // render map view or list view based on current view  mode
          _viewMode == ViewMode.map ? const MapView() : const ListViewHome(),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    MoreButton(),
                    PostEventButton(),
                    MyProfileButton(),
                  ],
                ),
              )),
          // map view and list view toggle button
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 15, top: 10),
                child: FlutterToggleTab(
                  width: 25,
                  borderRadius: 40,
                  selectedIndex: _viewMode == ViewMode.map ? 0 : 1,
                  selectedTextStyle: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  unSelectedTextStyle: TextStyle(
                      color: Theme.of(context).primaryColor.withAlpha(170),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  labels: const ["Map", "List"],
                  selectedLabelIndex: (index) {
                    setState(() {
                      _viewMode = index == 0 ? ViewMode.map : ViewMode.list;
                    });
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MoreButton extends StatelessWidget {
  const MoreButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: Material(
          color: const Color.fromARGB(255, 248, 249, 255),
          child: InkWell(
            splashColor: Theme.of(context).focusColor,
            onTap: () {
              Navigator.of(context)
                  .push(createRouteFromLeftToRight(const MyEventPage()));
            },
            child: const Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }

  Route createRouteFromLeftToRight(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class PostEventButton extends StatelessWidget {
  const PostEventButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      // outer border
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white,
        // inner circle
        child: CircleAvatar(
          radius: 35,
          backgroundColor: const Color.fromARGB(255, 156, 133, 255),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateEeventPage(),
                ),
              );
            },
            child: const Icon(
              Icons.add,
              color: Color(0xFFD4FCDF),
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}

class MyProfileButton extends StatelessWidget {
  const MyProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: Material(
          color: const Color.fromARGB(255, 248, 249, 255),
          child: InkWell(
            splashColor: Theme.of(context).focusColor,
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ProfilePage()),
              // );
              Navigator.of(context)
                  .push(createRouteFromRightToLeft(const ProfilePage()));
            },
            child: const Icon(Icons.person),
          ),
        ),
      ),
    );
  }

  Route createRouteFromRightToLeft(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
