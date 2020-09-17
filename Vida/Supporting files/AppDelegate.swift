//
//  AppDelegate.swift
//  Vida
//
//  Created by Vida on 06/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON
//import Fabric
//import Crashlytics
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController?
    
    var login: Login?
    var tokenPush: String = ""
    var pageIdPush: String!
    var fromUserPush: String!
    var fromPush: String!
    var pushAutoLogin: String!
    
    var manager: SessionManager!
    var environment: Environment {
        return self.checkEnvironment()
    }
    
    fileprivate var enterForeground: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30 // em segundos
        manager.session.configuration.timeoutIntervalForResource = 30 // em segundos
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "VidaNotificationCenter"),
                                               object: nil, queue: nil, using: showHome)
        
        self.registerForRemoteNotification()
        
        self.configureFirebase()
        
        return true
    }
    
    fileprivate func configureFirebase() {
        #if DEBUG
            let filePath = Bundle.main.path(forResource: "GoogleService-Info-Debug", ofType: "plist")!
        #else
        #if STAGING
            let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        //        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Homolog", ofType: "plist")!
        #else
            let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        #endif
        #endif
        
        let options = FirebaseOptions(contentsOfFile: filePath)
        FirebaseApp.configure(options: options!)
        Messaging.messaging().delegate = self
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        self.tokenPush = fcmToken
    }
}

extension AppDelegate {
    fileprivate func checkEnvironment() -> Environment {
        #if RELEASE
        return Environment.release
        #else
        #if STAGING
        return Environment.staging
        #else
        return Environment.debug
        #endif
        #endif
    }
    
    fileprivate func registerForRemoteNotification() {
        let center  = UNUserNotificationCenter.current()
        center.delegate = self as? UNUserNotificationCenterDelegate
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if error == nil{
                DispatchQueue.main.async { // Correct
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    fileprivate func showHome(notification:Notification) {
        if (self.pageIdPush != nil && self.navController != nil) {
            // exibir a página Home.
            MainRouter().show(at: self.navController!)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        enterForeground = true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // fazer auto-login
        let login: String? = UserDefaults.standard.string(forKey: Constrants.kLogin)
        let password: String? = UserDefaults.standard.string(forKey: Constrants.kPassword)

        if (login != nil && password != nil) {
            // auto login
            LoginService().login(login: login!, password: password!, success: { (result) in
                self.login = result
            }) { (error) in
                // não faz nada
            }
        }
        
        pushAutoLogin = "pushAutoLogin"
        
        if (userInfo["pageId"] != nil) {
            self.pageIdPush = (userInfo["pageId"] as! String)
            if (userInfo["fromUser"] != nil) {
                self.fromUserPush = (userInfo["fromUser"] as! String)
            }
            
            if enterForeground {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "VidaNotificationCenter"), object: nil, userInfo: nil)
                enterForeground = false
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if self.pageIdPush != nil && enterForeground {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "VidaNotificationCenter"), object: nil, userInfo: nil)
            enterForeground = false
        }
    }
}
