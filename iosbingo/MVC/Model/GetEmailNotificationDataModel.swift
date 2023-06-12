//
//  GetEmailNotificationDataModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 08/08/2022.
//

import Foundation

// MARK: - GetEmailNotificationDataModel
class GetEmailNotificationDataModel: Codable {
    var status, nickname, firstName, lastName: String
    var richEditing, syntaxHighlighting, commentShortcuts, adminColor: String
    var showAdminBarFront: String
    var wpCapabilities: WpCapabilities
    var subscriptionStatus, subscriptionType: String
    var sessionTokens: [String: SessionToken]
    var eventMaxDistance, level1_Score, level2_Score, myLocation: String?
    var key, newMemories, allNotifications, newDiscoveries: String
    var newInvitations, promotions, announcements, emailAllNotifications: String
    var emailNewDiscoveries, emailNewInvitations, emailNewMemories, emailPromotions: String
    var emailAnnouncements: String

    enum CodingKeys: String, CodingKey {
        case status, nickname
        case firstName = "first_name"
        case lastName = "last_name"
        case richEditing = "rich_editing"
        case syntaxHighlighting = "syntax_highlighting"
        case commentShortcuts = "comment_shortcuts"
        case adminColor = "admin_color"
        case showAdminBarFront = "show_admin_bar_front"
        case wpCapabilities = "wp_capabilities"
        case subscriptionStatus = "subscription_status"
        case subscriptionType = "subscription_type"
        case sessionTokens = "session_tokens"
        case eventMaxDistance = "event_max_distance"
        case level1_Score = "level_1_score"
        case level2_Score = "level_2_score"
        case myLocation = "my_location"
        case key
        case newMemories = "new_memories"
        case allNotifications = "all_notifications"
        case newDiscoveries = "new_discoveries"
        case newInvitations = "new_invitations"
        case promotions, announcements
        case emailAllNotifications = "email_all_notifications"
        case emailNewDiscoveries = "email_new_discoveries"
        case emailNewInvitations = "email_new_invitations"
        case emailNewMemories = "email_new_memories"
        case emailPromotions = "email_promotions"
        case emailAnnouncements = "email_announcements"
    }

    init(status: String, nickname: String, firstName: String, lastName: String, richEditing: String, syntaxHighlighting: String, commentShortcuts: String, adminColor: String, showAdminBarFront: String, wpCapabilities: WpCapabilities, subscriptionStatus: String, subscriptionType: String, sessionTokens: [String: SessionToken], eventMaxDistance: String?, level1_Score: String?, level2_Score: String?, myLocation: String?, key: String, newMemories: String, allNotifications: String, newDiscoveries: String, newInvitations: String, promotions: String, announcements: String, emailAllNotifications: String, emailNewDiscoveries: String, emailNewInvitations: String, emailNewMemories: String, emailPromotions: String, emailAnnouncements: String) {
        self.status = status
        self.nickname = nickname
        self.firstName = firstName
        self.lastName = lastName
        self.richEditing = richEditing
        self.syntaxHighlighting = syntaxHighlighting
        self.commentShortcuts = commentShortcuts
        self.adminColor = adminColor
        self.showAdminBarFront = showAdminBarFront
        self.wpCapabilities = wpCapabilities
        self.subscriptionStatus = subscriptionStatus
        self.subscriptionType = subscriptionType
        self.sessionTokens = sessionTokens
        self.eventMaxDistance = eventMaxDistance
        self.level1_Score = level1_Score
        self.level2_Score = level2_Score
        self.myLocation = myLocation
        self.key = key
        self.newMemories = newMemories
        self.allNotifications = allNotifications
        self.newDiscoveries = newDiscoveries
        self.newInvitations = newInvitations
        self.promotions = promotions
        self.announcements = announcements
        self.emailAllNotifications = emailAllNotifications
        self.emailNewDiscoveries = emailNewDiscoveries
        self.emailNewInvitations = emailNewInvitations
        self.emailNewMemories = emailNewMemories
        self.emailPromotions = emailPromotions
        self.emailAnnouncements = emailAnnouncements
    }
}

// MARK: - SessionToken
class SessionToken: Codable {
    var expiration: Int
    var ip, ua: String
    var login: Int

    init(expiration: Int, ip: String, ua: String, login: Int) {
        self.expiration = expiration
        self.ip = ip
        self.ua = ua
        self.login = login
    }
}

// MARK: - WpCapabilities
class WpCapabilities: Codable {
    var subscriber: Bool

    init(subscriber: Bool) {
        self.subscriber = subscriber
    }
}
