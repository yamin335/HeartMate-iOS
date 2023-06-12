//
//  DatingJoruneyJournalModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 12/10/2022.
//

import Foundation

// MARK: - DatingJourneyJournalModel
class DatingJourneyJournalModel: Codable {
    var status: String
    var journeyHome: [JourneyHome]

    enum CodingKeys: String, CodingKey {
        case status
        case journeyHome = "journey_home"
    }

    init(status: String, journeyHome: [JourneyHome]) {
        self.status = status
        self.journeyHome = journeyHome
    }
}

// MARK: - JourneyHome
class JourneyHome: Codable {
    var groupID, weekId, topicId: Int
    var level, goalDescription, partnerAvatar: String
    var partner: String
    var myAvatar: String
    var myFirstName: String
    var datingStatus: String

    enum CodingKeys: String, CodingKey {
        case groupID = "group_id"
        case level
        case goalDescription = "goal_description"
        case partnerAvatar = "partner_avatar"
        case datingStatus = "status"
        case partner
        case myAvatar = "my_avatar"
        case myFirstName = "my_first_name"
        case topicId = "topic_id"
        case weekId = "week_id"
    }

    init(groupID: Int, level: String, goalDescription: String, partnerAvatar: String, partner: String, myAvatar: String, myFirstName: String, datingStatus:String, topicId: Int, weekId: Int) {
        self.groupID = groupID
        self.level = level
        self.goalDescription = goalDescription
        self.partnerAvatar = partnerAvatar
        self.partner = partner
        self.myAvatar = myAvatar
        self.myFirstName = myFirstName
        self.datingStatus = datingStatus
        self.topicId = topicId
        self.weekId = weekId
    }
}
