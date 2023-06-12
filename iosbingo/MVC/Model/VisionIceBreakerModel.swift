//
//  VisionIceBreakerModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 17/12/2022.
//

import Foundation

// MARK: - VisionIceBreakerModel
class VisionIceBreakerModel: Codable {
    var status,backgroundImage: String
    var response: [IceBreakerResponse]

    enum CodingKeys: String, CodingKey {
        case backgroundImage = "icebreaker_background_image"
        case status
        case response
    }

    init(status: String, backgroundImage:String, response: [IceBreakerResponse]) {
        self.status = status
        self.backgroundImage = backgroundImage
        self.response = response
    }
}

// MARK: - Response
class IceBreakerResponse: Codable {
    var icebreakerQuestion: String

    enum CodingKeys: String, CodingKey {
        case icebreakerQuestion = "icebreaker_question"
    }

    init(icebreakerQuestion: String) {
        self.icebreakerQuestion = icebreakerQuestion
    }
}
