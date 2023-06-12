//
//  lifeinventory.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 22/11/22.
//

import Foundation


// MARK: - LifeInventoryCategoryResponse
class LifeInventoryCategoryResponse: Codable {
    var status: String
    var categories: [LifeInventoryCategory]

    enum CodingKeys: String, CodingKey {
        case status
        case categories = "categories"
    }

    init(status: String, categories: [LifeInventoryCategory]) {
        self.status = status
        self.categories = categories
    }
}

// MARK: - LifeInventoryCategory
class LifeInventoryCategory: Codable {
    var categoryID: Int
    var category: String
    var subTitle: String
    var moreInfo: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case category
        case subTitle = "sub_title"
        case moreInfo = "more_info"
    }

    init(categoryID: Int, category: String, subTitle: String, moreInfo: String?) {
        self.categoryID = categoryID
        self.category = category
        self.subTitle = subTitle
        self.moreInfo = moreInfo
    }
}

// MARK: - LifeInventoryQuestionResponse
class LifeInventoryQuestionResponse: Codable {
    var status: String
    var questions: [LifeInventoryQuestion]

    enum CodingKeys: String, CodingKey {
        case status
        case questions = "questions"
    }

    init(status: String, questions: [LifeInventoryQuestion]) {
        self.status = status
        self.questions = questions
    }
}

// MARK: - LifeInventoryQuestion
//class LifeInventoryQuestion: Codable {
//    var categoryID: Int
//    var topicID: Int
//    var topic: String
//    var label: String
//    var question: String
//    var fieldName: String
//    var example: String
//    var min: Int
//    var max: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case categoryID = "category_id"
//        case topicID = "topic_id"
//        case topic
//        case label
//        case question
//        case fieldName = "field_name"
//        case example
//        case min
//        case max
//    }
//
//    init(categoryID: Int, topicID: Int, topic: String, label: String, question: String, fieldName: String, example: String, min: Int, max: Int) {
//        self.categoryID = categoryID
//        self.topicID = topicID
//        self.topic = topic
//        self.label = label
//        self.question = question
//        self.fieldName = fieldName
//        self.example = example
//        self.min = min
//        self.max = max
//    }
//}


class LifeSpectrum: Codable {
    var aspect_max: Int = 1000
    var aspect_min: Int = 0
    var aspects: Aspects?
    var aspectsOfMyLife: Int = 0
    var audioURL: String = "http://team.legrandbeaumarche.com/wp-content/uploads/2022/09/stacy.mp3"
    var day: String? = "As of aug 2 2022"
    var imageURL: String = "https://team.legrandbeaumarche.com/wp-content/uploads/avatars/138/1667147426.766073-bpfull.jpg"
    var registrationLevel: Int? = 1
    var unityModuleState: Int? = 0
    
    enum CodingKeys: String, CodingKey {
        case aspect_max
        case aspect_min
        case aspects
        case aspectsOfMyLife
        case audioURL
        case day
        case imageURL
        case registrationLevel
        case unityModuleState
    }
}

class Aspects: Codable {
    var aesthetic: Int = 0
    var emotional: Int = 0
    var entertainment: Int = 0
    var intellectual: Int = 0
    var professional: Int = 0
    var sexual: Int = 0
    var spiritual: Int = 0
    var village: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case aesthetic
        case emotional
        case entertainment
        case intellectual
        case professional
        case sexual
        case spiritual
        case village
    }
}
class SpectrumResponse : Codable {
    let status: String
    let spectrum_response: String
    let category_total: Int
    let category_title: String
    let direction: String
    let category_comment: String
    var inventory_last_updated: String
    let aesthetic_side: Int
    let entertainment_side: Int
    let intellectual_side: Int
    let emotional_side: Int
    let community_side: Int
    let professional_side: Int
    let spiritual_side: Int
    let sexual_side: Int
    var running_total: Int
}


// MARK: - LifeInventoryQuestion
class LifeInventoryQuestion: Codable {
    var categoryID: Int
    var topicID: Int
    var topic: String
    var label: String
    var question: String
    var fieldName: String
    var example: String
    var min: Double
    var max: Double
    var answer: Double? = 0.0
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case topicID = "topic_id"
        case topic
        case label
        case question
        case fieldName = "field_name"
        case example
        case min
        case max
    }

    init(categoryID: Int, topicID: Int, topic: String, label: String, question: String, fieldName: String, example: String, min: Double, max: Double) {
        self.categoryID = categoryID
        self.topicID = topicID
        self.topic = topic
        self.label = label
        self.question = question
        self.fieldName = fieldName
        self.example = example
        self.min = min
        self.max = max
    }
}
