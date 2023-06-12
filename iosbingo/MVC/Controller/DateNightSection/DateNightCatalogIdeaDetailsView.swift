//
//  DateNightCatalogIdeaDetailsView.swift
//  iosbingo
//
//  Created by Md. Yamin on 10/30/22.
//

import SwiftUI

struct DateNightCatalogIdeaDetailsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isLoaderShown: Bool = false
    let dateNightId: Int
    
    @State var title: String
    @State var coverImage: String
    @State var settings: String = "Taking a road trip allows you to get off the \nbeaten path and see actual communities \nand natural wonders"
    @State var experience: String = "Road trips, concerts, and fragrances\nto discover your musical tastes"
    
    @State var possibilities: String = "Teaching the observant dating partner\nhow to curate a playlist to make love to,\ncomfort you and more..."
    @State var completed: String = "0"
    
    @State private var selectedTag: Int? = -1
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                NavigationLink(destination: DateNightHistoryView(), tag: 1, selection: self.$selectedTag) {
                    EmptyView()
                }.isDetailLink(false)
                AsyncImage(url: URL(string: coverImage)) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(height: 290)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .cornerRadius(35)
                        .clipped()
                } placeholder: {
                    Image("date_night_catalog_cover")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 290)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .cornerRadius(35)
                        .clipped()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Button(action: {
                            selectedTag = 1
                        }) {
                            Text("History")
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(Color("text_color_10"))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 2)
                                .background(Color("bg_color_2"))
                                .padding(.leading, 25)
                        }
                        
                        Spacer()
                        
                        Text("Completed")
                            .fontWeight(.light)
                            .font(.custom("Inter", size: 15))
                            .foregroundColor(Color("gray_color_6"))
                            .padding(.trailing, 16)
                        
                        Text(completed)
                            .font(.custom("Inter", size: 18).bold())
                            .foregroundColor(.white)
                            .padding(.trailing, 25)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("The Setting")
                                .fontWeight(.medium)
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                Text(settings)
                                    .font(.custom("Inter", size: 13))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 12)
                                    
                            }
                            .padding(.trailing, 16)
                            .padding(.leading, 20)
                            .padding(.top, 10)
                            .padding(.bottom, 16)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .background(.white)
                        .cornerRadius(15)
                        .padding(.horizontal, 12)
                        .padding(.top, 6)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("The Experience")
                                .fontWeight(.medium)
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(Color("text_color_10"))
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                Text(experience)
                                    .font(.custom("Inter", size: 13))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 12)
                                    
                            }
                            .padding(.trailing, 16)
                            .padding(.leading, 20)
                            .padding(.top, 10)
                            .padding(.bottom, 16)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .background(.white)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1))
                        .padding(.horizontal, 12)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("The Possibilities")
                                .fontWeight(.medium)
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(Color("yellow_color_1"))
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                Text(possibilities)
                                    .font(.custom("Inter", size: 13))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 12)
                                    
                            }
                            .padding(.trailing, 16)
                            .padding(.leading, 20)
                            .padding(.top, 10)
                            .padding(.bottom, 16)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .background(.white)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1))
                        .padding(.horizontal, 12)
                    }
                }
                .padding(.top, -80)
                .padding(.bottom)
                
                Spacer()
            }
            .background(Color("bg_color_2"))
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("backarrow")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 18, height: 25)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Text(title)
                        .fontWeight(.medium)
                        .frame(minWidth:0, maxWidth: .infinity, alignment: .leading)
                        .font(.custom("Inter", size: 32))
                        .foregroundColor(.white)
                }
                .padding(.top, 35)
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
        }
        .navigationBarHidden(true)
        .appLoaderView(isPresented: $isLoaderShown, loaderView: { SwiftUISpinLoaderView() }, backgroundColor: Color("loader_bg_color"))
        .onAppear {
            loadDateNightCatalogDetails(dateNightId: dateNightId)
        }
    }
    
    func loadDateNightCatalogDetails(dateNightId: Int) {
        isLoaderShown = true
        
        let queryItems = [URLQueryItem(name: "date_night_id", value: String(dateNightId)), URLQueryItem(name: "is_partner", value: "1")]
        var urlComps = URLComponents(string: APIPath.dateNightCatalogDetails)!
        urlComps.queryItems = queryItems
        
        API.shared.sendData(url: urlComps.url?.absoluteString ?? "", requestType: .get, params: [:], objectType: DateNightCatalogDetailsResponse.self) { (data, status)  in
            isLoaderShown = false
            guard let response = data, status else {
                return
            }
            
            if let completed = response.completed {
                self.completed = String(completed)
            }
            
            if let settings = response.setting, !settings.isEmpty {
                self.settings = settings
            }
            
            if let experience = response.experience, !experience.isEmpty {
                var exp = ""
                for item in experience {
                    exp = exp.isEmpty ? item : "\(exp) \(item)"
                }
            }
            
            if let possibilitiies = response.possibilitiies, !possibilitiies.isEmpty {
                var psb = ""
                for item in possibilitiies {
                    psb = psb.isEmpty ? item : "\(psb) \(item)"
                }
            }
        }
    }
}

struct DateNightCatalogIdeaDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DateNightCatalogIdeaDetailsView(dateNightId: 0, title: "Date Night Idea", coverImage: "http://team.legrandbeaumarche.com/wp-content/uploads/2022/09/pexels-taryn-elliott-4840229-1-scaled.jpg")
    }
}
