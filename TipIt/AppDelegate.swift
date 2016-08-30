//
//  AppDelegate.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 8/27/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        print(#function)
        
        // Test UserManager
        let user = UserManager()
        user.setPercentAtIndex(0, value: 0.1)
        user.setPercentAtIndex(1, value: 0.15)
        user.setPercentAtIndex(2, value: 0.2)
        user.setTheme(true)
        print("\(user.getPercents())\t [0.1, 0.15, 0.2] is expected\n")
        print("\(user.getTheme())\t true is expected\n")
        user.setPercentAtIndex(0, value: 6)
        print("\(user.getPercents()) [6, 0.15, 0.2] is expected\n")
        print("\(user.getPercentAtIndex(0))\t 0.6 is expected")
        print("\(user.getPercentAtIndex(1))\t 0.15 is expected")
        print("\(user.getPercentAtIndex(2))\t 0.2 is expected")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

