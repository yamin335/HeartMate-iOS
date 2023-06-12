//
//  UpcomingEventModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 01/11/2022.
//

import Foundation

// MARK: - Upcoming Event Model
class UpcomingEventModel: Codable {
    var status: String
    var dateNightEvent: DateNightEvent

    enum CodingKeys: String, CodingKey {
        case status
        case dateNightEvent = "date_night_event"
    }

    init(status: String, dateNightEvent: DateNightEvent) {
        self.status = status
        self.dateNightEvent = dateNightEvent
    }
}

// MARK: - DateNightEvent
class DateNightEvent: Codable {
    var eventID, eventTitle, eventDescription, eventAddress: String
    var featuredImage: String
    var eventWebsite: String
    var eventStartDate, eventStartTime, eventEndDate, eventEndTime: String
    var daysUntil, datesSoFar, createdBy: String
    var isSender: Int

    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
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
        case isSender = "is_sender"
        case createdBy = "created_by"
    }

    init(eventID: String, eventTitle: String, eventDescription: String, eventAddress: String, featuredImage: String, eventWebsite: String, eventStartDate: String, eventStartTime: String, eventEndDate: String, eventEndTime: String, daysUntil: String, datesSoFar: String, createdBy: String, isSender: Int) {
        self.eventID = eventID
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
        self.createdBy = createdBy
        self.isSender = isSender
    }
}
