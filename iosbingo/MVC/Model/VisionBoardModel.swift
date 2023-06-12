//
//  VisionBoardModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 12/12/2022.
//

import Foundation

// MARK: - VisionBoardModel
class VisionBoardModel: Codable {
    var status: String
    var success: Bool
    var response: VisionBoardResponse

    init(status: String, success: Bool, response: VisionBoardResponse) {
        self.status = status
        self.success = success
        self.response = response
    }
}

// MARK: - Response
class VisionBoardResponse: Codable {
    var mindsetForm, adultingSeasonForm, seasonOfBlissForm, datingStyleForm: [Form]
    var userMindset, userAdultingSeasonPrimary, userAdultingSeasonSecondary, userBlissPrimary: String
    var userBlissSecondary: String
    var userDatingStyle: [Form]?
    var visionBoardID: Int

    enum CodingKeys: String, CodingKey {
        case mindsetForm = "mindset_form"
        case adultingSeasonForm = "adulting_season_form"
        case seasonOfBlissForm = "season_of_bliss_form"
        case datingStyleForm = "dating_style_form"
        case userMindset = "user_mindset"
        case userAdultingSeasonPrimary = "user_adulting_season_primary"
        case userAdultingSeasonSecondary = "user_adulting_season_secondary"
        case userBlissPrimary = "user_bliss_primary"
        case userBlissSecondary = "user_bliss_secondary"
        case userDatingStyle = "user_dating_style"
        case visionBoardID = "vision_board_id"
    }

    init(mindsetForm: [Form], adultingSeasonForm: [Form], seasonOfBlissForm: [Form], datingStyleForm: [Form], userMindset: String, userAdultingSeasonPrimary: String, userAdultingSeasonSecondary: String, userBlissPrimary: String, userBlissSecondary: String, userDatingStyle: [Form]?, visionBoardID: Int) {
        self.mindsetForm = mindsetForm
        self.adultingSeasonForm = adultingSeasonForm
        self.seasonOfBlissForm = seasonOfBlissForm
        self.datingStyleForm = datingStyleForm
        self.userMindset = userMindset
        self.userAdultingSeasonPrimary = userAdultingSeasonPrimary
        self.userAdultingSeasonSecondary = userAdultingSeasonSecondary
        self.userBlissPrimary = userBlissPrimary
        self.userBlissSecondary = userBlissSecondary
        self.userDatingStyle = userDatingStyle
        self.visionBoardID = visionBoardID
    }
}

// MARK: - Form
class Form: Codable {
    var title, definition: String
    var headerTitle: String?
    var isSelected: Bool? = false

    enum CodingKeys: String, CodingKey {
        case headerTitle = "header_title"
        case title, definition
    }

    init(title: String, definition: String, isSelected: Bool?, headerTitle:String?) {
        self.title = title
        self.definition = definition
        self.isSelected = isSelected
        self.headerTitle = headerTitle
    }
}

// MARK: - UserDatingStyle
class UserDatingStyle: Codable {
    var userOrder: Int
    var headerTitle: String
    var title, definition: String

    enum CodingKeys: String, CodingKey {
        case headerTitle = "header_title"
        case userOrder = "user_order"
        case title, definition
    }

    init(userOrder: Int, title: String, definition: String, headerTitle:String) {
        self.userOrder = userOrder
        self.title = title
        self.definition = definition
        self.headerTitle = headerTitle
    }
}
