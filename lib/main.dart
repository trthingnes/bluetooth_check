import 'package:flutter/material.dart';

import 'native_bluetooth_info.dart';

void main() {
  runApp(const BluetoothCheckApp());
}

/// * App class
/// Sets application wide settings and builds app home.
class BluetoothCheckApp extends StatelessWidget {
  const BluetoothCheckApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Check',
      home: const BluetoothCheckHome(title: 'Bluetooth Check'),
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// * Home class
class BluetoothCheckHome extends StatefulWidget {
  const BluetoothCheckHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<BluetoothCheckHome> createState() => _BluetoothCheckHomeState();
}

/// * Home state class
/// Builds app layout and contains state.
class _BluetoothCheckHomeState extends State<BluetoothCheckHome> {
  // This key allows for communication with the bluetooth_info widget.
  final GlobalKey<BluetoothInfoState> _btInfoKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.title),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Icon(
                Icons.bluetooth,
                size: 80,
                color: Theme.of(context).primaryColor,
                semanticLabel: "Bluetooth Icon",
              ),
            ),
            BluetoothInfo(
              key: _btInfoKey,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
              child: ElevatedButton(
                child: const Text('Retrieve Bluetooth state'),
                onPressed: () => _btInfoKey.currentState!.updateState(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
