//
//  WhatWorksDetailModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 19/10/2022.
//

import Foundation

// MARK: - WhatWorksDetailModel
class WhatWorksDetailModel: Codable {
    var status: String
    var guide: [Guide]

    init(status: String, guide: [Guide]) {
        self.status = status
        self.guide = guide
    }
}

// MARK: - Guide
class Guide: Codable {
    var guideID: Int
    var headerImage: String
    var headerTitle, summary: String
    var tipOne, tipTwo, tipThree, tipFour: Tip?

    enum CodingKeys: String, CodingKey {
        case guideID = "guide_id"
        case headerImage = "header_image"
        case headerTitle = "header_title"
        case summary
        case tipOne = "tip_one"
        case tipTwo = "tip_two"
        case tipThree = "tip_three"
        case tipFour = "tip_four"
    }

    init(guideID: Int, headerImage: String, headerTitle: String, summary: String, tipOne: Tip?, tipTwo: Tip?, tipThree: Tip?, tipFour:Tip?) {
        self.guideID = guideID
        self.headerImage = headerImage
        self.headerTitle = headerTitle
        self.summary = summary
        self.tipOne = tipOne
        self.tipTwo = tipTwo
        self.tipThree = tipThree
        self.tipFour = tipFour
    }
}

// MARK: - Tip
class Tip: Codable {
    var tipTitle, title, tipDescription: String
    var image: String

    enum CodingKeys: String, CodingKey {
        case tipTitle = "tip_title"
        case title
        case tipDescription = "description"
        case image
    }

    init(tipTitle: String, title: String, tipDescription: String, image: String) {
        self.tipTitle = tipTitle
        self.title = title
        self.tipDescription = tipDescription
        self.image = image
    }
}
