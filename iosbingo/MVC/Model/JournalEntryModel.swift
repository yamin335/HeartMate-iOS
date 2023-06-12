//
//  JournalEntryModel.swift
//  iosbingo
//
//  Created by Macintosh on 22/12/22.
//

import Foundation

struct JournalEntryModel: Codable {
	
	let status: String?
	let success: Bool?
	let entry: Entry?
	
	private enum CodingKeys: String, CodingKey {
		case status = "status"
		case success = "success"
		case entry = "entry"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		success = try values.decodeIfPresent(Bool.self, forKey: .success)
		entry = try values.decodeIfPresent(Entry.self, forKey: .entry)
	}
	
}


struct Entry: Codable {
	
	let id: Int?
	let topicId: Int?
	let groupId: Int?
	let authorId: Int?
	let experienceType: String?
	let dateTime: String?
	let eventId: String?
	let eventTitle: String?
	let content: String?
	let image: String?
	let publishStatus: String?
	let reviewStatus: String?
	
	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case topicId = "topic_id"
		case groupId = "group_id"
		case authorId = "author_id"
		case experienceType = "experience_type"
		case dateTime = "date_time"
		case eventId = "event_id"
		case eventTitle = "event_title"
		case content = "content"
		case image = "image"
		case publishStatus = "publish_status"
		case reviewStatus = "review_status"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		topicId = try values.decodeIfPresent(Int.self, forKey: .topicId)
		groupId = try values.decodeIfPresent(Int.self, forKey: .groupId)
		authorId = try values.decodeIfPresent(Int.self, forKey: .authorId)
		experienceType = try values.decodeIfPresent(String.self, forKey: .experienceType)
		dateTime = try values.decodeIfPresent(String.self, forKey: .dateTime)
		eventId = try values.decodeIfPresent(String.self, forKey: .eventId)
		eventTitle = try values.decodeIfPresent(String.self, forKey: .eventTitle)
		content = try values.decodeIfPresent(String.self, forKey: .content)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		publishStatus = try values.decodeIfPresent(String.self, forKey: .publishStatus)
		reviewStatus = try values.decodeIfPresent(String.self, forKey: .reviewStatus)
	}
	
}
