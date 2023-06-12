//
//  ProfileModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 22/07/2022.
//

import Foundation

// MARK: - ProfileModel
class ProfileModel: Codable {
    var status: String
    var id: Int
    var spectrum: Spectrum
    var subscriptionStatus, subscriptionType, subscriptionExpiryDate: String
    var matchSource: [String]
    var avatar: String
    var url, phone, email, displayname: String
    var firstname, lastname, nickname, birthday: String
    var dateNumber: Int
    var level1_Score, level2_Score, location, latitude: String
    var longitude, maxDistance, allNotifications, newMoodRings: String
    var newInvitations, newDiscoveries, promotions, announcements: String
    var emailAllNotifications, emailNewDiscoveries, emailNewInvitations, emailMoodRings: String
    var emailPromotions, emailAnnouncements, datingAvailability: String
    var inventoryCategories: [InventoryCategory]
    var profileBanner: ProfileBanner
    var invitations: Invitation
    var invitationSMSPtOne: InvitationSMSPtOne?
    var toValueMe, activeDatingJourneys, receivedObservations: ActiveDatingJourneys
    var dailyStatus: DailyStatus
    var rhythmOfLife: RhythmOfLife
    var icebreakers: Icebreakers

    enum CodingKeys: String, CodingKey {
        case status, id, spectrum
        case subscriptionStatus = "subscription_status"
        case subscriptionType = "subscription_type"
        case subscriptionExpiryDate = "subscription_expiry_date"
        case matchSource = "match_source"
        case avatar, url, phone, email, displayname, firstname, lastname, nickname, birthday
        case dateNumber = "date_number"
        case level1_Score = "level_1_score"
        case level2_Score = "level_2_score"
        case location, latitude, longitude
        case maxDistance = "max_distance"
        case allNotifications = "all_notifications"
        case newMoodRings = "new_mood_rings"
        case newInvitations = "new_invitations"
        case newDiscoveries = "new_discoveries"
        case promotions, announcements
        case emailAllNotifications = "email_all_notifications"
        case emailNewDiscoveries = "email_new_discoveries"
        case emailNewInvitations = "email_new_invitations"
        case emailMoodRings = "email_mood_rings"
        case emailPromotions = "email_promotions"
        case emailAnnouncements = "email_announcements"
        case datingAvailability = "dating_availability"
        case inventoryCategories = "inventory_categories"
        case profileBanner = "profile_banner"
        case invitations = "invitations_array"
        case toValueMe = "to_value_me"
        case activeDatingJourneys = "active_dating_journeys"
        case receivedObservations = "received_observations"
        case dailyStatus = "daily_status"
        case rhythmOfLife = "rhythm_of_life"
        case icebreakers
    }

//    init(status: String, id: Int, spectrum: Spectrum, avatar: String, url: String, phone: String, email: String, displayname: String, firstname: String, latitude: String, longitude: String ,lastname: String, nickname: String, birthday: String, dateNumber: Int, newMoodRings:String, emailMoodRings:String, level1_Score: String, level2_Score: String, location: String, maxDistance: String, allNotifications: String, newInvitations: String, newDiscoveries: String, promotions: String, announcements: String, emailAllNotifications: String, emailNewDiscoveries: String, emailNewInvitations: String, emailPromotions: String, emailAnnouncements: String, datingAvailability: String, inventoryCategories: [InventoryCategory], profileBanner: ProfileBanner, toValueMe: ActiveDatingJourneys, activeDatingJourneys: ActiveDatingJourneys, receivedObservations: ActiveDatingJourneys, dailyStatus: DailyStatus, rhythmOfLife: RhythmOfLife, icebreakers: Icebreakers, invitations: Invitation) {

    init(status: String, id: Int, spectrum: Spectrum, subscriptionStatus: String, subscriptionType: String, subscriptionExpiryDate: String, matchSource: [String], avatar: String, url: String, phone: String, email: String, displayname: String, firstname: String, lastname: String, nickname: String, birthday: String, dateNumber: Int, level1_Score: String, level2_Score: String, location: String, latitude: String, longitude: String, maxDistance: String, allNotifications: String, newMoodRings: String, newInvitations: String, newDiscoveries: String, promotions: String, announcements: String, emailAllNotifications: String, emailNewDiscoveries: String, emailNewInvitations: String, emailMoodRings: String, emailPromotions: String, emailAnnouncements: String, datingAvailability: String, inventoryCategories: [InventoryCategory], profileBanner: ProfileBanner, invitationSMSPtOne: InvitationSMSPtOne, toValueMe: ActiveDatingJourneys, activeDatingJourneys: ActiveDatingJourneys, receivedObservations: ActiveDatingJourneys, dailyStatus: DailyStatus, rhythmOfLife: RhythmOfLife, icebreakers: Icebreakers,invitations: Invitation) {

        self.status = status
        self.id = id
        self.spectrum = spectrum
        self.subscriptionStatus = subscriptionStatus
        self.subscriptionType = subscriptionType
        self.subscriptionExpiryDate = subscriptionExpiryDate
        self.matchSource = matchSource
        self.avatar = avatar
        self.url = url
        self.phone = phone
        self.email = email
        self.displayname = displayname
        self.firstname = firstname
        self.lastname = lastname
        self.nickname = nickname
        self.birthday = birthday
        self.dateNumber = dateNumber
        self.level1_Score = level1_Score
        self.level2_Score = level2_Score
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.maxDistance = maxDistance
        self.allNotifications = allNotifications
        self.newMoodRings = newMoodRings
        self.newInvitations = newInvitations
        self.newDiscoveries = newDiscoveries
        self.promotions = promotions
        self.announcements = announcements
        self.emailAllNotifications = emailAllNotifications
        self.emailNewDiscoveries = emailNewDiscoveries
        self.emailNewInvitations = emailNewInvitations
        self.emailMoodRings = emailMoodRings
        self.emailPromotions = emailPromotions
        self.emailAnnouncements = emailAnnouncements
        self.datingAvailability = datingAvailability
        self.inventoryCategories = inventoryCategories
        self.profileBanner = profileBanner
        //self.invitationSMSPtOne = invitationSMSPtOne
        self.toValueMe = toValueMe
        self.activeDatingJourneys = activeDatingJourneys
        self.receivedObservations = receivedObservations
        self.dailyStatus = dailyStatus
        self.rhythmOfLife = rhythmOfLife
        self.icebreakers = icebreakers
        self.latitude = latitude
        self.longitude = longitude
        self.invitations = invitations
    }
}

// MARK: - ActiveDatingJourneys
class ActiveDatingJourneys: Codable {
    var title: String
    var value: Int?

    init(title: String, value: Int?) {
        self.title = title
        self.value = value
    }
}

// MARK: - DailyStatus
class DailyStatus: Codable {
    var title, button: String

    init(title: String, button: String) {
        self.title = title
        self.button = button
    }
}

// MARK: - Icebreakers
class Icebreakers: Codable {
    var title, subHeading: String
    var backgroundImage: String

    enum CodingKeys: String, CodingKey {
        case title
        case subHeading = "sub_heading"
        case backgroundImage = "background_image"
    }

    init(title: String, subHeading: String, backgroundImage: String) {
        self.title = title
        self.subHeading = subHeading
        self.backgroundImage = backgroundImage
    }
}

// MARK: - InventoryCategory
class InventoryCategory: Codable {
    var categoryID: Int
    var category: String

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case category
    }

    init(categoryID: Int, category: String) {
        self.categoryID = categoryID
        self.category = category
    }
}

// MARK: - Invitation
class Invitation: Codable {
    
    var level_1: InvitationLevel
    var level_2: InvitationLevel
    var level_3: InvitationLevel
    
    enum CodingKeys: String, CodingKey {
        case level_1
        case level_2
        case level_3
    }

    init(level_1: InvitationLevel, level_2: InvitationLevel, level_3: InvitationLevel) {
        
        self.level_1 = level_1
        self.level_2 = level_2
        self.level_3 = level_3
    }
}

// MARK: - Invitation
class InvitationLevel: Codable {
    var invitation_sms_pt_one: String
    var invitation_sms_pt_two: String
    
    enum CodingKeys: String, CodingKey {
        case invitation_sms_pt_one
        case invitation_sms_pt_two
    }
    
    init(invitation_sms_pt_one: String, invitation_sms_pt_two: String) {
        self.invitation_sms_pt_one = invitation_sms_pt_one
        self.invitation_sms_pt_two = invitation_sms_pt_two
    }
}
// MARK: - InvitationSMSPtOne
class InvitationSMSPtOne: Codable {
    var level1, level2, level3: Level

    enum CodingKeys: String, CodingKey {
        case level1 = "level_1"
        case level2 = "level_2"
        case level3 = "level_3"
    }

    init(level1: Level, level2: Level, level3: Level) {
        self.level1 = level1
        self.level2 = level2
        self.level3 = level3
    }
}

// MARK: - Level
class Level: Codable {
    var invitationSMSPtOne, invitationSMSPtTwo: String

    enum CodingKeys: String, CodingKey {
        case invitationSMSPtOne = "invitation_sms_pt_one"
        case invitationSMSPtTwo = "invitation_sms_pt_two"
    }

    init(invitationSMSPtOne: String, invitationSMSPtTwo: String) {
        self.invitationSMSPtOne = invitationSMSPtOne
        self.invitationSMSPtTwo = invitationSMSPtTwo
    }
}

// MARK: - ProfileBanner
class ProfileBanner: Codable {
    var timer: Int
    var slider: PannelSlider

    init(timer: Int, slider: PannelSlider) {
        self.timer = timer
        self.slider = slider
    }
}

// MARK: - PannelSlider
class PannelSlider: Codable {
    var panels: [Panel]

    init(panels: [Panel]) {
        self.panels = panels
    }
}

// MARK: - Panel
class Panel: Codable {
    var icon: String
    var title, panelDescription: String

    enum CodingKeys: String, CodingKey {
        case icon, title
        case panelDescription = "description"
    }

    init(icon: String, title: String, panelDescription: String) {
        self.icon = icon
        self.title = title
        self.panelDescription = panelDescription
    }
}

// MARK: - RhythmOfLife
class RhythmOfLife: Codable {
    var title: String
    var lastUpdated: String?
    var backgroundImage: String

    enum CodingKeys: String, CodingKey {
        case title
        case lastUpdated = "last_updated"
        case backgroundImage = "background_image"
    }

    init(title: String, lastUpdated: String?, backgroundImage: String) {
        self.title = title
        self.lastUpdated = lastUpdated
        self.backgroundImage = backgroundImage
    }
}

// MARK: - Spectrum
class Spectrum: Codable {
    var aspectsToLife: Int
    var lastUpdated: String
    var audioFile: String

    enum CodingKeys: String, CodingKey {
        case aspectsToLife = "aspects_to_life"
        case lastUpdated = "last_updated"
        case audioFile = "audio_file"
    }

    init(aspectsToLife: Int, lastUpdated: String, audioFile: String) {
        self.aspectsToLife = aspectsToLife
        self.lastUpdated = lastUpdated
        self.audioFile = audioFile
    }
}
