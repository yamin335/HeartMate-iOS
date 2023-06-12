//
//  NewJournalEntryModel.swift
//  iosbingo
//
//  Created by Macintosh on 22/12/22.
//

import Foundation


struct NewJournalEntryModel: Codable {
	
	let status: String?
	let journalEntryId: Int?
	let notification: [Int]?
	
	private enum CodingKeys: String, CodingKey {
		case status = "status"
		case journalEntryId = "journal_entry_id"
		case notification = "notification"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		journalEntryId = try values.decodeIfPresent(Int.self, forKey: .journalEntryId)
		notification = try values.decodeIfPresent([Int].self, forKey: .notification)
	}
	
}
