//
//  DeleteEntryModel.swift
//  iosbingo
//
//  Created by Macintosh on 22/12/22.
//

import Foundation


struct DeleteEntryModel: Codable {
	
	let status: String?
	let success: Bool?
	
	private enum CodingKeys: String, CodingKey {
		case status = "status"
		case success = "success"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		success = try values.decodeIfPresent(Bool.self, forKey: .success)
	}
	
}

