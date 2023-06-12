//
//  MasterPlanModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 17/09/2022.
//

import Foundation

// MARK: - MasterPlanModel
class MasterPlanModel: Codable {
    var status: String?
    var user: [UserModel]?
    var journeyDetails: [JourneyDetail]?
    var partners: [PlanPartner]?

    enum CodingKeys: String, CodingKey {
        case status
        case partners
        case journeyDetails = "journey_details"
        case user = "groups"
    }

    init(status: String?, partners: [PlanPartner]?, user: [UserModel]?, journeyDetails: [JourneyDetail]?) {
        self.status = status
        self.partners = partners
        self.user = user
        self.journeyDetails = journeyDetails
    }
}

// MARK: - JourneyDetail
class JourneyDetail: Codable {
    var totalWeeks, names: String

    enum CodingKeys: String, CodingKey {
        case totalWeeks = "total_weeks"
        case names
    }

    init(totalWeeks: String, names: String) {
        self.totalWeeks = totalWeeks
        self.names = names
    }
}

// MARK: - PlanPartner
class PlanPartner: Codable {
    var timeOfDay: String?
    var plans: [Plan]?

    enum CodingKeys: String, CodingKey {
        case timeOfDay = "time_of_day"
        case plans
    }

    init(timeOfDay: String?, plans: [Plan]?) {
        self.timeOfDay = timeOfDay
        self.plans = plans
    }
}

// MARK: - Plan
class Plan: Codable {
    var id: Int?
    var date, startTime, excerpt, type: String?
    var groupID: Int?
    var colorCode: String?
    var firstName: String?
    var avatar: String?

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case startTime = "start_time"
        case excerpt
        case groupID = "group_id"
        case colorCode = "color_code"
        case firstName = "first_name"
        case avatar
        case type
    }

    init(id: Int?, date: String?, startTime: String?, excerpt: String?, type: String?, groupID: Int?, colorCode: String?, firstName: String?, avatar: String?) {
        self.id = id
        self.date = date
        self.startTime = startTime
        self.excerpt = excerpt
        self.groupID = groupID
        self.colorCode = colorCode
        self.firstName = firstName
        self.avatar = avatar
        self.type = type
    }
}

// MARK: - User
class UserModel: Codable {
    var firstName: String?
    var groupID: Int?
    var colorCode: String?
    var isSelected: Bool? = false

    enum CodingKeys: String, CodingKey {
        case firstName, groupID
        case colorCode = "color_code"
    }

    init(firstName: String?, groupID: Int?, colorCode: String?, isSelected: Bool) {
        self.firstName = firstName
        self.groupID = groupID
        self.colorCode = colorCode
        self.isSelected = isSelected
    }
}

class CustomMasterPlanModel{
    var timeOfDay:String
    var plans: [CustomPlan]

    init(timeOfDay:String,plans:[CustomPlan]) {
        self.timeOfDay = timeOfDay
        self.plans = plans
    }
}

// MARK: - Custom Plan
class CustomPlan {
    var bookingID: Int
    var date, startTime, excerpt, type: String
    var groupID: Int
    var colorCode, firstName: String
    var avatar: String

    init(bookingID: Int, date: String, startTime: String, excerpt: String, groupID: Int, colorCode: String, firstName: String, avatar: String, type: String) {
        self.bookingID = bookingID
        self.date = date
        self.startTime = startTime
        self.excerpt = excerpt
        self.groupID = groupID
        self.colorCode = colorCode
        self.firstName = firstName
        self.avatar = avatar
        self.type = type
    }
}
