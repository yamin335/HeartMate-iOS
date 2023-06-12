//
//  RelationshipPlanListItemView.swift
//  iosbingo
//
//  Created by Md. Yamin on 12/17/22.
//

import SwiftUI

struct RelationshipPlanListItemView: View {
    @State var relationshipPlan: RelationshipPlan
    @State private var selectedTag: Int? = -1
    @State var index: Int
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(destination: MyRelationshipPlanDetailsView(planId: relationshipPlan.id), tag: 1, selection: self.$selectedTag) {
                EmptyView()
            }.isDetailLink(false)
            HStack(alignment: .top, spacing: 24) {
                Text("\(index)")
                    .fontWeight(.light)
                    .font(.custom("Inter", size: 32))
                VStack(spacing: 0) {
                    Text(relationshipPlan.plan_title ?? "Untitled Plan")
                        .font(.custom("Inter", size: 16))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    Text(relationshipPlan.plan_description ?? "No description found")
                        .fontWeight(.light)
                        .font(.custom("Inter", size: 10))
                        .foregroundColor(Color("text_color_14"))
                        .padding(.top, 5)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    Text("$0")
                        .fontWeight(.light)
                        .font(.custom("Inter", size: 13))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 26)
            .onTapGesture {
                //selectedTag = 1
            }
            
            Divider()
                .padding(.horizontal, 20)
                .padding(.top, 20)
        }
    }
}
