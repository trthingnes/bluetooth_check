package edu.ntnu.tobiasth.bluetooth_check

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "tobiasth.ntnu.edu/bluetoothcheck";

    override fun configureFlutterEngine(flutterEngine : FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBluetoothAvailable" -> {
                    val hasBt = packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH)
                    val hasBtLe = packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
                    result.success(hasBt || hasBtLe)
                }
                "getBluetoothOn" -> {
                    val btManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
                    val offStates = listOf(BluetoothAdapter.STATE_OFF, BluetoothAdapter.STATE_TURNING_OFF)
                    result.success(btManager.adapter.state !in offStates)
                }
                else -> result.notImplemented()
            }
        }
    }
}
