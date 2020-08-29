import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tortobot_controller_flutter/interface/screen/home_screen.dart';

class BluetoothConnectionState extends ChangeNotifier {
  bool isConnected = false;
  BluetoothDevice connectedDevice;
  BluetoothConnection connection;

  Future<void> connectToDevice(BluetoothDevice device) async {
    bool bondSucceeded = true;
    if (!device.isBonded) bondSucceeded = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(device.address);

    if (bondSucceeded) connection = await BluetoothConnection.toAddress(device.address);
    debugPrint("Mi sono connesso a ${device.address}.");

    connectedDevice = device;
    isConnected = true;

    notifyListeners();
  }

  Future<void> goTo(Direction direction) async {
    if (connection.isConnected) {
      debugPrint("Comando al dispositivo di andare in $direction.");

      switch (direction) {
        case Direction.LEFT:
          connection.output.add(utf8.encode("l"));
          break;
        case Direction.RIGHT:
          connection.output.add(utf8.encode("r"));
          break;
        case Direction.UP:
          connection.output.add(utf8.encode("f"));
          break;
        case Direction.DOWN:
          connection.output.add(utf8.encode("b"));
          break;
        case Direction.NONE:
          connection.output.add(utf8.encode("s"));
          break;
      }
    }
  }

  void setAutoMode(bool auto) {
    if (auto)
      connection.output.add(utf8.encode("<x10>"));
    else
      connection.output.add(utf8.encode("<x200>"));
  }
}
