//
//  AppDelegate.swift
//  pdm
//
//  Created by Hamza Iqbal on 02/10/2020.
//

import UIKit
import GoogleSignIn
import AVKit
import Firebase
import Mixpanel
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
    var fcmToken: String = ""


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if LOCAL
            print("BUILD = Local Envioment build")
        #elseif DEV
            print("BUILD = DEV Envioment build")
        #elseif QA
            print("BUILD = QA Envioment build")
        #elseif PROD
            print("BUILD = PROD Envioment build")
        #endif
        GIDSignIn.sharedInstance().clientID = Global.shared.clientID
        IQKeyboardManager.shared.enable = true
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
        } catch let error as NSError {
            print("Setting category to AVAudioSessionCategoryPlayback failed: \(error)")
        }
        Mixpanel.initialize(token: kMixpanelInitializeToken)
        self.firebaseConfigurations(application)
        
        
        
        // Override point for customization after application launch.
        return false
    }
    func firebaseConfigurations(_ application: UIApplication){
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            self.fcmToken  = "\(token)"
          }
        }
        
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registra_ token: \(String(describing: fcmToken))")

      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    

    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
          guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
              return false
        }
        
        presentDetailViewController(compunents: components)
        return true
    }
    func presentDetailViewController(compunents:URLComponents) {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
      guard
        let detailVC = storyboard
          .instantiateViewController(withIdentifier: "resetVC")
            as? ResetPasswordViewController,
        let navigationVC = storyboard
          .instantiateViewController(withIdentifier: "NavigationController")
            as? UINavigationController
      else { return }
      
        detailVC.compunents = compunents
      navigationVC.modalPresentationStyle = .formSheet
      navigationVC.pushViewController(detailVC, animated: true)
    }


    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme,
            scheme.localizedCaseInsensitiveCompare("link") == .orderedSame,
            let view = url.host {
            
            var parameters: [String: String] = [:]
            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
            }
            
//            redirect(to: view, with: parameters)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

