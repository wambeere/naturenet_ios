//
//  AppDelegate.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 3/17/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewController: UIViewController?
    var frontNavController : UINavigationController? = nil


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //let mapVC = MapViewController()
        let homeVC = HomeViewController()
        let rearVC = RearViewController()
        
        frontNavController = UINavigationController(rootViewController: homeVC)
        let rearNavController = UINavigationController(rootViewController: rearVC)
        
        let revealVC: SWRevealViewController = SWRevealViewController(rearViewController: rearNavController, frontViewController: frontNavController)
        self.viewController = revealVC
        
        self.window?.rootViewController = self.viewController
        self.window?.makeKeyAndVisible()
        
        let cache = KingfisherManager.sharedManager.cache
        cache.maxDiskCacheSize = 10 * 1024 * 1024
        
        FIRApp.configure()
        
        //persistent data
        FIRDatabase.database().persistenceEnabled = true
        
        let date = NSDate(timeIntervalSince1970:Double(1460408776050)/1000)
        print(date)
        

        
//        let myRootRef = FIRAuth.auth()
//        // Write data to Firebase
//        
//        myRootRef!.createUserWithEmail("abhi@yahoooo.com", password: "password",
//                                       completion: { result, error in
//                                        
//                                        if(error != nil)
//                                        {
//                                            print(error?.debugDescription.localizedLowercaseString)
//                                            
//                                        }
//                                        else{
//                                            print(result?.uid)
//                                        }
//                                        
//            })
        
        

        /***** NSDateFormatter Part *****/
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.currentLocale()
        formatter.timeZone = NSTimeZone.localTimeZone()
        //formatter.dateFormat = "EEEE, MMMM dd yyyy"
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        formatter.timeStyle = .ShortStyle
        
        let dateString = formatter.stringFromDate(date)
        
        print(dateString)


        
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

