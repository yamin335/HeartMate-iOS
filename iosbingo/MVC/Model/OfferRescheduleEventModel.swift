//
//  OfferRescheduleEventModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 01/11/2022.
//

import Foundation

// MARK: - OfferRescheduleEventModel
class OfferRescheduleEventModel: Codable {
    var status: String
    var dateNightEvent: RescheduleOfferEvent

    enum CodingKeys: String, CodingKey {
        case status
        case dateNightEvent = "date_night_event"
    }

    init(status: String, dateNightEvent: RescheduleOfferEvent) {
        self.status = status
        self.dateNightEvent = dateNightEvent
    }
}

// MARK: - DateNightEvent
class RescheduleOfferEvent: Codable {
    var rescheduleOfferID, eventTitle, eventDescription, eventAddress: String
    var featuredImage: String
    var eventWebsite: String
    var eventStartDate, eventStartTime, eventEndDate, eventEndTime: String
    var daysUntil, datesSoFar, parentEventID, createdBy: String
    var isSender: Int

    enum CodingKeys: String, CodingKey {
        case rescheduleOfferID = "reschedule_offer_id"
        case eventTitle = "event_title"
        case eventDescription = "event_description"
        case eventAddress = "event-address"
        case featuredImage = "featured_image"
        case eventWebsite = "event_website"
        case eventStartDate = "event_start_date"
        case eventStartTime = "event_start_time"
        case eventEndDate = "event_end_date"
        case eventEndTime = "event_end_time"
        case daysUntil = "days_until"
        case datesSoFar = "dates_so_far"
        case parentEventID = "parent_event_id"
        case isSender = "is_sender"
        case createdBy = "created_by"


    }

    init(rescheduleOfferID: String, eventTitle: String, eventDescription: String, eventAddress: String, featuredImage: String, eventWebsite: String, eventStartDate: String, eventStartTime: String, eventEndDate: String, eventEndTime: String, daysUntil: String, datesSoFar: String, parentEventID: String, isSender:Int, createdBy: String) {
        self.rescheduleOfferID = rescheduleOfferID
        self.eventTitle = eventTitle
        self.eventDescription = eventDescription
        self.eventAddress = eventAddress
        self.featuredImage = featuredImage
        self.eventWebsite = eventWebsite
        self.eventStartDate = eventStartDate
        self.eventStartTime = eventStartTime
        self.eventEndDate = eventEndDate
        self.eventEndTime = eventEndTime
        self.daysUntil = daysUntil
        self.datesSoFar = datesSoFar
        self.parentEventID = parentEventID
        self.isSender = isSender
        self.createdBy = createdBy
    }
}
