import 'package:control_pad/control_pad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tortobot_controller_flutter/interface/screen/bluetooth_screen.dart';
import 'package:tortobot_controller_flutter/models/bluetooth_connection_state.dart';

class HomeScreen extends StatelessWidget {
  static const String route = "/homeScreen";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeScreenState>(
      create: (BuildContext context) => HomeScreenState(),
      child: Scaffold(
        appBar: AppBar(title: Text('Tortobot controller')),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<HomeScreenState>(
      builder: (BuildContext context, HomeScreenState homeScreenState, Widget child) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                Text("Connection state: "),
                Text(
                  Provider.of<BluetoothConnectionState>(context).isConnected ? "OK" : "NOT OK",
                  style: TextStyle(color: Provider.of<BluetoothConnectionState>(context).isConnected ? Colors.green : Colors.red),
                ),
              ],
            ),
            Expanded(
              child: JoystickView(
                onDirectionChanged: (double degrees, double distance) {
                  Direction newDirection;
                  if (degrees >= 315 || degrees < 45) newDirection = Direction.UP;
                  if (degrees >= 45 && degrees < 135) newDirection = Direction.RIGHT;
                  if (degrees >= 135 && degrees < 225) newDirection = Direction.DOWN;
                  if (degrees >= 225 && degrees < 315) newDirection = Direction.LEFT;
                  if (distance == 0) newDirection = Direction.NONE;

                  if (newDirection != homeScreenState.lastDirection) {
                    homeScreenState.setDirection(newDirection);
                    if (Provider.of<BluetoothConnectionState>(context, listen: false).isConnected)
                      Provider.of<BluetoothConnectionState>(context, listen: false).goTo(newDirection);
                  }
                },
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Switch(
                      value: homeScreenState.autoMode,
                      onChanged: (bool newValue) {
                        homeScreenState.setAutoMode(newValue);
                        Provider.of<BluetoothConnectionState>(context, listen: false).setAutoMode(homeScreenState.autoMode);
                      },
                    ),
                    Text("Auto"),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Provider.of<BluetoothConnectionState>(context).isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled),
                  onPressed: () => Navigator.of(context).pushNamed(BluetoothScreen.route),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreenState extends ChangeNotifier {
  Direction lastDirection = Direction.NONE;
  bool autoMode = true;

  void setAutoMode(bool auto) {
    this.autoMode = auto;

    notifyListeners();
  }

  void setDirection(Direction newDirection) {
    this.lastDirection = newDirection;
    debugPrint("La nuova direzione è $newDirection.");

    notifyListeners();
  }
}

enum Direction { LEFT, RIGHT, UP, DOWN, NONE }
