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
  bool _enableMapControl = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void setControl(bool value) {
    setState(() {
      _enableMapControl = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: const MyEventPage(),
        
      ),
      onDrawerChanged: (isOpen) {
        setControl(!isOpen);
      },
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: const ProfilePage()
      ),
      onEndDrawerChanged: ((isOpened) {
        setControl(!isOpened);
      }),
      body: Stack(
        children: [
          // render map view or list view based on current view  mode
          _viewMode == ViewMode.map ? MapView(enableControl: _enableMapControl) : const ListViewHome(),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MoreButton(scaffoldKey: _scaffoldKey),
                    const PostEventButton(),
                    MyProfileButton(scaffoldKey: _scaffoldKey),
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
  const MoreButton({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

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
              scaffoldKey.currentState!.openDrawer();
            },
            child: const Icon(Icons.more_vert),
          ),
        ),
      ),
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
  const MyProfileButton({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

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
              scaffoldKey.currentState!.openEndDrawer();
            },
            child: const Icon(Icons.person),
          ),
        ),
      ),
    );
  }
}
