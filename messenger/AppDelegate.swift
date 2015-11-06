//
//  AppDelegate.swift
//  messenger
//
//  Created by Zarif Safiullin on 21/08/15.
//  Copyright (c) 2015 Zaph. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import MagicalRecord


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var ping: Ping!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(
            forTypes: [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound],
            categories: nil))
        
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed("messenger.sqlite")
        
        // Display UILocalNotification if application was not running.
        if let options = launchOptions {
            if let notif = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
                self.application(application, didReceiveLocalNotification: notif)
            }
        }
        
        ping = Ping.sharedInstance

        let command = PingCommand(name: "get", defaultParams: ["count": "\(Manager.sharedInstance.newMessageCount)"],
                prepareBlock: { json in

                    NSNotificationCenter.defaultCenter().postNotificationName(WXNotifications.NewMessageReceived.rawValue, object: nil, userInfo:
                        [
                            "newMessageCount": 1
                        ])
                    
                return true
            },
    
            completeBlock: { json in
                
                if let newMessageCount = json["new_message_count"].int {
                    Manager.sharedInstance.newMessageCount = newMessageCount
                    NSNotificationCenter.defaultCenter().postNotificationName(WXNotifications.NewMessageReceived.rawValue, object: nil, userInfo:
                        [
                            "newMessageCount": newMessageCount
                        ])
                }
                
//                var localNotification = UILocalNotification()
//                localNotification.alertAction = "You have new message"
//                localNotification.alertBody = "Admin says: Hello"
//                localNotification.alertTitle = "Some title"
//                localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
//                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                
            return true
        })
        
        ping.addCommand(command)
        ping.start()
        
        let params = ["userId":1]

        HttpClient.sharedInstance.sendRequest(HttpClient.accountInfoUrl, parameters: params) { response in
            switch(response){
            case .Success(let json):
                if let backgroundColor = json["data"]["backgroundColor"].string,
                    let tintColor = json["data"]["tintColor"].string {
                        Settings.sharedInstance.backgroundColor = UIColor(hex: backgroundColor)
                        Settings.sharedInstance.tintColor = UIColor(hex: tintColor)
                }
            case .Error(let error):
                NSLog("accountInfoUrl .Error: \(error)")
            }
        }
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
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
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        MagicalRecord.cleanUp()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        NSLog("AppDelegate.didReceiveLocalNotification")
//        let notificationCenter = NSNotificationCenter.defaultCenter()
//        notificationCenter.postNotificationName(kAdFromNotification, object: nil, userInfo: notification.userInfo)
        
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        NSLog("AppDelegate.didRegisterUserNotificationSettings: \(notificationSettings.debugDescription)")
    }
    
//    
//    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
//        log.debug("handleActionWithIdentifier \(identifier)")
//        
//        let info = notification.userInfo as? Dictionary<String,String>
//        
//        if let hash = info?["groupUniqueHash"] {
//            log.debug("handleActionWithIdentifier hash -> \(hash)")
//            
//            let group = AdGroup.MR_findFirstByAttribute("uniqueHash", withValue: hash)
//            if group == nil {
//                log.debug("handleActionWithIdentifier hash -> \(hash). Group is nill")
//                return
//            }
//            
//            if let ad = group.sortedAds.first where identifier == "favorite" {
//                ad.bookmarked = true
//                log.debug("handleActionWithIdentifier bookmarked!")
//            }
//            
//            if identifier == "snooze" {
//                group.snooze()
//                log.debug("handleActionWithIdentifier snoozed!")
//            }
//            
//        } else {
//            log.debug("handleActionWithIdentifier No groupUniqueHash")
//        }
//        
//        completionHandler()
//    }
//    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {

//        completionHandler(.NewData)
        
    }

}

