//
//  APIPath.swift
//  Sports Friends Hookup
//
//  Created by Saqlain Syed on 19/04/2019.
//  Copyright © 2019 Saqlain Syed. All rights reserved.
//
import Foundation

class APIPath {
	static let login = "userplus/generate_auth_cookie/"
	static let register = "userplus/register/"
	static let usernameExists = "userplus/onboarding/"
		//static let xprofileUpdate = "userplus/xprofile_update/"
	static let nonce = "get_nonce/"
	static let profile = "userplus/get_profile/"
	static let deleteAccount = "userplus/delete_account/"
	static let forgotPassword = "userplus/retrieve_password/"
	static let uploadProfile = "userplus/avatar_upload/"
	static let logOff = "userplus/logoff/"
	static let updateUserMetaVar = "userplus/update_user_meta_vars"
	static let getNotificationsAndEmails = "userplus/get_user_meta"
	static let validateCookie = "userplus/validate_jwt"
	static let updateProfile = "userplus/update_user"
	static let getDateNight = "userplus/get_date_ideas"
	static let getInventoryReportModel = "userplus/to_value_me_report"
	static let invitation1 = "invitations/generate_dating_invitation"
	static let datingJourneys = "userplus/dating_journeys/"
	static let getPlan = "userplus/get_master_planner"
	static let getCorporateInfo = "get_corporate_info/"
	static let exitReason = "userplus/get_exit_dating_reasons"
	static let exitDating = "userplus/exit_dating_journey"
	static let emailExists = "userplus/email_exists"
	static let datingPartnershipAccepted = "invitations/dating_partnership_accepted"
	static let datingPartnershipRejected = "invitations/dating_partnership_rejected"
	static let getPartnerDateNightCatalog = "userplus/get_partner_date_night_catalog"
	static let scheduleMeTime = "userplus/schedule_me_time"
	static let notification = "userplus/notifications"
	static let unreadCount = "userplus/notifications_unread_count"
	static let createLevel2Invitation = "userplus/create_level_2_invitation"
	static let commitment = "userplus/get_commitment_offer"
	static let acceptOffer = "userplus/accept_commitment_offer"
	static let rejectOffer = "userplus/decline_commitment_offer"
	static let doubleAcceptOffer = "userplus/commitment_double_confirmation"
	static let getDatingJournal = "userplus/get_date_journey_home"
	static let saveDailyMoodRing = "userplus/save_daily_mood_ring"
	static let getMoodRing = "userplus/get_mood_ring"
	static let getMoodRingHistory = "userplus/get_mood_ring_history"
	static let getWhatWorks = "get_what_works_home"
	static let getWhatWorksDetail = "get_what_works_detail"
	static let voteForWhatWorks = "guide_vote"
	static let dateNightCatalog = "userplus/get_date_night_catalog/"
	static let dateNightCatalogDetails = "userplus/get_date_night"
	static let getDateNightOffer = "userplus/get_date_night_offer"
	static let submitDateNightOfferDecision = "userplus/submit_date_night_offer_decision"
	static let upcomingEvent = "userplus/get_date_event_details"
	static let getOfferReschedule = "userplus/get_reschedule_offer_details"
	static let acceptRescheduleEvent = "userplus/accept_reschedule_date_night_event"
	static let acceptEvent = "userplus/offer_reschedule_date_night_event"
	static let getCancelReason = "userplus/get_cancel_reasons"
	static let cancelEventDateNight = "userplus/cancel_date_night_event"
	static let cacelMeTime = "userplus/cancel_me_time"
	static let offerDateNight = "userplus/offer_date_night"
	static let getLevel1History = "userplus/get_invitation_history"
	static let deleteLevel1History = "userplus/delete_invitation"
    static let getLifeInventory = "userplus/get_life_inventory"
    static let getLifeQuestions = "userplus/get_life_inventory_questions_by_side"
    static let updateInventoryValues = "userplus/update_life_inventory_by_category/"
    
    static let updateSubscriptionStatus = "userplus/update_subscription_status"
    static let sandBoxAPI = "https://sandbox.itunes.apple.com/verifyReceipt"
    static let productionAPI = "https://buy.itunes.apple.com/verifyReceipt"
    
    static let myRelationshipPlans = "relationshipgoals/get_my_relationship_plans"
    static let myRelationshipPlanDetails = "relationshipgoals/get_my_relationship_plan_details"
    static let relationshipPlans = "relationshipgoals/get_relationship_goal_plans"
    static let updateMyRelationshipPlanProgress = "relationshipgoals/update_my_relationship_plan_progress"
	
	static let getJournalHome = "datingjournal/get_journal_home/"
	static let getGroupDatingJournal = "datingjournal/get_group_dating_journal"
	static let getourStory = "datingjournal/get_our_story"
	static let getTopEntery = "datingjournal/get_topic_entries"
	static let createEntry = "datingjournal/create_entry"
	static let getJournalEntry = "datingjournal/get_entry"
	static let deleteEntry = "datingjournal/delete_journal_entry"

    static let visionBoard = "visionboard/get_vision_board"
    static let submitMindset = "visionboard/submit_mindset"
    static let submitDatingStyle = "visionboard/submit_dating_style"
    static let submitSeasonBliss = "visionboard/submit_bliss"
    static let submitAdultingSeason = "visionboard/submit_adulting_season"
    static let getPartnerVision = "visionboard/get_partner_vision_board"
    static let getIceBreakers = "visionboard/get_icebreakers"
}

