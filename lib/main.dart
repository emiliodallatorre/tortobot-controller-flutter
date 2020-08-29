import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tortobot_controller_flutter/interface/screen/bluetooth_screen.dart';
import 'package:tortobot_controller_flutter/interface/screen/home_screen.dart';
import 'package:tortobot_controller_flutter/models/bluetooth_connection_state.dart';

void main() {
  runApp(TortobotController());
}

class TortobotController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BluetoothConnectionState>(
      create: (BuildContext context) => BluetoothConnectionState(),
      child: MaterialApp(
        title: 'Tortobot controller',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
        routes: <String, Widget Function(BuildContext context)>{
          HomeScreen.route: (BuildContext context) => HomeScreen(),
          BluetoothScreen.route: (BuildContext context) => BluetoothScreen(),
        },
      ),
    );
  }
}
