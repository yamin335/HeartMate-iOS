//
//  MoodRingExplanationView.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 10/14/22.
//

import SwiftUI

struct MoodRingExplanationView: View {
    @Binding var isPresented: Bool
    var existingMoodRingID: Int
    @State var emotionalValue: Float
    @State var mentalValue: Float
    @State var spiritualValue: Float
    @State var communalValue: Float
    @State var physicalValue: Float
    @State var professionalValue: Float
    
    @Binding var emotionalExplanation: String
    @Binding var mentalExplanation: String
    @Binding var spiritualExplanation: String
    @Binding var communalExplanation: String
    @Binding var physicalExplanation: String
    @Binding var professionalExplanation: String
    @Binding var isEmptyExplanation: Bool
    
    @State var emotionalAdded: Bool = false
    @State var mentalAdded: Bool = false
    @State var spiritualAdded: Bool = false
    @State var communalAdded: Bool = false
    @State var physicalAdded: Bool = false
    @State var professionalAdded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("The reasons why")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                if existingMoodRingID == 0 {
                    Image(systemName: "multiply.circle")
                        .resizable()
                        .frame(width: 36, height: 36, alignment: .center)
                        .font(.system(size: 10, weight: .light))
                        .onTapGesture {
                            withAnimation {
                                self.clear()
                                isPresented = false
                            }
                        }
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 10)
            .padding(.top, 15)
            
            if existingMoodRingID != 0 && isEmptyExplanation {
                Text("NONE PROVIDED")
                    .font(.system(size: 25, weight: .bold))
                    .padding(30)
                    .foregroundColor(Color("text_color_1"))
            } else {
                if existingMoodRingID == 0 {
                    Text("Check the box for the explanations you wish to include in today's mood ring")
                        .font(.system(size: 14))
                        .padding(.leading, 20)
                        .padding(.trailing, 10)
                        .padding(.top, 15)
                        .padding(.bottom, 10)
                }
                
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            if existingMoodRingID == 0 {
                                Image(systemName: emotionalAdded ? "checkmark.square.fill" : "square.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(emotionalAdded ? Color("text_color_5") : Color.white)
                                    .frame(width: 18, height: 18)
                                    .onTapGesture {
                                        withAnimation {
                                            emotionalAdded.toggle()
                                        }
                                    }
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Emotionally I am at \(String(format: "%.0f%", emotionalValue))% because" )
                                    .font(.system(size: 14))
                                    .padding(.horizontal, 10)
                                    .padding(.top, 5)
                                TextField("explain", text: $emotionalExplanation)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40, alignment: .topLeading)
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 10)
                            }
                            .background(.white)
                        }
                        .padding(.horizontal, 15)
                        .padding(.top, 15)
                        
                        HStack {
                            if existingMoodRingID == 0 {
                                Image(systemName: mentalAdded ? "checkmark.square.fill" : "square.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(mentalAdded ? Color("text_color_5") : Color.white)
                                    .frame(width: 18, height: 18)
                                    .onTapGesture {
                                        withAnimation {
                                            mentalAdded.toggle()
                                        }
                                    }
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Mentally I am at \(String(format: "%.0f%", mentalValue))% because")
                                    .font(.system(size: 14))
                                    .padding(.horizontal, 10)
                                    .padding(.top, 5)
                                TextField("explain", text: $mentalExplanation)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40, alignment: .topLeading)
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 10)
                            }
                            .background(.white)
                        }
                        .padding(.horizontal, 15)
                        .padding(.top, 15)
                        
                        HStack {
                            if existingMoodRingID == 0 {
                                Image(systemName: spiritualAdded ? "checkmark.square.fill" : "square.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(spiritualAdded ? Color("text_color_5") : Color.white)
                                    .frame(width: 18, height: 18)
                                    .onTapGesture {
                                        withAnimation {
                                            spiritualAdded.toggle()
                                        }
                                    }
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Spiritually I am at \(String(format: "%.0f%", spiritualValue))% because")
                                    .font(.system(size: 14))
                                    .padding(.horizontal, 10)
                                    .padding(.top, 5)
                                TextField("explain", text: $spiritualExplanation)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40, alignment: .topLeading)
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 10)
                            }
                            .background(.white)
                        }
                        .padding(.horizontal, 15)
                        .padding(.top, 15)
                        
                        HStack {
                            if existingMoodRingID == 0 {
                                Image(systemName: communalAdded ? "checkmark.square.fill" : "square.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(communalAdded ? Color("text_color_5") : Color.white)
                                    .frame(width: 18, height: 18)
                                    .onTapGesture {
                                        withAnimation {
                                            communalAdded.toggle()
                                        }
                                    }
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Communally I am at \(String(format: "%.0f%", communalValue))% because")
                                    .font(.system(size: 14))
                                    .padding(.horizontal, 10)
                                    .padding(.top, 5)
                                TextField("explain", text: $communalExplanation)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40, alignment: .topLeading)
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 10)
                            }
                            .background(.white)
                        }
                        .padding(.horizontal, 15)
                        .padding(.top, 15)
                        
                        HStack {
                            if existingMoodRingID == 0 {
                                Image(systemName: physicalAdded ? "checkmark.square.fill" : "square.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(physicalAdded ? Color("text_color_5") : Color.white)
                                    .frame(width: 18, height: 18)
                                    .onTapGesture {
                                        withAnimation {
                                            physicalAdded.toggle()
                                        }
                                    }
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Physically I am at \(String(format: "%.0f%", physicalValue))% because")
                                    .font(.system(size: 14))
                                    .font(.system(size: 14))
                                    .padding(.horizontal, 10)
                                    .padding(.top, 5)
                                TextField("explain", text: $physicalExplanation)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40, alignment: .topLeading)
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 10)
                            }
                            .background(.white)
                        }
                        .padding(.horizontal, 15)
                        .padding(.top, 15)
                        
                        HStack {
                            if existingMoodRingID == 0 {
                                Image(systemName: professionalAdded ? "checkmark.square.fill" : "square.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(professionalAdded ? Color("text_color_5") : Color.white)
                                    .frame(width: 18, height: 18)
                                    .onTapGesture {
                                        withAnimation {
                                            professionalAdded.toggle()
                                        }
                                    }
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Professionally I am at \(String(format: "%.0f%", professionalValue))% because")
                                    .font(.system(size: 14))
                                    .padding(.horizontal, 10)
                                    .padding(.top, 5)
                                TextField("explain", text: $professionalExplanation)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40, alignment: .topLeading)
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 10)
                            }
                            .background(.white)
                            .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 15)
                        .padding(.top, 15)
                    }
                }
                
                if existingMoodRingID == 0 {
                    HStack {
                        Spacer()
                        Button(action: {
                            // Call API
                            self.saveRingMood()
                        }) {
                            Text("SAVE")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color("yellow_color_1"))
                                .cornerRadius(6)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .background(Color("gray_color_1"))
        .padding(.vertical)
        .padding(.horizontal, 30)
        .onAppear() {
            self.emotionalExplanation =    AppUserDefault.shared.getValue(for: "emotionally_explanation")
            self.mentalExplanation = AppUserDefault.shared.getValue(for: "mentally_explanation")
            self.spiritualExplanation = AppUserDefault.shared.getValue(for: "spiritually_explanation")
            self.communalExplanation = AppUserDefault.shared.getValue(for: "physically_explanation")
            self.physicalExplanation = AppUserDefault.shared.getValue(for: "physically_explanation")
            self.professionalExplanation = AppUserDefault.shared.getValue(for: "professionally_explanation")
            
            
            
            self.emotionalAdded = AppUserDefault.shared.getValueBool(for: "emotionalAdded")
            self.mentalAdded = AppUserDefault.shared.getValueBool(for: "mentalAdded")
            self.spiritualAdded = AppUserDefault.shared.getValueBool(for: "spiritualAdded")
            self.communalAdded = AppUserDefault.shared.getValueBool(for: "communalAdded")
            self.physicalAdded = AppUserDefault.shared.getValueBool(for: "physicalAdded")
            self.professionalAdded = AppUserDefault.shared.getValueBool(for: "professionalAdded")
        }
        
    }
    
    func clear(){
        
    }
    
    func saveRingMood() {
        
                if emotionalAdded {
                   
                    AppUserDefault.shared.set(value: emotionalExplanation, for: "emotionally_explanation")
                    AppUserDefault.shared.set(value: true, for: "emotionalAdded")

                } else {
                    AppUserDefault.shared.set(value: false, for: "emotionalAdded")
                }
        
                if mentalAdded {
                    AppUserDefault.shared.set(value: emotionalExplanation, for: "mentally_explanation")
                    AppUserDefault.shared.set(value: true, for: "mentalAdded")
                }else {
                    AppUserDefault.shared.set(value: false, for: "mentalAdded")
                }
        
        
                if spiritualAdded {
                    AppUserDefault.shared.set(value: emotionalExplanation, for: "spiritually_explanation")
                    AppUserDefault.shared.set(value: true, for: "spiritualAdded")
                } else {
                    AppUserDefault.shared.set(value: false, for: "spiritualAdded")
                }
        
        
                if communalAdded {
                    AppUserDefault.shared.set(value: emotionalExplanation, for: "communally_explanation")
                    AppUserDefault.shared.set(value: true, for: "communalAdded")
                } else {
                    AppUserDefault.shared.set(value: false, for: "communalAdded")
                }
        
                if physicalAdded {
                    AppUserDefault.shared.set(value: emotionalExplanation, for: "physically_explanation")
                    AppUserDefault.shared.set(value: true, for: "physicalAdded")
                } else {
                    AppUserDefault.shared.set(value: false, for: "physicalAdded")
                }
        
                if professionalAdded {
                    AppUserDefault.shared.set(value: emotionalExplanation, for: "professionally_explanation")
                    AppUserDefault.shared.set(value: true, for: "professionalAdded")
                } else {
                    AppUserDefault.shared.set(value: false, for: "professionalAdded")
                }
        isPresented = false
    }
    
//    func saveRingMood(){
//
//        let cookie = AppUserDefault.shared.getValue(for: .Cookie)
//
//        var params = ["key":key,"cookie":cookie] as [String:Any]
//
//
//        params["emotionally"] = emotionalValue
//        params["mentally"] = mentalValue
//        params["physically"] = physicalValue
//        params["communally"] = communalValue
//        params["professionally"] = professionalValue
//        params["spiritually"] = spiritualValue
//
//        if emotionalAdded {
//            params["emotionally_explanation"] = emotionalExplanation
//        }
//
//        if mentalAdded {
//            params["mentally_explanation"] = mentalExplanation
//        }
//
//        if spiritualAdded {
//            params["spiritually_explanation"] = spiritualExplanation
//        }
//
//        if communalAdded {
//            params["communally_explanation"] = communalExplanation
//        }
//
//        if physicalAdded {
//            params["physically_explanation"] = physicalExplanation
//        }
//
//        if professionalAdded {
//            params["professionally_explanation"] = professionalExplanation
//        }
//
//        API.shared.sendData(url: APIPath.saveDailyMoodRing, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
//            if status {
//                isPresented = false
//                guard let validationCookie = data else {return}
//
//            } else {
//                print("Error found")
//               // completion(false)
//            }
//        }
//    }
}

struct MoodRingExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        MoodRingExplanationView(isPresented: .constant(false), existingMoodRingID: 0, emotionalValue: 20, mentalValue: 10, spiritualValue: 50, communalValue: 30, physicalValue: 2, professionalValue: 33, emotionalExplanation: .constant(""), mentalExplanation: .constant(""), spiritualExplanation: .constant(""), communalExplanation: .constant(""), physicalExplanation: .constant(""), professionalExplanation: .constant(""), isEmptyExplanation: .constant(false))
    }
}
