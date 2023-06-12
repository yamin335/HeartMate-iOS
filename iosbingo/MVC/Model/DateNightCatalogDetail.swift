//
//  DateNightCatalogDetail.swift
//  iosbingo
//
//  Created by Gursewak singh on 13/12/22.
//

import Foundation


// MARK: - DateNightCatalogDetail
struct DateNightCatalogDetail: Codable {
    let status: String
    let dateNightID, warehouseDateNightID: Int
    let setting: String
    let experience: String?
    let possibilities: String
    let imageURL: String?
    let dateNightHistoryID, completed: Int

    enum CodingKeys: String, CodingKey {
        case status
        case dateNightID = "date_night_id"
        case warehouseDateNightID = "warehouse_date_night_id"
        case setting, experience, possibilities
        case imageURL = "image_url"
        case dateNightHistoryID = "date_night_history_id"
        case completed
    }
}
