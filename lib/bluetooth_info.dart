import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothInfo extends StatefulWidget {
  const BluetoothInfo({required Key key}) : super(key: key);

  @override
  BluetoothInfoState createState() => BluetoothInfoState();
}

class BluetoothInfoState extends State<BluetoothInfo> {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  late StreamSubscription _btStateSubscription;
  late bool _bluetoothAvailable;
  late bool _bluetoothOn;
  String _stateInfo = 'No Bluetooth info has been retrieved yet.';
  String _lastUpdated = '';
  bool _updatesActive = false;

  /// Updates the state widget once.
  void updateState() async {
    _bluetoothAvailable = await _flutterBlue.isAvailable;
    _bluetoothOn = await _flutterBlue.isOn;

    setState(() {
      _stateInfo = _getStateString(_bluetoothAvailable, _bluetoothOn);
      _lastUpdated = _getLastUpdatedString();
    });
  }

  /// Enables or disables Bluetooth state updates.
  void enableStateUpdates(bool enable) {
    _updatesActive = enable;

    if (enable) {
      _btStateSubscription =
          _flutterBlue.state.listen((state) => updateState());
    } else {
      _btStateSubscription.cancel();
    }
  }

  /// Gets whether live state updates are active or not.
  bool stateUpdatesActive() {
    return _updatesActive;
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

  /// Gets the current Bluetooth state string.
  String _getStateString(bool available, bool on) {
    String _state = 'Bluetooth is';

    if (available) {
      _state += ' available';

      if (on) {
        _state += ' and turned on.';
      } else {
        _state += ', but turned off.';
      }
    } else {
      _state += 'unavailable.';
    }

    return _state;
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
