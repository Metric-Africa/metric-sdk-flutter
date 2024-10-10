import Flutter;
import UIKit;
import MetricSDK;

public class SwiftFlutterMetricSdkBridgePlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "metric_sdk", binaryMessenger: registrar.messenger())
      let instance = SwiftFlutterMetricSdkBridgePlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args: [String : Any] = call.arguments as? [String : Any] ?? [String : Any]()

    print(args)
    switch call.method {
      case "initializeSdk":
        initializeSDK(args: args, result: result)
      case "launchSdk":
        guard let token = args["token"] as? String else {
          result(FlutterError(code: "ERROR", message: "Invalid token", details: nil))
          return 
        }
        launchSDK(token: token, result: result)
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  // METHOD: - initialize sdk
  private func initializeSDK(args arguments: [String: Any], result: FlutterResult){
    guard let appName = arguments["appName"] as? String else {
      result(FlutterError(code: "ERROR", message: "Invalid AppName", details: nil))
      return
    }
      
    guard let logoUrl = arguments["brandLogoUrl"] as? String else {
        result(FlutterError(code: "ERROR", message: "Invalid BrandLogoUrl", details: nil))
        return
    }
      
    guard let primaryColor = arguments["brandPrimaryColor"] as? String else {
        result(FlutterError(code: "ERROR", message: "Invalid BrandPrimaryColor", details: nil))
        return
    }
      
    guard let secretKey = arguments["secretKey"] as? String else {
        result(FlutterError(code: "ERROR", message: "Invalid SecretKey", details: nil))
        return
    }
      
    guard let clientKey = arguments["clientKey"] as? String else {
        result(FlutterError(code: "ERROR", message: "Invalid ClientKey", details: nil))
        return
    }
      
    guard let environment = arguments["environment"] as? String else {
      result(FlutterError(code: "ERROR", message: "Invalid Environment", details: nil))
      return
    }

    Metric.initialize(clientKey: clientKey, secretKey: secretKey)

   // - configure sdk
    let config = MetricSDKConfiguration()

    config.environment = environment == "dev" ? Environment.sandbox : Environment.production
    config.brandLogoImageUrl = logoUrl
    config.brandPrimaryColor = primaryColor

    MetricService.configure(config)
    MetricNotificationManager.shared.addObserver(observer: self,
                                                     selector: #selector(handleVerificationOutcome),
                                                     name: NotificationKeys.VERIFICATION_COMPLETE)
    result("success") // initialize successful
  }

  // METHOD: - launch sdk
  private func launchSDK(token: String, result: @escaping FlutterResult){
      let launcher = LaunchMetricSDK(token: token)
      DispatchQueue.main.async {
          if let rootVC = self.getRootController() {
              launcher.modalPresentationStyle = .overCurrentContext
              launcher.modalTransitionStyle = .crossDissolve
              rootVC.present(launcher, animated: true, completion: nil)
              result("success")  // success
          }
          else {
            result(FlutterError(code: "ERROR", message: "Unable to get root view controller", details: nil))
          }
      }
  }

  func getRootController() -> UIViewController? {
    let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
    let topController = keyWindow?.rootViewController
    return topController
  }
    
    @objc func handleVerificationOutcome(_ notification: Notification){
        guard let outcome = notification.object as? VerificationOutcome else {
            return
        }
        switch outcome {
            case .success:
                print("Verification successful")
            case .failed(let reason):
                print("Session failed: \(reason)")
            default:
                break
        }
    }
}
