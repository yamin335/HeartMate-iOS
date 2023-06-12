//
//  WeeklyDateNightIdeaView.swift
//  iosbingo
//
//  Created by Md. Yamin on 10/29/22.
//

import SwiftUI

struct WeeklyDateNightIdeaItemView: View {
    let idea: DateNightWeek
    let gridItemLayout = [GridItem(.fixed(197))]
    @State var shouldShow: Bool
    
    var hintView: some View {
        HStack(alignment: .bottom, spacing: 20) {
            Text("Progress is made by paying attention to one another.")
                .font(.custom("Inter", size: 22).bold())
            
            Button(action: {
                
            }) {
                Image("circleArrow")
                    .resizable()
                    .frame(width: 32, height: 32, alignment: .bottom)
            }

        }
        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .padding(.horizontal, 30)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text(idea.weekNumber ?? "Unknown Week")
                .fontWeight(.semibold)
                .frame(minWidth:0, maxWidth: .infinity, alignment: .leading)
                .font(.custom("Inter", size: 22))
                .padding(.leading, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItemLayout, spacing: 15) {
                    ForEach(Array(idea.dates.enumerated()), id: \.offset) { index, item in
                        DateNightIdeaItemView(idea: item, enabled: shouldShow)
                    }
                }
                .padding(.horizontal, 12)
            }
            .overlay(shouldShow ? nil : Color.white.opacity(0.7).frame(height: 210))
            .blur(radius: shouldShow ? 0 : 10)
            .overlay(shouldShow ? nil : hintView)
            .padding(.bottom, 30)
        }
    }
}

struct WeeklyDateNightIdeaItemView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyDateNightIdeaItemView(idea: DateNightWeek(weekNumber: "Week 1", dates: [
            DateElement(title: "Road Trip", dateNumber: "1", dateNightId: 1,
                        topics: [""], setting: "", experience: "Learn my musical tastes",
                        activity: "", possibilitiies: "", imageURL: "http://team.legrandbeaumarche.com/wp-content/uploads/2022/09/pexels-taryn-elliott-4840229-1-scaled.jpg",
                        totalAspects: 100),
            DateElement(title: "Ancestral Home", dateNumber: "2", dateNightId: 2,
                        topics: [""], setting: "", experience: "Learn my family values",
                        activity: "", possibilitiies: "", imageURL: "http://team.legrandbeaumarche.com/wp-content/uploads/2022/09/pexels-taryn-elliott-4840229-1-scaled.jpg",
                        totalAspects: 44),
            DateElement(title: "Road Trip", dateNumber: "3", dateNightId: 3,
                        topics: [""], setting: "", experience: "Learn my musical tastes",
                        activity: "", possibilitiies: "", imageURL: "http://team.legrandbeaumarche.com/wp-content/uploads/2022/09/pexels-taryn-elliott-4840229-1-scaled.jpg",
                        totalAspects: 22),
            DateElement(title: "Ancestral Home", dateNumber: "4", dateNightId: 4,
                        topics: [""], setting: "", experience: "Learn my family values",
                        activity: "", possibilitiies: "", imageURL: "http://team.legrandbeaumarche.com/wp-content/uploads/2022/09/pexels-taryn-elliott-4840229-1-scaled.jpg",
                        totalAspects: 16)
        ]), shouldShow: false)
    }
}
