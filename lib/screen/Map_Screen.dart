import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
// import 'speedometer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Timer? mappos1;
  double lat2 = 0.0;
  double lon2 = 0.0;
  bool isDone = true;
  void getMyLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position myLocation = await Geolocator.getCurrentPosition();
    setState(() {
      lat2 = myLocation.latitude;
      lon2 = myLocation.longitude;
      isDone = false;
    });
  }

  void mapposupdatemap() {
    mappos1 = Timer.periodic(Duration(seconds: 2), (mappos1) async {
      Position updateableposition = await Geolocator.getCurrentPosition();
      setState(() {
        lat2 = updateableposition.latitude;
        lon2 = updateableposition.longitude;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyLocation();
    mapposupdatemap();
  }

  Future<bool>? stoptrack() {
    mappos1!.cancel();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        print("backbutton pressed");
        final myback = await stoptrack();
        return myback ?? false;
      },
      child: isDone
          ? Scaffold(body: Center(child: Text("This may take a while")))
          : Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.grey,
                  title: Text(
                    "Map",
                    style: TextStyle(color: Colors.black),
                  )),
              body: FlutterMap(
                options: MapOptions(
                  center: LatLng(lat2, lon2),
                  zoom: 18.0,
                  maxZoom: 19.0,
                  keepAlive: true,
                ),
                nonRotatedChildren: [
                  AttributionWidget.defaultWidget(
                    source: 'OpenStreetMap contributors',
                    onSourceTapped: null,
                  ),
                ],
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(lat2, lon2),
                        width: 80,
                        height: 80,
                        builder: (context) => Container(
                          child: Icon(
                            Icons.circle,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
}
