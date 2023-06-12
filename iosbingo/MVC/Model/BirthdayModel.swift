//
//  BirthdayModel.swift
//  iosbingo
//
//  Created by Gursewak singh on 11/09/22.
//

import Foundation
// MARK: - BirthdayModel
class BirthdayModel: Codable {
    let status : String?
    let birthday, jwt: updatedValue?

    enum CodingKeys: String, CodingKey {
        case status
        case birthday
        case jwt
    }

    init(status: String?, birthday: updatedValue?, jwt: updatedValue?) {
        self.status = status
        self.birthday = birthday!
        self.jwt = jwt
    }
}

class updatedValue: Codable {
    let updated: Bool

    enum CodingKeys: String, CodingKey {
        case updated
    }

    init(updated: Bool) {
        self.updated = updated
    }
}
