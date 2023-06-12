//
//  AvailabilityModel.swift
//  iosbingo
//
//  Created by Gursewak singh on 11/09/22.
//

import Foundation
// MARK: - AvailabilityModel
class AvailabilityModel: Codable {
    let status : String?
    let updated : Bool?

    enum CodingKeys: String, CodingKey {
        case status
        case updated
    }

    init(status: String?, updated: Bool?) {
        self.status = status
        self.updated = updated
    }
}
