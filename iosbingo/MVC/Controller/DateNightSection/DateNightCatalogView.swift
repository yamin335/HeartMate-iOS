//
//  DateNightCatalogView.swift
//  iosbingo
//
//  Created by Md. Yamin on 10/28/22.
//

import SwiftUI

struct DateNightCatalogView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedTag: Int? = -1
    @State private var primerVIselectedTag: Int? = -1
    
    var body: some View {
        ZStack {
            Image("date_night_catalog_cover")
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                NavigationLink(destination: DateNightCatalogIdeasView(), tag: 1, selection: self.$selectedTag) {
                    EmptyView()
                }.isDetailLink(false)
                
                HStack {
                    NavigationLink(destination: PrimerVI(), tag: 1, selection: self.$primerVIselectedTag) {
                        Button(action: {
                            if AppUserDefault.shared.getValueBool(for: .isUserRegistering) {
                                primerVIselectedTag = 1
                            } else {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            
                        }) {
                            Image("backarrow")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 18, height: 25)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    Spacer()
                }
                .padding(.top, 15)
                
                Spacer()
                
                Text("My Date Night\nCatalog")
                    .font(.custom("Acme", size: 32))
                    .foregroundColor(.white)
                    .padding(.leading, 40)
                
                Button(action: {
                    selectedTag = 1
                }) {
                    Text("Guide Me")
                        .font(.custom("Inter", size: 20))
                        .foregroundColor(.black)
                        .padding(.horizontal, 37)
                        .padding(.vertical, 12)
                        .background(Color("gray_color_1"))
                        .cornerRadius(9)
                        .padding(.leading, 40)
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
        .navigationBarHidden(true)
    }
}

struct DateNightCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        DateNightCatalogView()
    }
}
