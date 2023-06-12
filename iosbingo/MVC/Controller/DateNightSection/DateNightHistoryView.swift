//
//  DateNightHistoryView.swift
//  iosbingo
//
//  Created by Md. Yamin on 11/9/22.
//

import SwiftUI

struct DateNightHistoryView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var isLoaderShown: Bool = false
    @State var history: [DateNightHistory] = []
    @State var showDatePicker: Bool = false
    @State var savedDate: Date = .now
    @State private var isHistoryFound: Bool? = nil
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Image("date_night_catalog_cover")
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 220)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .clipped()
                   
                HStack(alignment: .top) {
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Image("backarrow")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 18, height: 25)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }.padding(.top,35)
            }
            .edgesIgnoringSafeArea(.top)
            .frame(maxHeight: 200)
            
            HStack(alignment: .top)  {
                Text("Recent Dates")
                    .foregroundColor(.black)
                    .font(.system(size: 14, weight: .medium))
                    .padding(.leading,10)
                    .padding(.top,2)
                Spacer()
            }
            .padding(.top, -25)
            
            Spacer()
            
            if let isHistoryFound = isHistoryFound, isHistoryFound {
                ScrollView {
                    ForEach(Array(history.enumerated()), id: \.offset) { index, item in
                        DateNightHistoryItemView(history: item)
                    }
                }.padding(.top,1)
            }
            
            if isHistoryFound == false {
                HStack (alignment: .center) {
                    Text("No History Yet")
                        .foregroundColor(Color("gray_color_4"))
                        .font(.system(size: 20, weight: .medium)).padding()
                }
                Spacer()
            }

        }
        .frame(minHeight: 0, maxHeight: .infinity)
        .background(
            Color("bg_color_2")
        )
        .enableLightStatusBar()
        .onAppear() {
            history = [
                DateNightHistory(date: "12-12-2021", summary: "Taking a road trip allows you to get off the beaten path and see actual communities and natural wonders"),
                DateNightHistory(date: "12-12-2021", summary: "Taking a road trip allows you to get off the beaten path and see actual communities and natural wonders"),
                DateNightHistory(date: "12-12-2021", summary: "Taking a road trip allows you to get off the beaten path and see actual communities and natural wonders"),
                DateNightHistory(date: "12-12-2021", summary: "Taking a road trip allows you to get off the beaten path and see actual communities and natural wonders")
            ]
            isHistoryFound = true
        }
        .appLoaderView(isPresented: $isLoaderShown, loaderView: { SwiftUISpinLoaderView() }, backgroundColor: Color("loader_bg_color"))
        .navigationBarHidden(true)
    }
}

struct DateNightHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        DateNightHistoryView()
    }
}
