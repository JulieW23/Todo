//
//  AppDelegate.swift
//  Todo
//
//  Created by Julie Wang on 2018-08-21.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var notifCenter: UNUserNotificationCenter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        notifCenter = UNUserNotificationCenter.current()
        notifCenter?.requestAuthorization(options: [.alert, .sound]) { (granted, error) in }

        return true
    }
}

extension UIViewController: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
