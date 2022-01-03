//
//  AppDelegate.swift
//  test
//
//  Created by 박형석 on 2021/07/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MockSocketIOManager.shared.establishConnection()
        return true
    }

}

