//
//  DatingJourney.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 5/9/22.
//

import Foundation

// MARK: - Journey
class Journey {
    var id: Int?
    var dating_partner_id: Int?
    var dating_journey_id: Int?
    var groupId: Int?
    var avatar: String?
    var first_name: String?
    var last_name: String?
    var value_me_score: Int?
    var ourStatus: OurStatus?
    var discovery: Discovery?
    var level2_Commiement: Level2_Commitment?
 

//    enum CodingKeys: String, CodingKey {
//        case dating_partner_id
//        case dating_journey_id
//        case avatar
//        case first_name
//        case last_name
//        case value_me_score
//        case ourStatus = "our_status"
//        case discovery = "discoveries"
//    }
    init() {
        
    }

//    init(dating_partner_id: Int?, dating_journey_id: Int?, avatar: String?, first_name: String?, last_name: String?, value_me_score: Int?, ourStatus:OurStatus?, discovery: Discovery?) {
//        self.dating_partner_id = dating_partner_id
//        self.dating_journey_id = dating_journey_id
//        self.avatar = avatar
//        self.first_name = first_name
//        self.last_name = last_name
//        self.value_me_score = value_me_score
//        self.ourStatus = ourStatus
//        self.discovery = discovery
//    }
}

class Discovery: Codable {
  
    var user: UserData?
    var partner: Partner?
    
    enum CodingKeys: String, CodingKey {
        case user = "journeys"
        case partner = "partner"
    }

    init( user: UserData?, partner: Partner?) {
        self.user = user
        self.partner = partner
    }
    
    init() {
        self.user = nil
        self.partner = nil
    }
}





// MARK: - UserData
class Partner: Codable {
    var level: String?
    var value: Int?

    init() {
        self.level = nil
        self.value = nil
    }
}

// MARK: - UserData
class UserData: Codable {
    var level: String?
    var value: Int?

    init() {
        self.level = nil
        self.value = nil
    }
}

// MARK: - OurStatus
class OurStatus: Codable {
    var level: String?
    var title: String?

    init() {
        self.level = nil
        self.title = nil
    }
    init(level: String,title: String?) {
        self.level = level
        self.title = title
    }
}


// MARK: - Level2_Invitation
class Level2_Commitment: Codable {
    var level2_InvitationDescription, header, comfortableText, balanceText: String?
    var safeText: String?

    init() {
        self.level2_InvitationDescription = nil
        self.header = nil
        self.comfortableText = nil
        self.balanceText = nil
        self.safeText = nil
    }

    init(level2_InvitationDescription: String, header: String, comfortableText: String, balanceText: String, safeText: String) {
        self.level2_InvitationDescription = level2_InvitationDescription
        self.header = header
        self.comfortableText = comfortableText
        self.balanceText = balanceText
        self.safeText = safeText
    }
}

// MARK: - DatingJourneyTutorial

struct DatingJourneyTutorial: Codable {
    var title, subTitle, header: String
    var bullets: [String]
    
    init() {
        self.title = "Are you ready?"
        self.subTitle = "Self-check before you start your\nTo Value Me journey:"
        self.header = "Regarding your last few conversations"
        self.bullets = [
            "Did I Feel Comfortable?",
            "They were not hijacking the conversation from me?",
            "They were adding value to the conversation(s) and not just waiting for their turn to speak when I shared?"
        ]
    }
    
    init(title: String, subTitle: String, header: String, bullets: [String]) {
        self.title = title
        self.subTitle = subTitle
        self.header = header
        self.bullets = bullets
    }
}
