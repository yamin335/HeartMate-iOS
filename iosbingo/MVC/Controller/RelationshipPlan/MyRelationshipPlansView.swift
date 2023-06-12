//
//  MyRelationshipPlansView.swift
//  iosbingo
//
//  Created by Md. Yamin on 12/16/22.
//

import SwiftUI

struct MyRelationshipPlansView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var showEmptyView: Bool = true
    @State var relationshipPlans: [MyRelationshipPlanResponseData] = []
    @State var isLoaderShown: Bool = false
    @State var profileData : ProfileModel?
    @State var showGoalAssignmentModal: Bool = false
    
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
                        .padding(.horizontal)
                }
                Spacer()
            }
            
            ZStack(alignment: .leading) {
                HStack {
                    Image("heart_balloon")
                        .resizable()
                        .frame(width: 180, height: 100)
                        .padding()
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(profileData?.firstname ?? "[First Name]")
                        .font(.custom("Acme", size: 24))
                        .foregroundColor(.black)
                    Text("Relationship Goals")
                        .font(.custom("Acme", size: 24))
                        .foregroundColor(.black)
                }
                .padding(.leading, 105)
            }
            .frame(height: 100)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top, 10)
            
            Text("Relationship Goals are for single -use. \nOnce you assign to a match, dating partner\nor committed couple you cannot reverse the\nassignment.")
                .fontWeight(.medium)
                .font(.custom("Inter", size: 11))
                .foregroundColor(Color("text_color_12"))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 45)
                .padding(.bottom, 20)
            
            if showEmptyView {
                Text("You have not purchased any \nRelationship Goals Yet")
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
                            MyRelationshipPlanListItemView(relationshipPlan: item, isModalPresented: $showGoalAssignmentModal, index: index + 1)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .customPopupView(isPresented: $showGoalAssignmentModal, popupView: { RelationshipGoalAssignmentModalView(isPresented: $showGoalAssignmentModal)})
        .appLoaderView(isPresented: $isLoaderShown, loaderView: { SwiftUISpinLoaderView() }, backgroundColor: Color("loader_bg_color"))
        .navigationBarHidden(true)
        .onAppear {
            do {
                self.profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .ProfileData, castTo: ProfileModel.self)
                print(self.profileData!)
            } catch {
                print(error.localizedDescription)
            }
            getMyRelationshipPlans()
        }
    }
    
    func getMyRelationshipPlans() {
        isLoaderShown = true

        let params : [String : Any]? = [:]
        
        API.shared.sendData(url: APIPath.myRelationshipPlans, requestType: .get, params: params, objectType: MyRelationshipPlanResponse.self, isTokenRequired: true) { (data, status)  in
            isLoaderShown = false
            if status == false {
                showEmptyView = true
                showEmptyView = false
               self.relationshipPlans = [MyRelationshipPlanResponseData(deadline_date_setting: "4234", id: 0, name: "Birthday Party", partner_name: "Test", percentage_complete: "30", plan_id: 1, plan_title: "No One Yet", reminder_status: "No DeadLine Set") ]

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

struct MyRelationshipPlansView_Previews: PreviewProvider {
    static var previews: some View {
        MyRelationshipPlansView()
    }
}
