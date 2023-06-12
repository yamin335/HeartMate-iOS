//
//  GetDateNightOfferModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 31/10/2022.
//

import Foundation

// MARK: - GetDateNightOfferModel
class GetDateNightOfferModel: Codable {
    var status: String
    var dateNightOffer: upcomingPlanDateNightOffer

    enum CodingKeys: String, CodingKey {
        case status
        case dateNightOffer = "date_night_offer"
    }

    init(status: String, dateNightOffer: upcomingPlanDateNightOffer) {
        self.status = status
        self.dateNightOffer = dateNightOffer
    }
}

// MARK: - DateNightOffer
class upcomingPlanDateNightOffer: Codable {
    var dateNightOfferID, dateNightTitle, dateNightDescription, location: String
    var featuredImage: String
    var eventWebsite: String
    var eventStartDate, eventStartTime, eventEndDate: String
    var eventEndTime: String?
    var isSender: Int
    var createdBy: String

    enum CodingKeys: String, CodingKey {
        case dateNightOfferID = "date_night_offer_id"
        case dateNightTitle = "date_night_title"
        case dateNightDescription = "date_night_description"
        case location
        case featuredImage = "featured_image"
        case eventWebsite = "event_website"
        case eventStartDate = "event_start_date"
        case eventStartTime = "event_start_time"
        case eventEndDate = "event_end_date"
        case eventEndTime = "event_end_time"
        case isSender = "is_sender"
        case createdBy = "created_by"

    }

    init(dateNightOfferID: String, dateNightTitle: String, dateNightDescription: String, location: String, featuredImage: String, eventWebsite: String, eventStartDate: String, eventStartTime: String, eventEndDate: String, eventEndTime: String, isSender: Int, createdBy: String) {
        self.dateNightOfferID = dateNightOfferID
        self.dateNightTitle = dateNightTitle
        self.dateNightDescription = dateNightDescription
        self.location = location
        self.featuredImage = featuredImage
        self.eventWebsite = eventWebsite
        self.eventStartDate = eventStartDate
        self.eventStartTime = eventStartTime
        self.eventEndDate = eventEndDate
        self.eventEndTime = eventEndTime
        self.isSender = isSender
        self.createdBy = createdBy
    }
}
