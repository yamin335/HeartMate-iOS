//
//  DateNightHistoryItemView.swift
//  iosbingo
//
//  Created by Md. Yamin on 11/8/22.
//

import SwiftUI

struct DateNightHistoryItemView: View {
    
    let history: DateNightHistory
    
    var body: some View {
        HStack(spacing: -40) {
            VStack(spacing: 0) {
                AsyncImage(url: URL(string: "notificationdummy")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60, alignment: .center)
                        .cornerRadius(30)
                } placeholder: {
                    Image("notificationdummy")
                        .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60, alignment: .center)
                            .cornerRadius(30)
                }
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
                        .font(.system(size: 14, weight: .regular))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 55)
                        .padding(.trailing, 15)
                    
                    Button(action: {
                        
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

struct DateNightHistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        DateNightHistoryItemView(history: DateNightHistory(date: "12-12-2021", summary: "Taking a road trip allows you to get off the beaten path and see actual communities and natural wonders"))
    }
}
