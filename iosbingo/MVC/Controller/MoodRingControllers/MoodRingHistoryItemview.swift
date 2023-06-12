//
//  MoodRingHistoryItemview.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 10/14/22.
//

import SwiftUI

struct MoodRingHistoryItemview: View {
    @State var history: MoodRingHistoryItem
    @State var selection: Int? = nil
    
    var body: some View {
        HStack(spacing: -40) {
            VStack(spacing: 0) {
                
                AsyncImage(url: URL(string: history.icon)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60, alignment: .center)
                        .cornerRadius(25)
                } placeholder: {
                    Color("moodringhisthumb")
                }
                
               // AsyncImage(url: URL(string: history.icon))
                   // .resizable()
                    
                    .frame(width: 60, height: 60, alignment: .center)
                    .cornerRadius(25)
            }
            .frame(width: 80, height: 80, alignment: .center)
            .background(Color("moodringhisthumb"))
            .cornerRadius(40)
            .zIndex(1)
            
            VStack(spacing: 5) {
                Text(history.date)
                    .font(.system(size: 14, weight: .light))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 55)
                    .padding(.trailing, 15)
                HStack(alignment: .center, spacing: 8) {
                    
                    Text(history.summary)
                        .font(.system(size: 14, weight: .bold))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 55)
                        .padding(.trailing, 15)
                    NavigationLink(destination: MyMoodRingView(existingMoodRingID:history.id), tag: 1, selection: $selection) {
                    Button(action: {
                        self.selection = 1
                    }) {
                        Text("View")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color("blue_color_2"))
                            .cornerRadius(10)
                    }
                }
                }
                .padding(.trailing, 10)
            }
            
            .frame(height: 66)
            .background(Color("gray_color_4"))
            .cornerRadius(15)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.horizontal, 15)
    }
}

//struct MoodRingHistoryItemview_Previews: PreviewProvider {
//    static var previews: some View {
//        MoodRingHistoryItemview(history: MoodRingHistory(date: "June 15, 2022", moodDescription: "Not So Great Mood"))
//    }
//}
