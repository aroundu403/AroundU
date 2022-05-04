import 'package:aroundu/event/map_view.dart';
import 'package:flutter/material.dart';

import 'event/list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MapView(),
    );
  }
}
