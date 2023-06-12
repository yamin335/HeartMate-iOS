
import Foundation

struct UpdateDatingJournalModel: Codable {
	
	let status: String?
	let partnerId: Int?
	let partnerImage: String?
	let name: String?
	let totalDatesSoFar: Int?
	let dateNumber: String?
	let discoverAspectRatio: String?
	let experienceTypes: [String]?//ExperienceTypes?
	let inventoryCategories: [InventoryCategories]?
	
	private enum CodingKeys: String, CodingKey {
		case status = "status"
		case partnerId = "partner_id"
		case partnerImage = "partner_image"
		case name = "name"
		case totalDatesSoFar = "total_dates_so_far"
		case dateNumber = "date_number"
		case discoverAspectRatio = "discover_aspect_ratio"
		case experienceTypes = "experience_types"
		case inventoryCategories = "inventory_categories"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		partnerId = try values.decodeIfPresent(Int.self, forKey: .partnerId)
		partnerImage = try values.decodeIfPresent(String.self, forKey: .partnerImage)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		totalDatesSoFar = try values.decodeIfPresent(Int.self, forKey: .totalDatesSoFar)
		dateNumber = try values.decodeIfPresent(String.self, forKey: .dateNumber)
		discoverAspectRatio = try values.decodeIfPresent(String.self, forKey: .discoverAspectRatio)
		experienceTypes = try values.decodeIfPresent([String].self, forKey: .experienceTypes)
		inventoryCategories = try values.decodeIfPresent([InventoryCategories].self, forKey: .inventoryCategories)
	}
	
}

struct ExperienceTypes: Codable {
	
	let casualInteraction: String?
	let meetGreet: String?
	let phoneCall: String?
	let videoChat: String?
	let dm: String?
	let dateNight: String?
	
	private enum CodingKeys: String, CodingKey {
		case casualInteraction = "casual_interaction"
		case meetGreet = "meet_greet"
		case phoneCall = "phone_call"
		case videoChat = "video_chat"
		case dm = "dm"
		case dateNight = "date_night"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		casualInteraction = try values.decodeIfPresent(String.self, forKey: .casualInteraction)
		meetGreet = try values.decodeIfPresent(String.self, forKey: .meetGreet)
		phoneCall = try values.decodeIfPresent(String.self, forKey: .phoneCall)
		videoChat = try values.decodeIfPresent(String.self, forKey: .videoChat)
		dm = try values.decodeIfPresent(String.self, forKey: .dm)
		dateNight = try values.decodeIfPresent(String.self, forKey: .dateNight)
	}
	
}


struct InventoryCategories: Codable {
	
	let id: Int?
	let label: String?
	let myCorrectDiscoveries: Int?
	let topics: [Topics]?
	
	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case label = "label"
		case myCorrectDiscoveries = "my_correct_discoveries"
		case topics = "topics"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		label = try values.decodeIfPresent(String.self, forKey: .label)
		myCorrectDiscoveries = try values.decodeIfPresent(Int.self, forKey: .myCorrectDiscoveries)
		topics = try values.decodeIfPresent([Topics].self, forKey: .topics)
	}
	
}


struct Topics: Codable {
	let topicLabel: String?
	let topicId: Int?
	let quantity: Int?
	let myCorrectDiscoveries: Int?
	
	private enum CodingKeys: String, CodingKey {
		case topicLabel = "topic_label"
		case topicId = "topic_id"
		case quantity = "quantity"
		case myCorrectDiscoveries = "my_correct_discoveries"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		topicLabel = try values.decodeIfPresent(String.self, forKey: .topicLabel)
		topicId = try values.decodeIfPresent(Int.self, forKey: .topicId)
		quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
		myCorrectDiscoveries = try values.decodeIfPresent(Int.self, forKey: .myCorrectDiscoveries)
	}
	
}
