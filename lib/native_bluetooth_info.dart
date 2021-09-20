import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// * Widget class
class BluetoothInfo extends StatefulWidget {
  const BluetoothInfo({required Key key}) : super(key: key);

  @override
  BluetoothInfoState createState() => BluetoothInfoState();
}

/// * Widget state class
/// Contains layout and logic for retrieving and updating Bluetooth status.
class BluetoothInfoState extends State<BluetoothInfo> {
  static const platform = MethodChannel('tobiasth.ntnu.edu/bluetoothcheck');

  late bool _btAvailable;
  late bool _btOn;
  String _stateInfo = 'No Bluetooth info has been retrieved yet.';
  String _lastUpdated = '';

  /// Gets Bluetooth availability from the relevant platform.
  Future<bool> _getBluetoothAvailable() async {
    final bool _available;

    try {
       _available = await platform.invokeMethod('getBluetoothAvailable');
    } on PlatformException {
      return false;
    }

    return _available;
  }

  /// Gets Bluetooth enabled status from the relevant platform.
  Future<bool> _getBluetoothOn() async {
    final bool _on;

    try {
      _on = await platform.invokeMethod('getBluetoothOn');
    } on PlatformException {
      return false;
    }

    return _on;
  }

  /// Updates the state widget once.
  void updateState() async {
    _btAvailable = await _getBluetoothAvailable();
    _btOn = await _getBluetoothOn();

    setState(() {
      _stateInfo = _getStateInfoString();
      _lastUpdated = _getLastUpdatedString();
    });
  }

  /// Gets the current Bluetooth state string.
  String _getStateInfoString() {
    String _state = 'Bluetooth is';

    if (_btAvailable) {
      _state += ' available';

      if (_btOn) {
        _state += ' and turned on.';
      } else {
        _state += ', but turned off.';
      }
    } else {
      _state += 'unavailable.';
    }

    return _state;
  }

  /// Gets the current last update string.
  String _getLastUpdatedString() {
    final _time = DateTime.now();
    final _hour = _time.hour;
    final _minute = _time.minute;
    return 'Last updated at ' +
        ((_hour < 10) ? '0' : '') +
        _hour.toString() +
        ((_minute < 10) ? ':0' : ':') +
        _minute.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _stateInfo,
          style: Theme.of(context).textTheme.subtitle1,
          textAlign: TextAlign.center,
        ),
        Text(
          _lastUpdated,
        )
      ],
    );
  }
}
