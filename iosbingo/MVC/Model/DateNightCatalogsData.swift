//
//  DateNightCatalogModel.swift
//  iosbingo
//
//  Created by Gursewak singh on 09/12/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dateNightCatalogsData = try? newJSONDecoder().decode(DateNightCatalogsData.self, from: jsonData)

import Foundation

// MARK: - DateNightCatalogsData
struct DateNightCatalogsData: Codable {
    let status, dateCount : String
    let dateNightCatalog: [DateNightCatalogs]
    let dateNightCatalogCover: DateNightCatalogCovers

    enum CodingKeys: String, CodingKey {
        case status
        case dateCount = "date_count"
        case dateNightCatalog = "date_night_catalog"
        case dateNightCatalogCover = "date_night_catalog_cover"
    }
}

// MARK: - DateNightCatalog
struct DateNightCatalogs: Codable {
    let weekNumber: String
    let dates: [DateElements]

    enum CodingKeys: String, CodingKey {
        case weekNumber = "week_number"
        case dates
    }
}

// MARK: - DateElement
struct DateElements: Codable {
    let title, dateNumber: String
    let dateNightID: Int
    let topics: [String]
    let setting: String
    let experience: String?
    let activity, possibilitiies: String
    let imageURL: String?
    let totalAspects: Int

    enum CodingKeys: String, CodingKey {
        case title
        case dateNumber = "date_number"
        case dateNightID = "date_night_id"
        case topics, setting, experience, activity, possibilitiies
        case imageURL = "image_url"
        case totalAspects = "total_aspects"
    }
}

// MARK: - DateNightCatalogCover
struct DateNightCatalogCovers: Codable {
    let name: Bool
    let url: String
}


// MARK: - DateNightCatalogsData
struct DateNightCatalogPartnerData: Codable {
    let status: String
    let dateCount : Int
    let dateNightCatalog: [DateNightCatalogs]
    let dateNightCatalogCover: DateNightCatalogPartnerCover

    enum CodingKeys: String, CodingKey {
        case status
        case dateCount = "date_count"
        case dateNightCatalog = "date_night_catalog"
        case dateNightCatalogCover = "date_night_catalog_cover"
    }
}

// MARK: - DateNightCatalogCover
struct DateNightCatalogPartnerCover: Codable {
    let name: String
    let url: String
}

