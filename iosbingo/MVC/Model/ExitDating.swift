//
//  ExitDating.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 25/9/22.
//

import Foundation

// MARK: - ExitDating
class ExitDating: Codable {
    var status: String
    var existReasons: [ExistReason]

    enum CodingKeys: String, CodingKey {
        case status
        case existReasons = "exist_reasons"
    }

    init(status: String, existReasons: [ExistReason]) {
        self.status = status
        self.existReasons = existReasons
    }
}

// MARK: - ExitDating
class ExitDatingStatus: Codable {
    var status: String
    var datingJourneyStatus: String

    enum CodingKeys: String, CodingKey {
        case status
        case datingJourneyStatus = "dating_journey_status"
    }

    init(status: String, datingJourneyStatus: String) {
        self.status = status
        self.datingJourneyStatus = datingJourneyStatus
    }
}

// MARK: - PlanPartner
class ExistReason: Codable {
    var id: Int
    var reason_text: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case reason_text = "reason_text"
    }

    init(id: Int, reason_text: String) {
        self.id = id
        self.reason_text = reason_text
    }
}
