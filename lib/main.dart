import 'package:flutter/material.dart';

import 'native_bluetooth_info.dart';

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
