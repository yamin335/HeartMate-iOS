//
//  PrimerThreeView.swift
//  iosbingo
//
//  Created by Md. Yamin on 11/19/22.
//

import SwiftUI

struct PrimerThreeView: View {
    @State private var selection: Int? = nil
    @State var isLoaderShown: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Level 1 - Invite your \nmatches to become your\ndating partners.")
                .fontWeight(.black)
                .font(.custom("Inter", size: 22))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.init(top: 100, leading: 30, bottom: 70, trailing: 30))
            
     
           Text("Level 1 - Invite your \nmatches to become your\ndating partners.")
                    .font(.custom("Inter", size: 22))
                    .foregroundColor(Color("text_color_10"))
                    .padding(EdgeInsets(top: 25, leading: 20, bottom: 25, trailing: 20))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .padding(.horizontal, 20)
            
            Spacer()
            
            Text("Does this mean my dating partner \nand I are exclusive?")
                .font(.custom("Inter", size: 15))
                .foregroundColor(Color("text_color_11"))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 30)
                .padding(.horizontal, 30)
            
            NavigationLink(destination: ValueMeInventoryView(), tag: 1, selection: $selection) {
          
                Button(action: {
                    getProfileData()
                }) {
                    Text("Take inventory of your life")
                        .font(.custom("Inter", size: 13).bold())
                        .foregroundColor(.black)
                        .padding(.init(top: 9, leading: 30, bottom: 9, trailing: 30))
                        .background(Color("blue_color_5"))
                        .cornerRadius(radius: 38, corners: .allCorners)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                }
                    
                //}
            }.isDetailLink(false)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("bg_color_2"), ignoresSafeAreaEdges: .all)
        .appLoaderView(isPresented: $isLoaderShown, loaderView: { SwiftUISpinLoaderView() }, backgroundColor: Color("loader_bg_color"))
    }
    
    func getLifeInventoryCategories() {
        
        isLoaderShown = true

       let userID = AppUserDefault.shared.getValueInt(for: .UserID)
        
        var params : [String:Any] = [:]
   
            params["user_id"] = userID
        
        
        API.shared.sendData(url: APIPath.getLifeInventory, requestType: .post, params: params, objectType: LifeInventoryCategoryResponse.self) { (data, status)  in
            
            //isLoaderShown = false
            
            guard let lifeInventoryCategories = data else {
                return
            }
            
            AppUserDefault.shared.lifeInventoryCategories = lifeInventoryCategories.categories

            if AppUserDefault.shared.lifeInventoryCategories.count > 0 {
                loadUnity()
            }
        }
    }
    
    func getProfileData(){
        isLoaderShown = true
        let userID = AppUserDefault.shared.getValueInt(for: .UserID)
        let cache = randomString(length: 32)
        let params = ["user_id":userID,"cache":cache] as [String:Any]
        API.shared.sendData(url: APIPath.profile, requestType: .get, params: params, objectType: ProfileModel.self, isTokenRequired: false) { (data,status)  in
            if status {
                guard let profileData = data else {return}
                Unity.shared.profileData = profileData
               
                DispatchQueue.main.async {
                    self.getLifeInventoryCategories()
                }

            }else{
 
                print("Error found")
            }
        }
    }
    
    func loadUnity() {

            AppUserDefault.shared.selectedCategoryIndex = 0
        
            let lifeSpectrum = LifeSpectrum()

            lifeSpectrum.registrationLevel = AppUserDefault.shared.selectedCategoryIndex
     
            // for the first visit of user unity module will show demo
             Unity.shared.unityMode = .DEMO_MODE
            lifeSpectrum.unityModuleState = Unity.shared.unityMode.rawValue
        
        
            let format = Date().getFormattedDate(format: "MMM dd yyyy")
            lifeSpectrum.day = "as of " + format
        
            
            let aspects = Aspects()
            lifeSpectrum.aspects = aspects
            
            let encoder = JSONEncoder()
            
            let data = try! encoder.encode(lifeSpectrum)
            
            let json = String(data: data, encoding: .utf8)!
            print(json)
            
            selection = 1
            
            Unity.shared.setHostMainWindow(UIApplication.shared.windows.first!)
            Unity.shared.show()
            Unity.shared.sendMessage(
                "Recieve From Host App Message",
                methodName: "MessageFromHostiOSApp",
                message: json)
    }
}

struct PrimerThreeView_Previews: PreviewProvider {
    static var previews: some View {
        PrimerThreeView()
    }
}
