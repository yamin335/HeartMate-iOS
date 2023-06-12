//
//  ValueMeInventoryView.swift
//  iosbingo
//
//  Created by Md. Yamin on 11/19/22.
//

import SwiftUI

struct ValueMeInventoryView: View {
    
    @State var isLoaderShown: Bool = false
    
    
    @State var lifeInventoryQuestions: [LifeInventoryQuestion] = []
    
    
    
    @State private var gradient = LinearGradient(
        gradient: Gradient(colors: [.red, .green, .blue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    @State private var value: CGFloat = 0.0
    
    @State private var valueFragrance: CGFloat = 10.0
    @State private var valueHairStyle: CGFloat = 10.0
    @State private var valueOutfits: CGFloat = 10.0
    
    @State private var txtValueFragrance: String = "10"
    @State private var txtValueHairStyle: String = "10"
    @State private var txtValueOutfits: String = "10"
    
    @State private var selection: Int? = nil
    
    var body: some View {
        
        let gradientStyle = LineProgressStyle(backgroundColor: Color.black, progressColor: Color("red_color_1"), cornerRadius: 0, height: 7, caption: "", animation: .easeInOut)
        
        VStack {
            HStack  {
                Text("My Entertainment Side")
                    .font(.custom("Inter", size: 12))
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                Image("question_mark")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            ProgressView(value: value/100)
                .padding(.horizontal, 5)
                .padding(.top, 8)
                .progressViewStyle(gradientStyle)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array($lifeInventoryQuestions.enumerated()), id: \.offset) { index, $question in
                        InventoryQuestionView(question: $question)
                    }
                }
            }
            
            NavigationLink(destination: CongratsView(), tag: 1, selection: $selection) {
                Button(action: {
                    updateLifeInventory()
                }) {
                    Text("CONTINUE")
                        .foregroundColor(.white)
                        .font(.custom("Inter", size: 14))
                        .padding(.vertical, 10)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .overlay(Rectangle().stroke(.white, lineWidth: 1))
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Image("value_me_inventory_view_bg").resizable().edgesIgnoringSafeArea(.all))
        .appLoaderView(isPresented: $isLoaderShown, loaderView: { SwiftUISpinLoaderView() }, backgroundColor: Color("loader_bg_color"))
        .onAppear {
            if AppUserDefault.shared.selectedCategoryIndex > 0 {
                let slideCount = AppUserDefault.shared.getValueInt(for: .slideCount)
                self.value = CGFloat(slideCount) * 12.5
            }
            getLifeInventoryCategories()
        }
    }
    
    func updateLifeInventory() {
        isLoaderShown = true
        
        
        var answers: [String : Int] = [:]
        
        for question in lifeInventoryQuestions {
            answers[String(question.topicID)] = Int(question.answer ?? 0)
        }
        
        guard let tempJson = try? JSONSerialization.data(withJSONObject: answers, options: []) else {
            isLoaderShown = false
            return
        }
        
        let jsonString = String(data: tempJson, encoding: .ascii)
        
        var params: [String : Any] = [:]
        params["user_id"] = AppUserDefault.shared.getValue(for: .UserID)
        params["category_id"] = AppUserDefault.shared.lifeInventoryCategories[AppUserDefault.shared.selectedCategoryIndex].categoryID
        params["serialized_json"] = jsonString
        params["category_title"] = AppUserDefault.shared.selectedCategoryIndex <  AppUserDefault.shared.lifeInventoryCategories.count ? AppUserDefault.shared.lifeInventoryCategories[AppUserDefault.shared.selectedCategoryIndex].category : ""
        params["secret"] = SECRET_KEY
              
        API.shared.sendData(url: APIPath.updateInventoryValues, requestType: .post, params: params, objectType: SpectrumResponse.self, isTokenRequired: true) { (data, status)  in
            
            isLoaderShown = false
            
            if data?.status == "ok" {
                
                 let slideCount = AppUserDefault.shared.getValueInt(for: .slideCount)
                 AppUserDefault.shared.set(value: slideCount + 1, for: .slideCount)
            
            
                
                if let spectrumResponse = data  {
                    
                           let aspect = Aspects()
                    
                            aspect.aesthetic = spectrumResponse.aesthetic_side
                            aspect.emotional = spectrumResponse.emotional_side
                            aspect.entertainment = spectrumResponse.entertainment_side
                            aspect.intellectual = spectrumResponse.intellectual_side
                            aspect.professional = spectrumResponse.professional_side
                            aspect.sexual = spectrumResponse.sexual_side
                            aspect.spiritual = spectrumResponse.spiritual_side
                            aspect.village = spectrumResponse.community_side
                            Unity.shared.lifeSpectrum = spectrumResponse
                    
                    let format = Date().getFormattedDate(format: "MMM dd yyyy")
                    AppUserDefault.shared.set(value: "as of " + spectrumResponse.inventory_last_updated, for: .inventoryLastUpdated)
                    AppUserDefault.shared.set(value: spectrumResponse.running_total, for: .aspectsOfMyLife)
                    AppUserDefault.shared.set(value: spectrumResponse.spectrum_response, for: .lifeInventoryAudioURL)
                    
                    
                }
                
                selection = 1
            }
        }
    }
    
    func getLifeInventoryCategories() {
        isLoaderShown = true
        
        var params : [String:Any] = [:]
   
        if AppUserDefault.shared.selectedCategoryIndex < AppUserDefault.shared.lifeInventoryCategories.count {
            params["category_id"] = AppUserDefault.shared.lifeInventoryCategories[AppUserDefault.shared.selectedCategoryIndex].categoryID
        }
        
        params["secret"] = SECRET_KEY
              
        API.shared.sendData(url: APIPath.getLifeQuestions, requestType: .post, params: params, objectType: LifeInventoryQuestionResponse.self) { (data, status)  in
            
            isLoaderShown = false
            
            guard var lifeInventoryQuestions = data?.questions else {
                return
            }
            
            var updatedList: [LifeInventoryQuestion] = []
            
            for question in lifeInventoryQuestions {
                question.answer = Double(question.min)
                updatedList.append(question)
            }
            
            self.lifeInventoryQuestions = updatedList
            
        }
    }
}

struct ValueMeInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        ValueMeInventoryView()
    }
}
