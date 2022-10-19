//
//  AppDelegate.swift
//  Crypto App
//
//  Created by Pazarama iOS Bootcamp on 8.10.2022.
//

import UIKit
import SnapKit
import FirebaseCore
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupFirebase()
        setupWindow()
    
        return true
    }
    
    private func setupWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = AuthViewController()
        //let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = viewController //navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
        _ = Firestore.firestore()
    }

}

