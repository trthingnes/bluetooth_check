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
  String _btInfo = 'No Bluetooth info has been retrieved yet.';
  String _lastUpdated = DateTime.now().toString();
  bool _updatesActive = false;

  /// Gets whether
  bool stateUpdatesActive() {
    return _updatesActive;
  }

  /// Enables or disables Bluetooth state updates.
  void enableStateUpdates(bool enable) {
    _updatesActive = enable;

    if (enable) {
      _btStateSubscription =
          _flutterBlue.state.listen(_getStateChangeHandler());
    } else {
      _btStateSubscription.cancel();
    }
  }

  /// Returns the function that retrieves the Bluetooth state and sets the msg.
  Function(BluetoothState) _getStateChangeHandler() {
    bool _bluetoothAvailable, _bluetoothOn;

    return (state) async => {
          _bluetoothAvailable = await _flutterBlue.isAvailable,
          _bluetoothOn = await _flutterBlue.isOn,
          setState(() {
            final _time = DateTime.now();
            _lastUpdated = 'Last updated at ' +
                _time.hour.toString() +
                ':' +
                _time.minute.toString();
            _btInfo = 'Bluetooth is';

            if (_bluetoothAvailable) {
              _btInfo += ' available';

              if (_bluetoothOn) {
                _btInfo += ' and turned on.';
              } else {
                _btInfo += ', but turned off.';
              }
            } else {
              _btInfo += 'unavailable.';
            }
          }),
        };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _btInfo,
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
