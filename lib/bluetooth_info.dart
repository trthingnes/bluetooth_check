import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

/// ! This file is the first version of the BluetoothInfo widget.
/// ! Please use the new version that does not require a 3rd party package.
@Deprecated("Import 'native_bluetooth_info.dart' instead")
class BluetoothInfo extends StatefulWidget {
  const BluetoothInfo({required Key key}) : super(key: key);

  @override
  BluetoothInfoState createState() => BluetoothInfoState();
}

class BluetoothInfoState extends State<BluetoothInfo> {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  late StreamSubscription _stateSubscription;
  late bool _btAvailable;
  late bool _btOn;
  String _stateInfo = 'No Bluetooth info has been retrieved yet.';
  String _lastUpdated = '';
  bool _updatesActive = false;

  /// Updates the state widget once.
  void updateState() async {
    _btAvailable = await _flutterBlue.isAvailable;
    _btOn = await _flutterBlue.isOn;

    setState(() {
      _stateInfo = _getStateInfoString();
      _lastUpdated = _getLastUpdatedString();
    });
  }

  /// Enables or disables Bluetooth state updates.
  void enableStateUpdates(bool enable) {
    _updatesActive = enable;

    if (enable) {
      _stateSubscription =
          _flutterBlue.state.listen((state) => updateState());
    } else {
      _stateSubscription.cancel();
    }
  }

  /// Gets whether live state updates are active or not.
  bool stateUpdatesEnabled() {
    return _updatesActive;
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
