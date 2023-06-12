//
//  ValidateCookieModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 27/08/2022.
//

import Foundation

// MARK: - ValidateCookieModel
class ValidateTokenModel: Codable {
    var status: String
    var is_valid_token: Bool
    
    enum CodingKeys: String, CodingKey {
        case status, is_valid_token
    }

    init(status: String, is_valid_token: Bool) {
        self.status = status
        self.is_valid_token = is_valid_token
    }
}
