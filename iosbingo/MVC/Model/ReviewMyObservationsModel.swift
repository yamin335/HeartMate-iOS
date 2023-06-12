//
//  ReviewMyObservationsModel.swift
//  iosbingo
//
//  Created by Macintosh on 19/12/22.
//

import Foundation


struct ReviewMyObservationsModel: Codable {
	
	let status: String?
	let label: String?
	let topic: String?
	let topicStatistics: Int?
	let journals: [Journals]?
	
	private enum CodingKeys: String, CodingKey {
		case status = "status"
		case label = "label"
		case topic = "topic"
		case topicStatistics = "topic_statistics"
		case journals = "journals"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		label = try values.decodeIfPresent(String.self, forKey: .label)
		topic = try values.decodeIfPresent(String.self, forKey: .topic)
		topicStatistics = try values.decodeIfPresent(Int.self, forKey: .topicStatistics)
		journals = try values.decodeIfPresent([Journals].self, forKey: .journals)
	}
	
}
struct Journals: Codable {
	
	let reviewStatus: String?
	let content: String?
	let id: Int?
	
	private enum CodingKeys: String, CodingKey {
		case reviewStatus = "review_status"
		case content = "content"
		case id = "id"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		reviewStatus = try values.decodeIfPresent(String.self, forKey: .reviewStatus)
		content = try values.decodeIfPresent(String.self, forKey: .content)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
	}
	
}
