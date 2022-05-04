
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapView extends StatefulWidget {
  const MapView({ Key? key }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: MapboxMap(
        accessToken: dotenv.env['mapBoxAccessToken']!,
        styleString: 'mapbox://styles/george9977/cl2i6zq8t002714l2the0g89v',
        initialCameraPosition: CameraPosition(
          zoom: 14.0,
          target: LatLng(47.6555, -122.3092),
        ),
      ),
    );
  }
}