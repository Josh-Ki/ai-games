//
//  SceneDelegate.swift
//  AI Games
//
//  Created by Tony Ngok on 05/02/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

var userID = ""
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        window = UIWindow(windowScene: windowScene)
        // Override point for customization after application launch.
       
        let user = Auth.auth().currentUser

            // Get storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            // Set root view controller based on user status
            if user != nil {
                print("USER IS SIGNED IN")
              // User is signed in
                userID = Auth.auth().currentUser!.uid
                print(userID)
              let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
              window?.rootViewController = tabBarController
            } else {
                print("USER IS NOT SIGNED IN")
              // User is not signed in
              let authenticationViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
              window?.rootViewController = authenticationViewController
            }
        window!.makeKeyAndVisible()
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
