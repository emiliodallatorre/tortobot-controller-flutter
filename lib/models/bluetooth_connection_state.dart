import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothConnectionState extends ChangeNotifier {
  bool isConnected = false;
  BluetoothDevice connectedDevice;

  Future<void> connectToDevice(BluetoothDevice device) async {
    bool bondSucceeded = true;
    if (!device.isBonded) bondSucceeded = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(device.address);

    if (bondSucceeded) FlutterBluetoothSerial.instance.connect(device);

    connectedDevice = device;
    isConnected = true;

    notifyListeners();
  }
}
