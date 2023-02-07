import UIKit
import Flutter
import Firebase
import FirebaseCore
import FirebaseStorage
import FBAudienceNetwork
import FBAEMKit
import FBSDKCoreKit_Basics
import FBSDKCoreKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    Settings.shared.isAdvertiserTrackingEnabled = true
    Settings.shared.isAdvertiserIDCollectionEnabled = true
    Settings.shared.isAutoLogAppEventsEnabled = true 
    // FBAdSettings.setAdvertiserTrackingEnabled(true)
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .badge, .sound])  { (granted, error) in
                    // Enable or disable features based on authorization.
                }
            } else {
                // REGISTER FOR PUSH NOTIFICATIONS
                let notifTypes:UIUserNotificationType  = [.alert, .badge, .sound]
                let settings = UIUserNotificationSettings(types: notifTypes, categories: nil)
                application.registerUserNotificationSettings(settings)
                application.registerForRemoteNotifications()
                application.applicationIconBadgeNumber = 0

            }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    FirebaseApp.configure()
    return true
  }
}
