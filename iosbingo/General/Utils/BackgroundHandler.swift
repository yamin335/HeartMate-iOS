//
//  BackgroundHandler.swift
//  iosbingo
//
//  Created by Hamza Saeed on 17/10/2022.
//

import UIKit
import Alamofire
import UserNotifications

public typealias IsCompletion = (_ isConnected: Bool?) -> Void

class BackgroundHandler: NSObject {

    var completion: IsCompletion?
    static let sharedInstance = BackgroundHandler()

    func scheduleLocal() {
        /* Disabling Notifications
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Health Data Fetched"
        content.body = "Your health data has been fetched from the store"
        content.sound = UNNotificationSound.default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        */
    }

    func scheduleForLabDateSentFailed() {
        /* Disabling Notifications
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "(LABS) Failed"
        content.body = "Labs data could not send"
        content.sound = UNNotificationSound.default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        */
    }

    func scheduleForLabDateSent() {
        /* Disabling Notifications
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "(LABS) Congratulation"
        content.body = "Labs data sent successfully"
        content.sound = UNNotificationSound.default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        */
    }

    func scheduleForMedDateSent() {
        /* Disabling Notifications
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "(MEDS) Congratulation"
        content.body = "Meds data sent successfully"
        content.sound = UNNotificationSound.default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        */
    }

    // MARK: - API Functions
    func getNotificationData(completion: @escaping (_ success: Bool) -> Void){
        API.shared.ValidateToken { isValid in
            if isValid{
                let cookie = AppUserDefault.shared.getValue(for: .Cookie)
                let params = ["is_new":"true"] as [String:Any]
                API.shared.sendData(url: APIPath.notification, requestType: .post, params: params, objectType: NotificationHomeModel.self) { (data,status)  in
                    if status {
                        guard let notificationDate = data else {
                            return}
                        if let notifications = notificationDate.notifications {
                            AppUserDefault.shared.set(value: notifications.count, for: .unreadCount)
                            print("notifications count is \(notifications.count)")
                            completion(true)
                        }else{
                            AppUserDefault.shared.set(value: 0, for: .unreadCount)
                            completion(true)
                        }
                    }else{
                        print("Error found in get Notification API")
                        completion(false)
                    }
                }
            }else{
                print("Cookie expired")
                completion(false)
            }
        }
    }

}
