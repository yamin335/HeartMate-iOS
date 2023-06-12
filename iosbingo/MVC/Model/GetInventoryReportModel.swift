//
//  GetInventoryReportModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 31/08/2022.
//

import Foundation
// MARK: - GetInventoryReportModel
class GetInventoryReportModel: Codable {
    var status, firstName: String
    var totalPeronalityFacets, entertainment, aesthetic, spiritual: Int
    var sexual, emotional, intellectual, professional: Int
    var village: Int
    var summary: [String]
    var inventory_last_updated: String

    enum CodingKeys: String, CodingKey {
        case status
        case firstName = "first_name"
        case totalPeronalityFacets = "total_personality_facets"
        case entertainment, aesthetic, spiritual, sexual, emotional, intellectual, professional, village, summary
        case inventory_last_updated
    }

    init(status: String, firstName: String, totalPeronalityFacets: Int, entertainment: Int, aesthetic: Int, spiritual: Int, sexual: Int, emotional: Int, intellectual: Int, professional: Int, village: Int, summary: [String], inventory_last_updated: String) {
        self.status = status
        self.firstName = firstName
        self.totalPeronalityFacets = totalPeronalityFacets
        self.entertainment = entertainment
        self.aesthetic = aesthetic
        self.spiritual = spiritual
        self.sexual = sexual
        self.emotional = emotional
        self.intellectual = intellectual
        self.professional = professional
        self.village = village
        self.summary = summary
        self.inventory_last_updated = inventory_last_updated
    }
}
