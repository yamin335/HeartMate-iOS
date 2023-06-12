//
//  MoodRingHistory.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 10/14/22.
//

import Foundation



// MARK: - MoodRingHistory
class MoodRingHistory: Codable {
    
    var status: String
    var moodRingHistoryItems: [MoodRingHistoryItem]

    enum CodingKeys: String, CodingKey {
        case status
        case moodRingHistoryItems = "entries"
    }

    init(status: String, items: [MoodRingHistoryItem]) {
        self.status = status
        self.moodRingHistoryItems = items
    }
}

// MARK: - MoodRingHistoryItem
class MoodRingSaveItem: Codable {
    let id: Int


    enum CodingKeys: String, CodingKey {
        case id = "mood_ring_id"
    }

    init(id: Int) {
        self.id = id
    }
}



// MARK: - MoodRingHistoryItem
class MoodRingHistoryItem: Codable {
    let id: Int
    let date: String
    let icon: String
    let summary: String

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case icon
        case summary
    }

    init(id: Int, date: String, icon: String, summary: String) {
        self.id = id
        self.date = date
        self.icon = icon
        self.summary = summary
    }
}


// MARK: - MoodRingHistory
class MoodRingData: Codable {
    
    var status: String
    var moodRing: MoodRing

    enum CodingKeys: String, CodingKey {
        case status
        case moodRing = "entry"
    }

    init(status: String, moodRing: MoodRing) {
        self.status = status
        self.moodRing = moodRing
    }
}



// MARK: - MoodRing
class  MoodRing: Codable {
  
    var spiritual: Int
    var emotional: Int
    var mental: Int
    var communal: Int
    var physical: Int
    var professional: Int
   
    var spiritual_explanation: String
    var professional_explanation: String
    var emotional_explanation: String
    var physical_explanation: String
    var mental_explanation: String
    var communal_explanation: String
    var first_name: String
    var summary: String
    var date_heading: String
    var date: String
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case spiritual
        case emotional
        case mental
        case communal
        case physical
        case professional
        
        case spiritual_explanation
        case professional_explanation
        case emotional_explanation
        case physical_explanation
        case mental_explanation
        case communal_explanation
        
        case first_name
        case summary
        case date_heading
        case date = "timestamp"
        
    }

    init(   spiritual: Int,
    emotional: Int,
     mental: Int,
   communal: Int,
   physical: Int,
 professional: Int,
            spiritual_explanation: String,
           professional_explanation: String,
          emotional_explanation: String,
       physical_explanation: String,
      mental_explanation: String,
      communal_explanation: String,   first_name: String,
            summary: String, date_heading: String, date: String
 ) {
        self.spiritual = spiritual
        self.emotional = emotional
        self.mental = mental
        self.communal = communal
        self.physical = physical
        self.professional = professional
        self.spiritual_explanation = spiritual_explanation
        self.professional_explanation = professional_explanation
        self.emotional_explanation = emotional_explanation
        self.physical_explanation = physical_explanation
        self.mental_explanation = mental_explanation
        self.communal_explanation = communal_explanation
        self.first_name = first_name
        self.summary = summary
        self.date_heading = date_heading
        self.date = date
        
    }
}
