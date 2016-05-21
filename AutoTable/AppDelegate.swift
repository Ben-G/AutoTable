//
//  AppDelegate.swift
//  AutoTable
//
//  Created by Benji Encz on 5/21/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let userListViewController = UserListViewController(users: [
            User(username: "A"),
            User(username: "B"),
            User(username: "C"),
            User(username: "D")
        ])

        userListViewController.view.frame = UIScreen.mainScreen().bounds

        self.window?.rootViewController = userListViewController
        self.window?.makeKeyAndVisible()

        return true
    }

}
