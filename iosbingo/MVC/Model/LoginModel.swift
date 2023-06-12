//
//  LoginModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 23/07/2022.
//

import Foundation

// MARK: - LoginModel
class LoginModel: Codable {
    let cookie: String
    let user: User?

    init(cookie: String,user: User?) {
        self.cookie = cookie
        self.user = user
    }
}

// MARK: - User
class User: Codable {
    let id: Int?

    init(id: Int?) {
        self.id = id
    }
}
