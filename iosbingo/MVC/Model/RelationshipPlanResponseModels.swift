//
//  RelationshipPlanResponseModels.swift
//  iosbingo
//
//  Created by Md. Yamin on 12/16/22.
//

import Foundation

struct MyRelationshipPlanResponse: Codable {
    let data: [MyRelationshipPlanResponseData]?
    let status: String?
}

struct MyRelationshipPlanResponseData: Codable {
    let deadline_date_setting: String?
    let id: Int?
    let name: String?
    let partner_name: String?
    let percentage_complete: String?
    let plan_id: Int?
    let plan_title: String?
    let reminder_status: String?
}


struct MyRelationshipPlanDetailsResponse: Codable {
    var checklist: [MyRelationshipPlanChecklistItem]?
    let plan_details: MyRelationshipPlanDetails?
    let status: String?
}

struct MyRelationshipPlanChecklistItem: Codable {
    let interval: String?
    let interval_id: Int?
    var tasks: [MyRelationshipPlanTask]
    
    enum CodingKeys: String, CodingKey {
        case interval
        case interval_id
        case tasks = "task"
    }
}

struct MyRelationshipPlanDetails: Codable {
    let completed_task_percentage: Int?
    let deadline: String?
    let partner_assignment: String?
    let title: String?
}

struct MyRelationshipPlanTask: Codable {
    let status: String?
    let task: String?
    let task_id: Int?
    var isChecked: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case status, task, task_id
    }
}


struct RelationshipPlanResponse: Codable {
    let data: [RelationshipPlan]?
    let status: String?
}

struct RelationshipPlan: Codable {
    let id: Int?
    let plan_title: String?
    let plan_description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case plan_title = "plan title"
        case plan_description
    }
}
