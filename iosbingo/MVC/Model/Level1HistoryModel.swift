//
//  Level1HistoryModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 17/11/2022.
//

import Foundation

// MARK: - Level1HistoryModel
class Level1HistoryModel: Codable {
    var status: String?
    var success: Bool?
    var message: String?
    var data: [Datum]?

    init(status: String?, success: Bool?, message: String?, data: [Datum]?) {
        self.status = status
        self.success = success
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
class Datum: Codable {
    var inviteeNumber, invitationDate: String?
    var daysPending: Int?
    var invitationCode: String?
    var groupID: Int?

    enum CodingKeys: String, CodingKey {
        case inviteeNumber = "invitee_number"
        case invitationDate = "invitation_date"
        case daysPending = "days_pending"
        case invitationCode = "invitation_code"
        case groupID = "group_id"
    }

    init(inviteeNumber: String?, invitationDate: String?, daysPending: Int?, invitationCode: String?, groupID: Int?) {
        self.inviteeNumber = inviteeNumber
        self.invitationDate = invitationDate
        self.daysPending = daysPending
        self.invitationCode = invitationCode
        self.groupID = groupID
    }
}
