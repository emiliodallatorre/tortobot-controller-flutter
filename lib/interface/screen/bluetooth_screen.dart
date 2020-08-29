import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:tortobot_controller_flutter/interface/widget/bluetooth_list_tile.dart';
import 'package:tortobot_controller_flutter/models/bluetooth_connection_state.dart';

class BluetoothScreen extends StatelessWidget {
  static const String route = "/bluetoothScreen";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BluetoothScreenState>(
      create: (BuildContext context) => BluetoothScreenState(),
      builder: (BuildContext context, Widget child) => Scaffold(
        appBar: AppBar(
          title: Text("Bluetooth manager"),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: Provider.of<BluetoothScreenState>(context).isDiscovering
                  ? null
                  : () => Provider.of<BluetoothScreenState>(context, listen: false).startDiscovery(),
            ),
          ],
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<bool>(
      future: FlutterBluetoothSerial.instance.isEnabled,
      builder: (BuildContext context, AsyncSnapshot<bool> bluetoothAvailabilitySnapshot) {
        if (bluetoothAvailabilitySnapshot.hasData) {
          if (bluetoothAvailabilitySnapshot.data) {
            return Consumer<BluetoothScreenState>(
              builder: (BuildContext context, BluetoothScreenState bluetoothScreenState, Widget child) => ListView.builder(
                itemCount: bluetoothScreenState.results.length,
                // shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return BluetoothListTile(
                    device: bluetoothScreenState.results.elementAt(index).device,
                    rssi: bluetoothScreenState.results.elementAt(index).rssi,
                    onTap: () async {
                      await Provider.of<BluetoothConnectionState>(context, listen: false).connectToDevice(bluetoothScreenState.results.elementAt(index).device);
                      bluetoothScreenState.startDiscovery();
                    },
                  );
                },
              ),
            );
          }

          return Center(child: Text("Your bluetooth seems not to be available, please activate it and try again"));
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class BluetoothScreenState extends ChangeNotifier {
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  StreamSubscription discoveryStream;
  bool isDiscovering = false;

  void addNewResult(BluetoothDiscoveryResult newResult) {
    if (newResult.device != null) {
      if (results.where((BluetoothDiscoveryResult result) => result.device.address == newResult.device.address).isEmpty) {
        debugPrint("Aggiungo il nuovo risultato.");

        results.add(newResult);

        notifyListeners();
      } else {
        debugPrint("Aggiorno il precedente risultato.");

        results.remove(results.where((BluetoothDiscoveryResult result) => result.device.address == newResult.device.address).single);
        results.add(newResult);

        notifyListeners();
      }
    }
  }

  Future<void> startDiscovery() async {
    isDiscovering = true;
    notifyListeners();

    results.clear();
    debugPrint("Svuoto i risultati.");
    notifyListeners();

    discoveryStream = FlutterBluetoothSerial.instance.startDiscovery().listen((newResult) => addNewResult(newResult));

    discoveryStream.onDone(() {
      isDiscovering = false;
      notifyListeners();
    });
  }

  @override
  dispose() {
    discoveryStream?.cancel();

    super.dispose();
  }
}
