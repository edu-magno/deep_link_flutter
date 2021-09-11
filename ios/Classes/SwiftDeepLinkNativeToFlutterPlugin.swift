import Flutter
import UIKit

public class SwiftDeepLinkNativeToFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "deep_link_native_to_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftDeepLinkNativeToFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
