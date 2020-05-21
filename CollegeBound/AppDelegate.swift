//
//  AppDelegate.swift
//  CollegeBound
//
//  Created by Thomas Davey on 17/05/2020.
//  Copyright © 2020 Thomas Davey. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        UIApplication.shared.statusBarStyle = .darkContent

        return true
    }

}

