import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:running_app/screen/home_page.dart';
import 'package:running_app/screen/map_screen.dart';
import 'package:running_app/screen/running_screen.dart';
import 'package:running_app/widgets/history_section_widget.dart' as historys;
import 'package:running_app/widgets/profile_section_widget.dart';
import 'package:running_app/widgets/main_section_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int checkpoint = 1;
  double dis1 = 0;
  bool mymeter = true;

  Future<Position> _determinePosition() async {
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

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Run Now!',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.orange,
                  )),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ProfileSectionWidget(),
                SizedBox(
                  height: 12,
                ),
                MainSectionWidget(),
                SizedBox(
                  height: 12,
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: InkWell(
                //     onTap: () {},
                //     child: TextButton(
                //       onPressed: () async {
                //         Position myPosition = await _determinePosition();
                //         print(myPosition.latitude);
                //         print(myPosition.longitude);
                //         Navigator.push(
                //           context,
                //           PageRouteBuilder(
                //               transitionDuration: Duration(seconds: 1),
                //               pageBuilder:
                //                   (context, animation, secondaryAnimation) =>
                //                       RunningScreen(),
                //               transitionsBuilder: (context, animation,
                //                   secondaryAnimation, child) {
                //                 return SlideTransition(
                //                   position: Tween<Offset>(
                //                     begin: const Offset(1, 0),
                //                     end: Offset.zero,
                //                   ).animate(animation),
                //                   child: child,
                //                 );
                //               }),
                //         );
                //       },
                //       style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.resolveWith(
                //           (states) => Colors.orange,
                //         ),
                //       ),
                //       child: const Text("Mulai Lari",
                //           style: TextStyle(
                //             color: Colors.white,
                //           )),
                //     ),
                //   ),
                // ),
                // SizedBox(child: historys.HistorySectionWidget(), height: 500),
                historys.HistorySectionWidget(),
                SizedBox(
                  height: 12,
                ),
                Text("version 2.0"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
