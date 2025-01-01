import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:running_app/screen/map_screen.dart';
import 'package:running_app/screen/runningdur.dart';

// ignore: prefer_const_constructors
class MainSectionWidget extends StatefulWidget {
  const MainSectionWidget({super.key});

  @override
  State<MainSectionWidget> createState() => _MainSectionWidgetState();
}

class _MainSectionWidgetState extends State<MainSectionWidget> {
  String? myAddress;
  String? myDate;
  String? myWeatherCode;
  double? myLatitude;
  double? myLongitude;
  double? myTemp;
  String? myBackground;
  String? myIconImg;
  String? myRunningDuration;
  bool isLoading = true;
  bool isError = false;
  int? myAirQuality;
  double? myAirPollution;
  String? myAirType;

  void getMyLocation() async {
    setState(() {
      isLoading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        isLoading = false;
        isError = true;
      });
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

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position myLocation = await Geolocator.getCurrentPosition();
    print(myLocation.latitude);
    print(myLocation.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        myLocation.latitude, myLocation.longitude);

    print(placemarks.first.administrativeArea);

    setState(() {
      myAddress = placemarks.first.administrativeArea;
      myLatitude = myLocation.latitude;
      myLongitude = myLocation.longitude;
    });

    getMyWeather();
  }

  void getMyDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    print(formattedDate);

    setState(() {
      myDate = formattedDate;
    });
  }

  void getMyWeather() async {
    try {
      var url = Uri.https("api.openweathermap.org", "/data/2.5/weather", {
        "lat": '$myLatitude',
        'lon': '$myLongitude',
        'appid': 'b55435d1086d31e4a8465a4c6ecb8613',
        'units': 'metric',
      });

      var response = await http.get(url);
      print('Response body: ${response.body}');
      var responseBody = jsonDecode(response.body);

      print('Temp: ${responseBody['main']['temp']}');
      print('Temp: ${responseBody['weather'][0]['main']}');

      setState(() {
        myTemp = responseBody['main']['temp'];
        myWeatherCode = responseBody['weather'][0]['main'];

        if (myWeatherCode == "Clouds") {
          myBackground = "images/weather_cloudy.png";
          myIconImg = "images/icon_cloudy.png";
        } else if (myWeatherCode == "Clear") {
          myBackground = "images/weather_sunny.png";
          myIconImg = "images/icn_sunny.png";
        } else if (myWeatherCode == "Drizzle") {
          myBackground = "images/weather_drizzly.png";
          myIconImg = "images/icn_drizzly.png";
        } else if (myWeatherCode == "Thunderstorm" ||
            myWeatherCode == "Rain" ||
            myWeatherCode == "Tornado") {
          myBackground = "images/weather_rain.png";
          myIconImg = "images/icn_rainy.png";
        } else {
          myBackground = "images/weather_sunny.png";
          myIconImg = "images/icn_sunny.png";
        }
      });
      getMyAir();
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
    ;
  }

  void getMyAir() async {
    var airurl =
        Uri.https("api.openweathermap.org", "/data/2.5/air_pollution", {
      "lat": '$myLatitude',
      'lon': '$myLongitude',
      'appid': 'b55435d1086d31e4a8465a4c6ecb8613'
    });

    var airresponse = await http.get(airurl);
    var airesponseBody = jsonDecode(airresponse.body);

    print('Response body: ${airresponse.body}');

    setState(() {
      myAirQuality = airesponseBody['list'][0]['main']['aqi'];
      print(myAirQuality);
      myAirPollution = airesponseBody['list'][0]['components']['pm2_5'];
      print(myAirPollution);

      if (myAirQuality == 1) {
        myAirType = "Good";
        myRunningDuration = "Any Minute";
      } else if (myAirQuality == 2) {
        myAirType = "Fair";
        myRunningDuration = "Under 3 hour";
      } else if (myAirQuality == 3) {
        myAirType = "Moderate";
        myRunningDuration = "Under 1 hour";
      } else if (myAirQuality == 4) {
        myAirType = "Poor";
        myRunningDuration = "Under 30 minutes";
      } else if (myAirQuality == 5) {
        myAirType = "Very Poor";
        myRunningDuration = "don\'t run";
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    getMyLocation();
    getMyDate();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: Column(
              children: [
                CircularProgressIndicator(color: Colors.orange),
                SizedBox(height: 10),
                Text(
                  "If loading takes to long to complete,\nYou probably turned your GPS or Wifi off",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        : isError
            ? Container(
                height: 530,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.white,
                      size: 50,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Something Went Wrong",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            isError = false;
                          });
                          getMyWeather();
                          ;
                        },
                        child: (Text("restart",
                            style: TextStyle(color: Colors.white))))
                  ],
                ),
              )
            : Stack(
                children: [
                  Image.asset("$myBackground"),
                  Positioned(
                    bottom: 110,
                    right: 0,
                    child: Image.asset("images/image_person.png", width: 147),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: SizedBox(
                      width: 100,
                      child: TextButton(
                        onPressed: () async {
                          isLoading = true;
                          getMyLocation();
                          getMyWeather();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.orange,
                          ),
                        ),
                        child: const Text("Refresh",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Image.asset(
                          "$myIconImg",
                          height: 84,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "$myAddress | $myDate",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "$myWeatherCode",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 14,
                    left: 12,
                    right: 12,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${myTemp?.round()}°C",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Celcius",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${myAirPollution?.round()} PM",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Pollution",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$myAirType",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Level Air Quality",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MapScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.map_outlined,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("suggested running duration: "),
                                Expanded(
                                  child: Text(
                                    "$myRunningDuration",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: GestureDetector(
                                    child: const Icon(
                                      Icons.question_mark,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => runningdur(),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
  }
}
