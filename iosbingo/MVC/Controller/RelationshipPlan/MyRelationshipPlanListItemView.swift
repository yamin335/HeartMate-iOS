//
//  MyRelationshipPlanListItemView.swift
//  iosbingo
//
//  Created by Md. Yamin on 12/16/22.
//

import SwiftUI

struct MyRelationshipPlanListItemView: View {
    @State var relationshipPlan: MyRelationshipPlanResponseData
    @State private var selectedTag: Int? = -1
    @Binding var isModalPresented: Bool
    @State var index: Int
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(destination: MyRelationshipPlanDetailsView(planId: relationshipPlan.plan_id), tag: 1, selection: self.$selectedTag) {
                EmptyView()
            }.isDetailLink(false)
            HStack(alignment: .top, spacing: 24) {
                Text("\(index)")
                    .fontWeight(.light)
                    .font(.custom("Inter", size: 32))
                VStack(spacing: 0) {
                    Text(relationshipPlan.plan_title ?? "Untitled plan")
                        .font(.custom("Inter", size: 16))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(relationshipPlan.percentage_complete ?? "0")% Completed")
                        .fontWeight(.light)
                        .font(.custom("Inter", size: 10))
                        .foregroundColor(Color("text_color_14"))
                        .padding(.top, 5)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 5) {
                        VStack(spacing: 5) {
                            Text("Assigned To:")
                                .fontWeight(.light)
                                .font(.custom("Inter", size: 13))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            
                            Text(relationshipPlan.partner_name ?? "No One Yet")
                                .fontWeight(.semibold)
                                .font(.custom("Inter", size: 13))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                        .background(.white)
                        .onTapGesture {
                            selectedTag = 1
                        }
                        
                        VStack(spacing: 5) {
                            Text("Deadline:")
                                .fontWeight(.light)
                                .font(.custom("Inter", size: 13))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            
                            Text(relationshipPlan.deadline_date_setting ?? "No Deadline Set")
                                .fontWeight(.semibold)
                                .font(.custom("Inter", size: 13))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                        .background(.white)
                        .onTapGesture {
                            isModalPresented = true
                        }
                    }
                    .padding(.top, 20)
                }
            }
            .padding([.top, .bottom], 20)
            .padding(.horizontal, 26)
            
            Divider()
                .padding(.horizontal, 20)
        }
    }
}
