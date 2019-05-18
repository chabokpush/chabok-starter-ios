//
//  AppDelegate.swift
//  ChabokTest
//
//  Created by Parvin Mehrabani on 8/9/1396 AP.
//  Copyright © 1396 Chabok Realtime Solutions. All rights reserved.
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
        manager?.enableLog = true
        manager?.registerApplication("chabok-starter", apiKey: "70df4ae2e1fd03518ce3e3b21ee7ca7943577749", userName: "chabok-starter", password: "chabok-starter")
        manager?.addDelegate(self)
        
        let launchByNotification = (manager?.application(application, didFinishLaunchingWithOptions: launchOptions))!
        if launchByNotification{
            print("Application was launch by clicking on Notification...")
        }
        
        if let userId = self.manager?.userId {
            self.manager?.registerUser(userId)
        } else {
            
            self.manager?.registerAsGuest()
            
            // Got to login page, verfiy user and register user with UserId.
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let starterVC = storyboard.instantiateViewController(withIdentifier: "loginUIVCID")
//            self.window?.rootViewController = starterVC
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
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("‌User was tap on notification or click on action \(response.actionIdentifier)")
        
        completionHandler()
    }
    
    func pushClientManagerDidChangedServerConnectionState (){
        let connectionState : PushClientServerConnectionState = (self.manager?.connectionState)!
        
        switch (connectionState) {
        case .connectingStartState:
            print("Init")
        case .connectingState:
            print("Connecting")
        case .connectedState:
            print("Connected")
        case .disconnectedState:
            print("Disconnected")
        case .disconnectedErrorState:
            print("Error")
        default:
            print("Unknown")
        }
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        manager?.appWillOpen(url)
        return true
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
            manager?.appWillOpen(userActivity.webpageURL)
        }
        return true
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

