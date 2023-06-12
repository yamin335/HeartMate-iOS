//
//  UserExistsModel.swift
//  iosbingo
//
//  Created by Gursewak singh on 10/09/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userExistsModel = try? newJSONDecoder().decode(UserExistsModel.self, from: jsonData)

import Foundation

// MARK: - UserExistsModel
struct UserExistsModel: Codable {
    let status, jwt, adminCookie, msg: String?
    let userID: Int?
    let registrationStatus, invitationCode, invitedBy : String?
    let inviterPicture: String?
    let inviterToValueMe, inventoryStatus, firstName: String?

    enum CodingKeys: String, CodingKey {
        case status, jwt, msg
        case adminCookie = "admin_cookie"
        case userID = "user_id"
        case registrationStatus = "registration_status"
        case invitationCode = "invitation_code"
        case invitedBy = "invited_by"
        case inviterPicture = "inviter_picture"
        case inviterToValueMe = "inviter_to_value_me"
        case inventoryStatus = "inventory_status"
        case firstName = "first_name"
    }
}
