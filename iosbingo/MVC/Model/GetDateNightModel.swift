//
//  GetDateNightModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 29/08/2022.
//

import Foundation

// MARK: - GetDateNightModel
class GetDateNightModel: Codable {
    var status: String?
    var totalPeronalityFacets: Int?
    var facetDescription: String?
    var ideasTab, possibilitiesTab: [String]?

    enum CodingKeys: String, CodingKey {
        case status
        case totalPeronalityFacets = "total_peronality_facets"
        case facetDescription = "facet_description"
        case ideasTab = "ideas_tab"
        case possibilitiesTab = "possibilities_tab"
    }

    init(status: String?, totalPeronalityFacets: Int?, facetDescription: String?, ideasTab: [String]?, possibilitiesTab: [String]?) {
        self.status = status
        self.totalPeronalityFacets = totalPeronalityFacets
        self.facetDescription = facetDescription
        self.ideasTab = ideasTab
        self.possibilitiesTab = possibilitiesTab
    }
}
