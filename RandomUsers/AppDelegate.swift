//
//  AppDelegate.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/22/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let injectContainer = RandomUsersAppDependencyContainer()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainVC = injectContainer.makeMainViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = mainVC
        
        UINavigationBar.appearance().barTintColor = .appUltraLightGray
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        //MARK: Eliminates black line after navigation bar
        UINavigationBar.appearance().shadowImage = UIImage()
        
        return true
    }
    
    

}

