//
//  MoodRingHistory.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 10/14/22.
//

import SwiftUI

struct MoodRingHistoryView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var history: [MoodRingHistoryItem] = []
    @State var showDatePicker: Bool = false
    @State var savedDate: Date = .now
    @State private var isHistoryFound: Bool? = nil
    @State var isLoaderShown: Bool = false

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Image("historytop")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .overlay(Text("Mood Ring Timeline")
                        .foregroundColor(Color("gray_color_4"))
                        .font(.system(size: 20, weight: .medium)))
                   
                
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
                        //.padding(.bottom, 8)
                    }
                    Spacer()
                    
                    
                }.padding(.top,25)
                   
                
               // Spacer()
            }.edgesIgnoringSafeArea(.top)
               
                .frame(maxHeight: 187)
            
            
//            Text("Mood Ring Timeline")
//                            .foregroundColor(Color("gray_color_4"))
//                            .font(.system(size: 20, weight: .medium)).padding()
            
            //if showDatePicker {
              
               // .datePickerStyle(.graphical)
            //}
            
            HStack(alignment: .top)  {
                Text("Recent Posts")
                    .foregroundColor(Color("gray_color_4"))
                    .font(.system(size: 14, weight: .medium))
                    .padding(.leading,10)
                    .padding(.top,2)
                Spacer()
                
                Text("< Week ending")
                    .foregroundColor(Color("gray_color_4"))
                    .font(.system(size: 14, weight: .medium))
                    .padding(.trailing,-5)
                    .padding(.top,2)
                DatePicker(
                    "",
                    selection: $savedDate,
                    displayedComponents: [.date]
                ).labelsHidden()
                    .padding(.trailing,10)
                    .colorScheme(.dark)
                    .labelsHidden()
                                        .transformEffect(.init(scaleX: 0.7, y: 0.7))
                                        .foregroundColor(Color("gray_color_4"))
                                        .font(.system(size: 14, weight: .medium))
                    .onChange(of: savedDate, perform: { value in
                        
                        let formatter3 = DateFormatter()
                        formatter3.dateFormat = "YYYY-MM-dd"
                        print(formatter3.string(from: value))
                        self.loadModeRingHistory(date: formatter3.string(from: value))
                         // Do what you want with "date", like array.timeStamp = date
                    });
//                Button(action: {
//                    self.showDatePicker = true
//                }) {
//                    Text("< Week ending June 15")
//                        .foregroundColor(Color("gray_color_4"))
//                        .font(.system(size: 12, weight: .light))
//                }
//
                    
            }//.frame(maxHeight: 50)
                
            .padding(.top, -25)
            
            Spacer()
            
            if let isHistoryFound = isHistoryFound, isHistoryFound {
                ScrollView {
                    ForEach(Array(history.enumerated()), id: \.offset) { index, item in
                        MoodRingHistoryItemview(history: item)
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
        //.edgesIgnoringSafeArea(.top)
        //.fullBackground(color: Color("blue_color_3"))
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("moodringbgstart"), Color("moodringbgend")]), startPoint: .leading, endPoint: .trailing)
            )
        .enableLightStatusBar()
        .onAppear() {
            loadModeRingHistory(date: nil)
        }
        .appLoaderView(isPresented: $isLoaderShown, loaderView: { SwiftUISpinLoaderView() }, backgroundColor: Color("loader_bg_color"))
        .navigationBarHidden(true)

    }
    
    func loadModeRingHistory(date: String?) {
        //AppLoader.shared.show(currentView: self.view)
        isLoaderShown = true

        var params : [String:Any]?
        if let date = date {
            params?["for_week_ending"] = date
        }
        
        API.shared.sendData(url: APIPath.getMoodRingHistory, requestType: .post, params: params, objectType: MoodRingHistory.self) { (data,status)  in
            isLoaderShown = false
            if status == false {
                isHistoryFound = false
                return
            }
            guard let moodRingHistory = data else {return}
            isHistoryFound = true
            self.history = moodRingHistory.moodRingHistoryItems
        }
    }
}


