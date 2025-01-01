import 'package:flutter/material.dart';
import 'package:running_app/screen/home_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  init2();
  runApp(const RunningApp());
}

void init2() async {
  await Future.delayed(Duration(milliseconds: 100));
  print("done");
  FlutterNativeSplash.remove();
} 

class RunningApp extends StatelessWidget {
  const RunningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}
