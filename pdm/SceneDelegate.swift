//
//  SceneDelegate.swift
//  pdm
//
//  Created by Hamza Iqbal on 02/10/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {return}
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        for userActivity in connectionOptions.userActivities {
            if let _ = userActivity.webpageURL {
                guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                let url = userActivity.webpageURL,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {return}
                if components.path.contains("forget"){
                    presentDetailViewController(compunents: components)
                    return
                }
                break
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let rootVC = storyboard.instantiateViewController(identifier: "SplashViewController") as? UIViewController else {
            print("ViewController not found")
            return
        }
//        let rootNC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootVC
        // iOS13 or later
        if #available(iOS 13.0, *) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window = self.window
        }
        window?.makeKeyAndVisible()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window = self.window
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
        let url = userActivity.webpageURL,
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {return}
        if components.path.contains("forget"){
            presentDetailViewController(compunents: components)
        }
    }
    
    func presentDetailViewController(compunents:URLComponents) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "resetVC") as? ResetPasswordViewController else { return }
        detailVC.compunents = compunents
        detailVC.modalPresentationStyle = .automatic
        self.window?.rootViewController = detailVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

