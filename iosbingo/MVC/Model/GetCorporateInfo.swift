//
//  GetCorporateInfo.swift
//  iosbingo
//
//  Created by Gursewak singh on 28/09/22.
//

import Foundation

// MARK: - GetCorporateInfo
struct GetCorporateInfo: Codable {
    let status: String
    let helpCenter, privacyPolicy, termsOfService, licenses: String
    let safeDatingTips, memberPrinciples, cookies, numberChanges: String
    let nonExclusiveDatingPartners: String
    let onboardingVideo: String

    enum CodingKeys: String, CodingKey {
        case status
        case helpCenter = "help_center"
        case privacyPolicy = "privacy_policy"
        case termsOfService = "terms_of_service"
        case licenses
        case safeDatingTips = "safe_dating_tips"
        case memberPrinciples = "member_principles"
        case cookies
        case numberChanges = "number_changes"
        case nonExclusiveDatingPartners = "non_exclusive_dating_partners"
        case onboardingVideo = "onboarding_video"
    }
}
