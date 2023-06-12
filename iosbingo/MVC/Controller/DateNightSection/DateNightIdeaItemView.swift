//
//  DateNightIdeaItemView.swift
//  iosbingo
//
//  Created by Md. Yamin on 10/29/22.
//

import SwiftUI

struct DateNightIdeaItemView: View {
    let idea: DateElement
    @State var enabled: Bool
    @State private var selectedTag: Int? = -1
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                NavigationLink(destination: DateNightCatalogIdeaDetailsView(dateNightId: idea.dateNightId ?? 0, title: idea.title ?? "Date Night Idea", coverImage: idea.imageURL ?? ""), tag: 1, selection: self.$selectedTag) {
                    EmptyView()
                }.isDetailLink(false)
                Text(idea.title ?? "")
                    .font(.custom("Inter", size: 12))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                
                Text(idea.experience ?? "")
                    .fontWeight(.ultraLight)
                    .font(.custom("Inter", size: 9))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .padding(.top, 2)
                
                HStack(spacing: 4) {
                    Text("\(idea.totalAspects ?? 0) aspects of me")
                        .font(.custom("Inter", size: 7))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("text_color_9"))
                    
                    Button(action: {
                        selectedTag = 1
                    }) {
                        Text("Route")
                            .font(.custom("Inter", size: 9))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color("blue_color_4"))
                            .cornerRadius(5)
                    }
                    .disabled(!enabled)
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                .padding(.top, 12)
            }
            .background(Color("gray_color_5").opacity(0.85))
            .cornerRadius(15)
            .padding(.horizontal, 7)
            .padding(.bottom, 10)
        }
        .frame(width: 153, height: 197)
        .background(
            AsyncImage(url: URL(string: idea.imageURL ?? "")) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 153, height: 197)
                    .clipped()
            } placeholder: {
                Image("date_night_catalog_cover")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 153, height: 197)
                    .clipped()
            }
        )
        .cornerRadius(14)
    }
}

struct DateNightIdeaItemView_Previews: PreviewProvider {
    static var previews: some View {
        DateNightIdeaItemView(idea: DateElement(title: "Road Trip", dateNumber: "1", dateNightId: 1, topics: [""], setting: "", experience: "Learn my musical tastes", activity: "", possibilitiies: "", imageURL: "http://team.legrandbeaumarche.com/wp-content/uploads/2022/09/pexels-taryn-elliott-4840229-1-scaled.jpg", totalAspects: 100), enabled: true)
    }
}
