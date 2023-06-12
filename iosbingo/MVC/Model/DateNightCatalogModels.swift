//
//  DateNightCatelog.swift
//  iosbingo
//
//  Created by Gursewak singh on 01/10/22.
//

import Foundation

struct WeeklyDateNightIdea {
    var id: UUID = UUID()
    let week: String
    let ideas: [DateNightIdea]
}

struct DateNightIdea {
    var id: UUID = UUID()
    let title: String
    let subTitle: String
    let aspects: Int
}

// MARK: - DateNightCatalogResponse
struct DateNightCatalogResponse: Codable {
    let status: String?
    let dateNightCatalog: WelcomeDateNightCatalog?
    let dateNightCatalogCover: DateNightCatalogCover?
    //let error: String?

    enum CodingKeys: String, CodingKey {
        case status
        case dateNightCatalog = "date_night_catalog"
        case dateNightCatalogCover = "date_night_catalog_cover"
        //case error
    }
}

// MARK: - WelcomeDateNightCatalog
struct WelcomeDateNightCatalog: Codable {
    let dateNightCatalog: DateNightCatalog?

    enum CodingKeys: String, CodingKey {
        case dateNightCatalog = "date_night_catalog"
    }
}

// MARK: - DateNightCatalog
struct DateNightCatalog: Codable {
    let datesCount: String?
    let weeks: [DateNightWeek]

    enum CodingKeys: String, CodingKey {
        case datesCount = "dates_count"
        case weeks
    }
}

// MARK: - DateNightWeek
struct DateNightWeek: Codable {
    let weekNumber: String?
    let dates: [DateElement]

    enum CodingKeys: String, CodingKey {
        case weekNumber = "week_number"
        case dates
    }
}

// MARK: - DateElement
struct DateElement: Codable {
    let title: String?
    let dateNumber: String?
    let dateNightId: Int?
    let topics: [String]
    let setting: String?
    let experience: String?
    let activity: String?
    let possibilitiies: String?
    let imageURL: String?
    let totalAspects: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case dateNumber = "date_number"
        case dateNightId = "date_night_id"
        case topics, setting, experience, activity, possibilitiies
        case imageURL = "image_url"
        case totalAspects = "total_aspects"
    }
}

// MARK: - DateNightCatalogCover
struct DateNightCatalogCover: Codable {
    let name: Bool?
    let url: String?
}

// MARK: - DateNightCatalogDetailsResponse
struct DateNightCatalogDetailsResponse: Codable {
    var status: String?
    var date_night_id: Int?
    var setting: String?
    var experience: [String]?
    var possibilitiies: [String]?
    var image_url: String?
    var date_night_history_id: Int?
    var completed: Int?
}
