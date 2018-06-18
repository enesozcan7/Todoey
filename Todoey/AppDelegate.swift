//
//  AppDelegate.swift
//  Todoey
//
//  Created by Enes Ozcan on 12.06.2018.
//  Copyright © 2018 Enes Ozcan. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do {
            _ = try Realm()
        } catch {
            print("error when creating Realm")
        }
        return true
    }
}
