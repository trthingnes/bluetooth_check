import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(const BluetoothCheckApp());
}

class BluetoothCheckApp extends StatelessWidget {
  const BluetoothCheckApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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

class BluetoothCheckHome extends StatefulWidget {
  const BluetoothCheckHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<BluetoothCheckHome> createState() => _BluetoothCheckHomeState();
}

class _BluetoothCheckHomeState extends State<BluetoothCheckHome> {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  StreamSubscription? _btStateSubscription;
  bool streamPaused = false;
  String _btInfo = 'Bluetooth state updates are disabled.';

  void _setStateSubscription() {
    bool _bluetoothAvailable, _bluetoothOn;
    _btStateSubscription = _flutterBlue.state.listen((state) async => {
      _bluetoothAvailable = await _flutterBlue.isAvailable,
      _bluetoothOn = await _flutterBlue.isOn,

      setState(() {
        _btInfo = 'Bluetooth is ' +
            (_bluetoothAvailable
                ? 'available' +
                (_bluetoothOn ? ' and enabled.' : ', but disabled.')
                : 'not available.');
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enable Bluetooth state updates',
                ),
                Switch(
                  value: streamPaused,
                  onChanged: (bool value) {
                    setState(() {
                      value ? _setStateSubscription() : _btStateSubscription!.cancel();
                      _btInfo = 'Bluetooth state updates are disabled.';
                      streamPaused = value;
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                _btInfo,
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
