import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:running_app/lstorage.dart';

class RunningScreen extends StatefulWidget {
  const RunningScreen({super.key});

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen>
    with SingleTickerProviderStateMixin {
  Color scolor = Colors.orange, rcolor = Colors.orange, bcolor = Colors.orange;
  String picked = "0";
  bool fpicked = false;
  double lat2 = 0.0;
  double lon2 = 0.0;
  bool isDone = true;
  String? monthformat, yearformat, dayformat;
  int seconds = 0, minutes = 0, hours = 0;
  String digitseconds = "00", digitMinutes = "00", digitHours = "00";
  bool check = true;
  Position? pos1, pos2, pos3;
  int poss = 1;
  Timer? timer;
  Timer? addcheck, mappos;
  bool started = false, timerstart = false;
  List laps = [];
  double velocity = 0;
  double highestVelocity = 0.0;
  String textdistance = "0 Meter";
  double tmp1 = 0, tmp2 = 0, tmp3 = 0;
  double totaldistance = 0.0,
      dis1 = 0.0,
      dis2 = 0.0,
      dis3 = 0.0,
      lattpos1 = 0.0,
      lattpos2 = 0.0,
      lattpos3 = 0.0,
      lonpos1 = 0.0,
      lonpos2 = 0.0,
      lonpos3 = 0.0;

  TextEditingController _judulController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();

  void getMyLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position myLocation = await Geolocator.getCurrentPosition();
    setState(() {
      lat2 = myLocation.latitude;
      lon2 = myLocation.longitude;
      isDone = false;
      double myHeight = MediaQuery.of(context).size.height;
    });
  }

  void mapposupdate() {
    mappos = Timer.periodic(Duration(seconds: 2), (mappos) async {
      Position updateableposition = await Geolocator.getCurrentPosition();
      setState(() {
        lat2 = updateableposition.latitude;
        lon2 = updateableposition.longitude;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getMyLocation();
    mapposupdate();
    getMyDate();
  }

  // checkpoint
  void checkp() {
    addcheck = Timer.periodic(Duration(seconds: 10), (addcheck) async {
      if (poss == 1) {
        if (check) {
          pos1 = await Geolocator.getLastKnownPosition();
          check = false;
          poss++;
          Position runnpos = await Geolocator.getCurrentPosition();
          setState(() {
            lattpos1 = runnpos.latitude;
            lonpos1 = runnpos.longitude;
          });
          //siapin lattitude dan longitude variable disetiap if

        } else {
          pos1 = await Geolocator.getLastKnownPosition();
          poss++;
          Position runnpos = await Geolocator.getCurrentPosition();
          lattpos1 = runnpos.latitude;
          lonpos1 = runnpos.longitude;
          dis1 =
              Geolocator.distanceBetween(lattpos1, lonpos1, lattpos3, lonpos3);
          totaldistance += dis1;
          if (totaldistance > 999) {
            setState(() {
              tmp1 = totaldistance / 1000;
              textdistance = "${tmp1.toStringAsFixed(1)} KM";
            });
          } else {
            setState(() {
              textdistance = "${totaldistance.toStringAsFixed(1)} Meter";
            });
          }
        }
      } else if (poss == 2) {
        pos2 = await Geolocator.getLastKnownPosition();
        poss++;
        Position runnpos = await Geolocator.getCurrentPosition();
        lattpos2 = runnpos.latitude;
        lonpos2 = runnpos.longitude;
        dis2 = Geolocator.distanceBetween(lattpos2, lonpos2, lattpos1, lonpos1);
        totaldistance += dis2;
        if (totaldistance > 999) {
          setState(() {
            tmp2 = totaldistance / 1000;
            textdistance = "${tmp2.toStringAsFixed(1)} KM";
          });
        } else {
          setState(() {
            textdistance = "${totaldistance.toStringAsFixed(1)} Meter";
          });
        }
      } else if (poss == 3) {
        pos3 = await Geolocator.getLastKnownPosition();
        poss = 1;
        Position runnpos = await Geolocator.getCurrentPosition();
        lattpos3 = runnpos.latitude;
        lonpos3 = runnpos.longitude;
        dis3 = Geolocator.distanceBetween(lattpos2, lonpos2, lattpos3, lonpos3);
        totaldistance += dis3;
        if (totaldistance > 999) {
          setState(() {
            tmp3 = totaldistance / 1000;

            textdistance = "${tmp3.toStringAsFixed(1)} KM";
          });
        } else {
          setState(() {
            textdistance = "${totaldistance.toStringAsFixed(1)} Meter";
          }); //add description, judul, sama add pagex
        }
      }
    });
  }

  // stop
  void stop() {
    addcheck!.cancel();
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  //reset
  void reset() {
    addcheck!.cancel();
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitseconds = "00";
      digitMinutes = "00";
      digitHours = "00";
      started = false;
      totaldistance = 0.0;
    });
  }

  //laps
  void addlaps() {
    String lap = "$digitHours:$digitMinutes:$digitseconds";
    setState(() {
      laps.add(lap);
    });
  }

  void getMyDate() {
    var now = new DateTime.now();
    var month = new DateFormat('MMMM');
    var day = new DateFormat('dd');
    var year = new DateFormat('yyyy');
    setState(() {
      monthformat = month.format(now);
      dayformat = day.format(now);
      yearformat = year.format(now);
    });
  }

  getData() {
    print("$digitHours:$digitMinutes:$digitseconds");

    if (_judulController.text == "") {
      print("tipenull");
      return Lari(
        judul: "No Title",
        hari: "${dayformat}",
        bulan: "${monthformat}",
        tahun: "${yearformat}",
        jarak: "${textdistance}",
        waktu: "$digitHours:$digitMinutes:$digitseconds",
        deskripsi: _deskripsiController.text,
        type: "$picked",
      );
    } else {
      print("tipe normal");
      return Lari(
        judul: _judulController.text,
        hari: "${dayformat}",
        bulan: "${monthformat}",
        tahun: "${yearformat}",
        jarak: "${textdistance}",
        waktu: "$digitHours:$digitMinutes:$digitseconds",
        deskripsi: _deskripsiController.text,
        type: "$picked",
      );
    }
  }

  void swimpicked() {
    setState(() {
      picked = "3";
      scolor = Colors.blue;
      bcolor = Colors.orange;
      rcolor = Colors.orange;
    });
  }

  void runpicked() {
    setState(() {
      picked = "1";
      scolor = Colors.orange;
      bcolor = Colors.orange;
      rcolor = Colors.blue;
    });
  }

  void bpicked() {
    setState(() {
      picked = "2";
      scolor = Colors.orange;
      bcolor = Colors.blue;
      rcolor = Colors.orange;
    });
  }

  Future opensubmit() => showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              child: Column(children: [
                SizedBox(height: 8),
                Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  maxLength: 30,
                  controller: _judulController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "Title",
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _deskripsiController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 7,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    labelText: "Description",
                    hintText: "Description",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          picked = "1";
                          scolor = Colors.orange;
                          bcolor = Colors.orange;
                          rcolor = Colors.blue;
                        });
                      },
                      child: Icon(
                        Icons.directions_run_outlined,
                        color: rcolor,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          picked = "2";
                          scolor = Colors.orange;
                          bcolor = Colors.blue;
                          rcolor = Colors.orange;
                        });
                      },
                      child: Icon(
                        Icons.motorcycle_outlined,
                        color: bcolor,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          picked = "3";
                          scolor = Colors.blue;
                          bcolor = Colors.orange;
                          rcolor = Colors.orange;
                        });
                      },
                      child: Icon(
                        Icons.sailing,
                        color: scolor,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  onPressed: () {
                    mappos!.cancel();
                    print("mappos cancel");
                    timer!.cancel();
                    addcheck!.cancel();
                    stop();
                    Navigator.pop(context);
                    Navigator.pop(context, getData());
                    print("clossed by submit");
                  },
                )
              ]),
            ),
          );
        });
      });
  //start
  void start() {
    checkp();
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;

      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
          localSeconds = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }
      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitseconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        digitHours = (hours >= 10) ? "$hours" : "0$hours";
        // digitseconds = "$seconds";
        // digitMinutes = "$minutes";
        // digitHours = "$hours";
      });
    });
  }

  Future<bool>? stoprun() {
    mappos!.cancel();
    Navigator.pop(context, true);
    //bermaslaah di timer cancelnya, coba buat 2 function, 1 kalau lagi nyala, 1 kalau lagi mati
  }

  Future<bool>? stoprunned() {
    mappos!.cancel();
    timer!.cancel();
    addcheck!.cancel();
    Navigator.pop(context, true);
    //bermaslaah di timer cancelnya, coba buat 2 function, 1 kalau lagi nyala, 1 kalau lagi mati
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        print("backbutton pressed");
        if (started) {
          final myback = await stoprunned();
          return myback ?? false;
        } else {
          final myback = await stoprun();
          return myback ?? false;
        }
      },
      child: isDone
          ? Scaffold(body: Center(child: Text("This may take a while")))
          : Scaffold(
              appBar: AppBar(
                title: const Text('Running'),
                backgroundColor: Colors.orange,
                leading: BackButton(),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: (MediaQuery.of(context).size.height - 200),
                        child: FlutterMap(
                          options: MapOptions(
                            center: LatLng(lat2, lon2),
                            zoom: 18.0,
                            maxZoom: 25.0,
                            keepAlive: true,
                          ),
                          nonRotatedChildren: [
                            AttributionWidget.defaultWidget(
                              source: 'OpenStreetMap contributors',
                              onSourceTapped: null,
                            ),
                          ],
                          children: [
                            CircleLayer(circles: []),
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
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: RawMaterialButton(
                                onPressed: () {
                                  stop();
                                  opensubmit();
                                },
                                shape: StadiumBorder(
                                  side: BorderSide(color: Colors.orange),
                                ),
                                child: Text("Finish"),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showAlertDialog(context);
                                },
                                icon: Icon(
                                  Icons.flag,
                                  color: Colors.orange,
                                )),
                            Expanded(
                              child: RawMaterialButton(
                                onPressed: () {
                                  (!started) ? start() : stop();
                                },
                                fillColor: Colors.orange,
                                shape: const StadiumBorder(),
                                child: Text(
                                  (!started) ? "start" : "Pause",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                        "$digitHours:$digitMinutes:$digitseconds",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Total Time",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.add_location_sharp,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text("${textdistance}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Total Distances",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text("version 2.0"),
                    ],
                  ),
                ),
              ),
            ));
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Sorry!"),
    content: Text("Checkpoint still in progress"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
