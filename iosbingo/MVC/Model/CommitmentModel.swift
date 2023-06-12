//
//  CommitmentModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 09/10/2022.
//

import Foundation

// MARK: - CommitmentModel
class CommitmentModel: Codable {
    var status: String
    var offerPostID: Int
    var comfortableLabel, balanceLabel, safeLabel, inviterName: String
    var inviterAvatar: String
    var descriptionText, headerText, footerText: String
    var submissionOptions: [String]
    var groupID, authorID: Int
    var initiatorStatus, comfortableResponse, balanceResponse, safeResponse: String
    var acknowledgementStatus: String
    var acceptanceStatus: Int
    var rejectionMessage: String
    var sender: Int
    var level2_Invitation: Level2_Invitation?

    enum CodingKeys: String, CodingKey {
        case status
        case offerPostID = "offer_post_id"
        case comfortableLabel = "comfortable_label"
        case balanceLabel = "balance_label"
        case safeLabel = "safe_label"
        case inviterName = "inviter_name"
        case inviterAvatar = "inviter_avatar"
        case descriptionText = "description_text"
        case headerText = "header_text"
        case footerText = "footer_text"
        case submissionOptions = "submission_options"
        case groupID = "group_id"
        case authorID = "author_id"
        case initiatorStatus = "initiator_status"
        case comfortableResponse = "comfortable_response"
        case balanceResponse = "balance_response"
        case safeResponse = "safe_response"
        case acknowledgementStatus = "acknowledgement_status"
        case acceptanceStatus = "acceptance_status"
        case rejectionMessage = "rejection_message"
        case sender
        case level2_Invitation = "level_2_invitation"
    }

    init(status: String, offerPostID: Int, comfortableLabel: String, balanceLabel: String, safeLabel: String, inviterName: String, inviterAvatar: String, descriptionText: String, headerText: String, footerText: String, submissionOptions: [String], groupID: Int, authorID: Int, initiatorStatus: String, comfortableResponse: String, balanceResponse: String, safeResponse: String, acknowledgementStatus: String, acceptanceStatus: Int, rejectionMessage: String, sender: Int, level2_Invitation: Level2_Invitation) {
        self.status = status
        self.offerPostID = offerPostID
        self.comfortableLabel = comfortableLabel
        self.balanceLabel = balanceLabel
        self.safeLabel = safeLabel
        self.inviterName = inviterName
        self.inviterAvatar = inviterAvatar
        self.descriptionText = descriptionText
        self.headerText = headerText
        self.footerText = footerText
        self.submissionOptions = submissionOptions
        self.groupID = groupID
        self.authorID = authorID
        self.initiatorStatus = initiatorStatus
        self.comfortableResponse = comfortableResponse
        self.balanceResponse = balanceResponse
        self.safeResponse = safeResponse
        self.acknowledgementStatus = acknowledgementStatus
        self.acceptanceStatus = acceptanceStatus
        self.rejectionMessage = rejectionMessage
        self.sender = sender
        self.level2_Invitation = level2_Invitation
    }
}

// MARK: - Level2_Invitation
class Level2_Invitation: Codable {
    var level2_InvitationDescription, header, comfortableText, balanceText: String
    var safeText: String

    enum CodingKeys: String, CodingKey {
        case level2_InvitationDescription = "description"
        case header
        case comfortableText = "comfortable_text"
        case balanceText = "balance_text"
        case safeText = "safe_text"
    }

    init(level2_InvitationDescription: String, header: String, comfortableText: String, balanceText: String, safeText: String) {
        self.level2_InvitationDescription = level2_InvitationDescription
        self.header = header
        self.comfortableText = comfortableText
        self.balanceText = balanceText
        self.safeText = safeText
    }
}
