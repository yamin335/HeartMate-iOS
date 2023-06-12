//
//  WhatWorksModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 19/10/2022.
//

import Foundation

// MARK: - WhatWorksModel
class WhatWorksModel: Codable {
    var status: String
    var guides: [GuideDescripton]

    init(status: String, guides: [GuideDescripton]) {
        self.status = status
        self.guides = guides
    }
}

// MARK: - Guide
class GuideDescripton: Codable {
    var inventoryCard, invitationsCard, levelingCard, experienceCard: CardGuide

    enum CodingKeys: String, CodingKey {
        case inventoryCard = "inventory_card"
        case invitationsCard = "invitations_card"
        case levelingCard = "leveling_card"
        case experienceCard = "experience_card"
    }

    init(inventoryCard: CardGuide, invitationsCard: CardGuide, levelingCard: CardGuide, experienceCard: CardGuide) {
        self.inventoryCard = inventoryCard
        self.invitationsCard = invitationsCard
        self.levelingCard = levelingCard
        self.experienceCard = experienceCard
    }
}

// MARK: - Card
class CardGuide: Codable {
    var guideID: Int
    var headerImage: String
    var headerTitle, excerpt: String

    enum CodingKeys: String, CodingKey {
        case guideID = "guide_id"
        case headerImage = "header_image"
        case headerTitle = "header_title"
        case excerpt
    }

    init(guideID: Int, headerImage: String, headerTitle: String, excerpt: String) {
        self.guideID = guideID
        self.headerImage = headerImage
        self.headerTitle = headerTitle
        self.excerpt = excerpt
    }
}
