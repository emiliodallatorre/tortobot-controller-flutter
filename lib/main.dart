import 'package:flutter/material.dart';
import 'package:tortobot_controller_flutter/interface/screen/home_screen.dart';

void main() {
  runApp(TortobotController());
}

class TortobotController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tortobot controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: <String, Widget Function(BuildContext context)>{
        HomeScreen.route: (BuildContext context) => HomeScreen(),
      },
    );
  }
}
