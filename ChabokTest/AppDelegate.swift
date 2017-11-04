//
//  AppDelegate.swift
//  ChabokTest
//
//  Created by Parvin Mehrabani on 8/9/1396 AP.
//  Copyright © 1396 Parvin Mehrabani. All rights reserved.
//

import UIKit
import AdpPushClient
import CoreData
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , PushClientManagerDelegate {

    var window: UIWindow?
    var manager: PushClientManager?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        manager = PushClientManager.default()
        PushClientManager.setDevelopment(true)
        manager?.registerApplication("APP_ID", apiKey: "API_KEY", userName: "SDK_USERNAME", password: "SDK_PASSWORD")
        manager?.addDelegate(self)
        
        let launchByNotification = (manager?.application(application, didFinishLaunchingWithOptions: launchOptions))!
        if launchByNotification{
            print("Application was launch by clicking on Notification...")
        }
        
        if let userId = self.manager?.userId {
            if !(self.manager?.registerUser(userId))! {
                print("Error : \(String(describing: self.manager?.failureError))")
            }
        }
        return true
    }
    //MARK : Notification AppDelegation
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.manager?.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.manager?.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        self.manager?.application(application, didRegister: notificationSettings)
    }
    
    //MARK : Register User
    
    func pushClientManagerDidRegisterUser(_ registration: Bool) {
        print(registration)
    }
    
    func pushClientManagerDidFailRegisterUser(_ error: Error!) {
        print("It was not successful! Please try again")
    }
    
    //MARK : PushClientMessage

    func pushClientManagerDidReceivedMessage(_ message: PushClientMessage!) {
        // Called When PushClientManager has been received new message from server
        if message.senderId != self.manager?.userId {
            AudioServicesPlayAlertSound(1009)
        }
    }
    
    //MARK : Push Notification

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        self.manager?.application(application, didReceive: notification)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Hook and Handle New Remote Notification, must be use for remote payloads
        manager?.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

