//
//  LogOffModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 26/10/2022.
//

import Foundation

// MARK: - LogOff
class LogOff: Codable {
    var status, passedHeaderCookie, previousStatus, newStatus: String
    var shouldBeFalse, isHeaderCookie: Bool

    enum CodingKeys: String, CodingKey {
        case status
        case passedHeaderCookie = "passed_header_cookie"
        case previousStatus = "previous_status"
        case newStatus = "new_status"
        case shouldBeFalse = "should_be_false"
        case isHeaderCookie = "is_header_cookie"
    }

    init(status: String, passedHeaderCookie: String, previousStatus: String, newStatus: String, shouldBeFalse: Bool, isHeaderCookie: Bool) {
        self.status = status
        self.passedHeaderCookie = passedHeaderCookie
        self.previousStatus = previousStatus
        self.newStatus = newStatus
        self.shouldBeFalse = shouldBeFalse
        self.isHeaderCookie = isHeaderCookie
    }
}
