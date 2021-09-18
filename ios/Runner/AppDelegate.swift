import UIKit
import Flutter
import CoreBluetooth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel : FlutterMethodChannel(name: "tobiasth.ntnu.edu/bluetoothcheck", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

        guard call.method == "getBluetoothAvailable" || call.method == "getBluetoothOn" else {
          result(FlutterMethodNotImplemented)
          return
        }

        switch(call.method) {
          case "getBluetoothAvailable": getBluetoothAvailable(result); return
          case "getBluetoothOn": getBluetoothOn(result); return
        }
    })

    private func getBluetoothAvailable(result: FlutterResult) {
      var manager : CBPeripheralManager?
      let options = [CBCentralManagerOptionShowPowerAlertKey:0]
      manager = CBPeripheralManager(delegate: self, queue: nil, options: options)

      switch(manager.state) {
        case .unauthorized: result(false); return
        case .unsupported: result(false); return
        case .unknown: result(false); return
        default: result(true); return
      }
    }

    private func getBluetoothOn(result: FlutterResult) {
      var manager : CBPeripheralManager?
      let options = [CBCentralManagerOptionShowPowerAlertKey:0]
      manager = CBPeripheralManager(delegate: self, queue: nil, options: options)

      result(manager.state == .poweredOn)
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
