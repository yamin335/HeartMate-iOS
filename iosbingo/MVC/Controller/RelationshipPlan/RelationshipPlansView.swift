//
//  RelationshipPlansView.swift
//  iosbingo
//
//  Created by Md. Yamin on 12/16/22.
//

import SwiftUI

struct RelationshipPlansView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var showEmptyView: Bool = true
    @State var relationshipPlans: [RelationshipPlan] = []
    @State var isLoaderShown: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                }) {
                    Image("backarrow")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 25)
                        .foregroundColor(.black)
                        .padding([.leading])
                }
                Spacer()
            }
            
            ZStack(alignment: .leading) {
                HStack {
                    Image("heart_balloon")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .clipped()
                        .padding()
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Text("Relationship Goals")
                            .font(.custom("Acme", size: 24))
                            .foregroundColor(.black)
                            .padding(.top, 90)
                            .padding(.leading, 30)
                        Spacer()
                    }
                }
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            Text("Relationship Goals are for single -use. \nOnce you assign to a match, dating partner\nor committed couple you cannot reverse the\nassignment.")
                .fontWeight(.medium)
                .font(.custom("Inter", size: 11))
                .foregroundColor(Color("text_color_12"))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 45)
                .padding(.bottom, 60)
            
            if showEmptyView {
                Text("No Relationship Goals found")
                    .font(.custom("Acme", size: 22))
                    .foregroundColor(Color("text_color_13"))
                    .opacity(0.75)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.top, 100)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        Divider()
                            .padding(.horizontal, 20)
                        
                        ForEach(Array(relationshipPlans.enumerated()), id: \.offset) { index, item in
                            RelationshipPlanListItemView(relationshipPlan: item, index: index + 1)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .appLoaderView(isPresented: $isLoaderShown, loaderView: { SwiftUISpinLoaderView() }, backgroundColor: Color("loader_bg_color"))
        .onAppear {
            getRelationshipPlans()
        }
    }
    
    func getRelationshipPlans() {
        isLoaderShown = true

        let params : [String : Any]? = [:]
        
        API.shared.sendData(url: APIPath.relationshipPlans, requestType: .get, params: params, objectType: RelationshipPlanResponse.self, isTokenRequired: true) { (data, status)  in
            isLoaderShown = false
            if status == false {
                showEmptyView = true
                return
            }
            guard let plans = data?.data, !plans.isEmpty else {
                showEmptyView = true
                return
            }
            showEmptyView = false
            self.relationshipPlans = plans
        }
    }
}

struct RelationshipPlansView_Previews: PreviewProvider {
    static var previews: some View {
        RelationshipPlansView()
    }
}
