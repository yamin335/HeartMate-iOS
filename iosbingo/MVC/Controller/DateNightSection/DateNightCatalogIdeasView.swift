//
//  DateNightCatalogIdeasView.swift
//  iosbingo
//
//  Created by Md. Yamin on 10/29/22.
//

import SwiftUI

struct DateNightCatalogIdeasView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var dateNightIdeas: [DateNightWeek] = []
    @State var isLoaderShown: Bool = false
    @State var title = "Date Ideas"
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(spacing: 0) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image("backarrow")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 25)
                        .foregroundColor(.black)
                        .padding()
                }
                
                Text(title)
                    .fontWeight(.ultraLight)
                    .frame(minWidth:0, maxWidth: .infinity, alignment: .leading)
                    .font(.custom("Inter", size: 22))
                
                Button(action: {
                    
                }) {
                    Image("menuSetting")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 27, height: 14)
                        .padding()
                }
            }
            .padding(.top, 35)
            
            HStack(alignment: .center, spacing: 10) {
                Text("At")
                    .font(.custom("Inter", size: 20))
                    .foregroundColor(.black)
                
                Text("LEVEL 2")
                    .bold()
                    .font(.custom("Inter", size: 20))
                    .foregroundColor(.black)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color("yellow_color_1"))
                    .cornerRadius(3)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 30)
            
            Text("Set the scene and setting \nto share your story.")
                .frame(minWidth:0, maxWidth: .infinity, alignment: .leading)
                .font(.custom("Inter", size: 20))
                .padding(.top, 25)
                .padding(.leading, 12)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(dateNightIdeas.enumerated()), id: \.offset) { index, item in
                        WeeklyDateNightIdeaItemView(idea: item, shouldShow: index == 0)
                    }
                }
            }
            .padding(.top, 56)
        }
        .background(Color("bg_color_2"))
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .appLoaderView(isPresented: $isLoaderShown, loaderView: { SwiftUISpinLoaderView() }, backgroundColor: Color("loader_bg_color"))
        .onAppear {
            loadDateNightCatalog()
        }
    }
    
    func loadDateNightCatalog() {
        isLoaderShown = true

       let userID = AppUserDefault.shared.getValueInt(for: .UserID)
        
        let queryItems = [URLQueryItem(name: "page", value: "1"), URLQueryItem(name: "can_see_promoted", value: "1"),  URLQueryItem(name: "group_id", value: "51"),URLQueryItem(name: "user_id", value: "\(userID)")]
        var urlComps = URLComponents(string: APIPath.dateNightCatalog)!
        urlComps.queryItems = queryItems
        
        API.shared.sendData(url: urlComps.url?.absoluteString ?? "", requestType: .get, params: [:], objectType: DateNightCatalogResponse.self) { (data, status)  in
            isLoaderShown = false
            guard let response = data, status, let dateCatalog = response.dateNightCatalog?.dateNightCatalog?.weeks else {
                return
            }
            
            if let numberOfDateIdeas = response.dateNightCatalog?.dateNightCatalog?.datesCount {
                self.title = "\(numberOfDateIdeas) Date Ideas"
            }
            
            dateNightIdeas = dateCatalog
        }
    }
}

struct DateNightCatalogIdeasView_Previews: PreviewProvider {
    static var previews: some View {
        DateNightCatalogIdeasView()
    }
}

