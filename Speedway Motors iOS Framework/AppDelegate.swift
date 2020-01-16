//
//  AppDelegate.swift
//  Speedway Motors iOS Framework
//
//  Created by Derek Vogel on 10/30/18.
//  Copyright © 2018 Derek Vogel. All rights reserved.
//

import UIKit
import ZDCChat
import ZendeskSDK
import ZendeskCoreSDK
import ZendeskProviderSDK
import GoogleMaps
import GooglePlaces
import UserNotifications
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?

    // ##### PUSH NOTIFICATION ####
    // display push notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    // handle action on push notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "goToWebsite":
            openUrl(urlString: "https://www.speedwaymotors.com/deals")
        default:
            break
        }
        completionHandler()
        
        
    }
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSPlacesClient.provideAPIKey("AIzaSyB6GMSJFc53VK-bjRcL5vSvzIrhwYLiUgQ")
        GMSServices.provideAPIKey("AIzaSyB6GMSJFc53VK-bjRcL5vSvzIrhwYLiUgQ")
        
        //in order to connect the API to the server
        ZDCChat.initialize(withAccountKey: "68ZTovX61laIECQ2w4MZuoPmfCe3lMqZ")
        //
        //
        Zendesk.initialize(appId: "5ab2c9f619a0298bec3a7f67b2f6e7b851b36c937fe54e3b",
                           clientId: "mobile_sdk_client_ce2fc104c31b870003aa",
                           zendeskUrl: "https://csespeedwaymotors.zendesk.com")
        //
        //
        let identity = Identity.createAnonymous()
        Zendesk.instance?.setIdentity(identity)      //Adding a user identity
        //
        Support.initialize(withZendesk: Zendesk.instance)
        
        GMSServices.provideAPIKey(googleMapsKeys.apiKeys)
        //check if user is logged in
        if(UserDefaults.standard.bool(forKey: "isLoggedIn")){
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let homeScreen = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            self.window?.rootViewController = homeScreen
        }
        
        
        //receive notification alert for user inactive duration of 30 days
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AppDelegate.applicationDidTimeout(notification:)),
                                               name: .appTimeout,
                                               object: nil
        )
        

        return true
    }
    
    @objc func applicationDidTimeout(notification: NSNotification) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let loginScreen = storyboard.instantiateViewController(withIdentifier: "FifthViewController")
        self.window?.rootViewController = loginScreen
    }

    // this function handles action on notification
    func openUrl(urlString : String!) {
        if let  websiteLink = NSURL(string: urlString) {
            UIApplication.shared.open(websiteLink as URL, options: [:], completionHandler: nil)
        }
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

