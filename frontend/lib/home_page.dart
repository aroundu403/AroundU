/// This is the home page of AroundU which contains the map view and list view of events.
/// It also contains the access to other modules such as create event page and my event page
/// It will be the main page that users will interact with after they have signed in.
import 'package:aroundu/event/map_view.dart';
import 'package:flutter/material.dart';
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
      body: _viewMode == ViewMode.map ? const MapView() : ListViewHome(),
      floatingActionButton: FloatingActionButton.extended(
        label: _viewMode == ViewMode.map ? const Text("List View"): const Text("Map View"),
        onPressed: () {
          setState(() {
            _viewMode = _viewMode == ViewMode.map ? ViewMode.list : ViewMode.map;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }
}