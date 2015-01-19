//
//  AppDelegate.swift
//  tips
//
//  Created by Alex Prokop on 1/15/15.
//  Copyright (c) 2015 Alex Prokop. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let now = NSDate()

        defaults.setObject(now, forKey: "lastClosed")
        defaults.synchronize()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        var defaults = NSUserDefaults.standardUserDefaults()
        var lastClosed : NSDate? = defaults.objectForKey("lastClosed") as? NSDate
        
        if let lastClosedDate = lastClosed {
            let now = NSDate()
            let timeSinceLastClosed: Double = now.timeIntervalSinceDate(lastClosed!)
            // Clear the saved bill amount if the app has been inactive for ten minutes.
            let invalidationInterval: Double = 600.0
            
            if timeSinceLastClosed > invalidationInterval {
                defaults.setObject("0.00", forKey: "currentBillAmount")
                defaults.synchronize()
                // Call the viewWillAppear method so the UI refreshes.
                self.window?.rootViewController?.viewWillAppear(false)
            }
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

