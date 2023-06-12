//
//  DateExtensions.swift
//  iosbingo
//
//  Created by Hamza Saeed on 17/09/2022.
//

import UIKit

enum DateFormat: String {
    case Normal = "MM/dd/yyyy"
    case Dot = "MM.dd.yyyy"
    case short = "yyyy-MM-dd"
    case long = "yyyy-MM-dd HH:mm:ss"
    case longAmPm = "MM/dd/yyyy hh:mm a"
    case time = "HH:mm:ss"
    case timeAMPM = "h:mm a"
    case DOB = "MMM dd, yyyy"
    case FullDOB = "MMMM dd, yyyy"
    case ISO8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    case advance = "yyyy-MM-dd'T'HH:mm:ss"
    case advanceUTC = "yyyy-MM-dd'T'HH:mm:ss+00:00"
    case advanceUTCZ = "yyyy-MM-dd'T'HH:mm:ssZ"
    case Calender = "EEE dd, MMMM"
    case ConsultAmPm = "MM-dd-yyyy hh:mm a"
    case ConsultAmPmNotUS = "dd-MM-yyyy hh:mm a"
    case advanceFullCalendar = "EEE, MMM d, yyyy, hh:mm a"
}


/// EZSE: Initializes Date from string and format
func dateFromString(fromString string: String, format: DateFormat) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = format.rawValue
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.date(from: string) ?? nil
}

/// EZSE: Converts Date to String
func stringFromDate(date: Date, format: DateFormat) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format.rawValue
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: date)
}

