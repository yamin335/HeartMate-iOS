//
//  AppDelegate.swift
//  iosbingo
//
//  Created by Hamza Saeed on 19/07/2022.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseMessaging
import FirebaseAuth
import SwiftyStoreKit
import UserNotifications
import BackgroundTasks


var deviceRegistrationToken: String?
var timer : Timer!

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]

        setupIAP()
        varifySubscription()
        requestForNotificatons(application:application)
        window = UIWindow(frame: UIScreen.main.bounds)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.tovalue.me.processing", using: nil) { task in
//            if let processingTask = task as? BGProcessingTask {
//                self.handleAppProcessing(task: processingTask)
//            }
//        }

//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.tovalue.me.appRefresh", using: nil) { task in
//            if let processingTask = task as? BGAppRefreshTask {
//                self.handleAppRefresh(task: processingTask)
//            }
//        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func requestForNotificatons(application:UIApplication){
        // Register for remote notifications. This shows a permission dialog on first run, to show the dialog at a more appropriate time move this registration accordingly.

        // [START register_for_notifications]
        if #available(iOS 10.0, *)
        {
            // For iOS 10 display notification (sent via APNS)

            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        }
        else
        {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        // [END register_for_notifications]
    }

    func varifySubscription () {
        AppPurchasesHandler.sharedInstance.verifySubsriptionGroup(sharedKey: shareSecretKey) { (isSuccess,isSubcribed,message) in
            if isSuccess{
                if isSubcribed{
                    AppUserDefault.shared.set(value: true, for: .premiumUnlocked)
                    isPremiumUnlocked = true
                }else{
                    AppUserDefault.shared.set(value: false, for: .premiumUnlocked)
                    isPremiumUnlocked = false
                }
            }else{
            }
        }
    }

    func setupIAP() {

        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in

            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
        }

        SwiftyStoreKit.updatedDownloadsHandler = { downloads in

            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }

    func scheduleAppProcessing() {
       let request = BGProcessingTaskRequest(identifier: "com.tovalue.me.processing")
       // Fetch no earlier than 15 minutes from now.
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
       request.earliestBeginDate = Date(timeIntervalSinceNow: 20 * 60)

       do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
          print("Could not schedule app processing: \(error)")
       }
    }

    func scheduleAppRefresh() {
       let request = BGAppRefreshTaskRequest(identifier: "com.tovalue.me.appRefresh")
       // Fetch no earlier than 15 minutes from now.
       request.earliestBeginDate = Date(timeIntervalSinceNow: 10 * 60)

       do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
          print("Could not schedule app refresh: \(error)")
       }
    }

//    func handleAppProcessing(task: BGProcessingTask) {
//       // Schedule a new processing task.
//
//       // Create an operation that performs the main part of the background task.
//
//       // Provide the background task with an expiration handler that cancels the operation.
//       task.expirationHandler = {
//           print("task has been expired")
//           task.setTaskCompleted(success: false)
//       }
//        DispatchQueue.global(qos: .background).async {
//            BackgroundHandler.sharedInstance.getNotificationData { success in
//                if success {
//                    print("Notification count updated in background processing")
//                    task.setTaskCompleted(success: true)
//                } else {
//                    task.setTaskCompleted(success: true)
//                }
//            }
//        }
//
//        scheduleAppProcessing()
//
//     }

    func handleAppRefresh(task: BGAppRefreshTask) {
       // Schedule a new processing task.

       // Create an operation that performs the main part of the background task.

       // Provide the background task with an expiration handler that cancels the operation.
       task.expirationHandler = {
           print("task has been expired")
           task.setTaskCompleted(success: false)
       }
        DispatchQueue.global(qos: .background).async {
            BackgroundHandler.sharedInstance.getNotificationData { success in
                if success {
                    print("Notification count updated in background fetch")
                    print("user data fetched succssfully")
                    task.setTaskCompleted(success: true)
                } else {
                    task.setTaskCompleted(success: true)
                }
            }
        }
        scheduleAppRefresh()

     }

    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        // If you are receiving a notification message while your app is in the background, this callback will not be fired till the user taps on the notification launching the application.

        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics

        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey]
        {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        // If you are receiving a notification message while your app is in the background, this callback will not be fired till the user taps on the notification launching the application.

        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics

        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey]
        {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }

    // [END receive_message]

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
	Auth.auth().setAPNSToken(deviceToken, type: .unknown)
        print("APNs token retrieved: \(deviceToken)")

        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      if Auth.auth().canHandle(url) {
        return true
      }
      // URL not auth related; it should be handled separately.
        return false
    }
    

}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate
{
    // Receive displayed notifications for iOS 10 devices.

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics

        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey]
        {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        // Change this to your preferred presentation option
        //completionHandler([])
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey]
        {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate
{
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?)
    {
        deviceRegistrationToken = fcmToken

        print("Firebase registration token: \(fcmToken ?? "")")

        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]

    // [START ios_10_data_message]

    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate)
    {
        print("Received data message: \(remoteMessage.description)")
    }
    // [END ios_10_data_message]
}
