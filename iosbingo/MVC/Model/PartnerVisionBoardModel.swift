//
//  PartnerVisionBoardModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 17/12/2022.
//

import Foundation

// MARK: - PartnerVisionBoardModel
class PartnerVisionBoardModel: Codable {
    var status: String
    var success: Bool
    var response: PartnerResponse

    init(status: String, success: Bool, response: PartnerResponse) {
        self.status = status
        self.success = success
        self.response = response
    }
}

// MARK: - Response
class PartnerResponse: Codable {
    var partnerMindset, seasonOfBliss, datingStyle, yourPerson: String?
    var datingMomentum, beAware: String?

    enum CodingKeys: String, CodingKey {
        case partnerMindset = "partner_mindset"
        case seasonOfBliss = "season_of_bliss"
        case datingStyle = "dating_style"
        case yourPerson = "your_person"
        case datingMomentum = "dating_momentum"
        case beAware = "be_aware"
    }

    init(partnerMindset: String?, seasonOfBliss: String?, datingStyle: String?, yourPerson: String?, datingMomentum: String?, beAware: String?) {
        self.partnerMindset = partnerMindset
        self.seasonOfBliss = seasonOfBliss
        self.datingStyle = datingStyle
        self.yourPerson = yourPerson
        self.datingMomentum = datingMomentum
        self.beAware = beAware
    }
}
