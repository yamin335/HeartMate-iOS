//
//  RegistrationModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 20/07/2022.
//

import Foundation
// MARK: - RegistrationModel
class RegistrationModel: Codable {
    var status, iss, jwt: String?
    var userID: Int?
    var username: String?

    enum CodingKeys: String, CodingKey {
        case status, iss, jwt
        case userID = "user_id"
        case username
    }

    init(status: String?, iss: String?, jwt: String?, userID: Int?, username: String?) {
        self.status = status
        self.iss = iss
        self.jwt = jwt
        self.userID = userID
        self.username = username
    }
}

