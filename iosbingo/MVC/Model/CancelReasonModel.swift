//
//  CancelReasonModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 02/11/2022.
//

import Foundation

// MARK: - CancelReasonModel
class CancelReasonModel: Codable {
    var status: String
    var cancelReasons: [CancelReason]

    enum CodingKeys: String, CodingKey {
        case status
        case cancelReasons = "cancel_reasons"
    }

    init(status: String, cancelReasons: [CancelReason]) {
        self.status = status
        self.cancelReasons = cancelReasons
    }
}

// MARK: - CancelReason
class CancelReason: Codable {
    var id: Int
    var reasonText: String

    enum CodingKeys: String, CodingKey {
        case id
        case reasonText = "reason_text"
    }

    init(id: Int, reasonText: String) {
        self.id = id
        self.reasonText = reasonText
    }
}
