//
//  LocationModel.swift
//  iosbingo
//
//  Created by Gursewak singh on 11/09/22.
//

import Foundation
// MARK: - LocationModel
class LocationModel: Codable {
    let status : String?
    let latitude, longitude, city, state, country, jwt : updatedValue?

    enum CodingKeys: String, CodingKey {
        case status
        case latitude, longitude, city, state, country, jwt
    }

    init(status: String?, latitude: updatedValue?, longitude: updatedValue?, city: updatedValue?, state: updatedValue?, country: updatedValue?, jwt: updatedValue?) {
        self.status = status
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.state = state
        self.country = country
        self.jwt = jwt
    }
}
