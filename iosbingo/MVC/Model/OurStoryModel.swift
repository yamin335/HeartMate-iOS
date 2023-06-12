//
//  OurStoryModel.swift
//  iosbingo
//
//  Created by Macintosh on 15/12/22.
//

import Foundation

struct OurStoryModel: Codable {
	
	let status: String?
	let response: [Response]?
	
	private enum CodingKeys: String, CodingKey {
		case status = "status"
		case response = "response"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		response = try values.decodeIfPresent([Response].self, forKey: .response)
	}
	
}


struct Response: Codable {
	
	let id: Int?
	let date: String?
	let dateCount: String?
	let dateMedia: DateMedia?
	let title: String?
	let discoveries: Discoveries?
	let firstDate: Bool?
	
	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case date = "date"
		case dateCount = "date_count"
		case dateMedia = "date_media"
		case title = "title"
		case discoveries = "discoveries"
		case firstDate = "first_date"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		dateCount = try values.decodeIfPresent(String.self, forKey: .dateCount)
		dateMedia = try values.decodeIfPresent(DateMedia.self, forKey: .dateMedia)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		discoveries = try values.decodeIfPresent(Discoveries.self, forKey: .discoveries)
		firstDate = try values.decodeIfPresent(Bool.self, forKey: .firstDate)
	}
	
}


struct DateMedia: Codable {
	
	let type: String?
	let profileUrl: String?
	
	private enum CodingKeys: String, CodingKey {
		case type = "type"
		case profileUrl = "url"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(String.self, forKey: .type) // TODO: Add code for decoding `type`, It was null at the time of model creation.
		profileUrl = try values.decodeIfPresent(String.self, forKey: .profileUrl)
	}
	
}


struct Discoveries: Codable {
	
	let partnerADiscoveryScore: String?
	let partnerBDiscoveryScore: String?
	
	private enum CodingKeys: String, CodingKey {
		case partnerADiscoveryScore = "partner_a_discovery_score"
		case partnerBDiscoveryScore = "partner_b_discovery_score"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		partnerADiscoveryScore = try values.decodeIfPresent(String.self, forKey: .partnerADiscoveryScore)
		partnerBDiscoveryScore = try values.decodeIfPresent(String.self, forKey: .partnerBDiscoveryScore)
	}
	
}
