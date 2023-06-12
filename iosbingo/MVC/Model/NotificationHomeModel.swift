//
//  NotificationHomeModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 07/10/2022.
//

import Foundation

// MARK: - Welcome
class NotificationHomeModel: Codable {
    var status: String
    var notifications: [Notification]?

    init(status: String, notifications: [Notification]?) {
        self.status = status
        self.notifications = notifications
    }
}

// MARK: - Notification
class Notification: Codable {
    var id, userID, itemID, secondaryItemID: Int
    var componentName, componentAction: String
    var senderName: String?
    var senderAvatar: String
    var dateNotified, timeSince: String
    var isNew: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case itemID = "item_id"
        case secondaryItemID = "secondary_item_id"
        case componentName = "component_name"
        case componentAction = "component_action"
        case senderName = "sender_name"
        case senderAvatar = "sender_avatar"
        case dateNotified = "date_notified"
        case timeSince = "time_since"
        case isNew = "is_new"
    }

    init(id: Int, userID: Int, itemID: Int, secondaryItemID: Int, componentName: String, componentAction: String, senderName: String?, senderAvatar: String, dateNotified: String, timeSince: String, isNew: Int) {
        self.id = id
        self.userID = userID
        self.itemID = itemID
        self.secondaryItemID = secondaryItemID
        self.componentName = componentName
        self.componentAction = componentAction
        self.senderName = senderName
        self.senderAvatar = senderAvatar
        self.dateNotified = dateNotified
        self.timeSince = timeSince
        self.isNew = isNew
    }
}

// MARK: - UnreadModel
class UnreadModel: Codable {
    var status: String
    var count: Int

    init(status: String, count: Int) {
        self.status = status
        self.count = count
    }
}
