//
//  CongratsView.swift
//  iosbingo
//
//  Created by Md. Yamin on 11/19/22.
//

import SwiftUI

struct CongratsView: View {
    @State private var selection: Int? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                Circle().fill(.black).frame(width: 6, height: 6)
                
                Image("heart_circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                
                Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                
                Group {
                    Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                    
                    Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                    
                    Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                    
                    Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                    
                    Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                }
                
                Group {
                    Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                    
                    Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                    
                    Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                    
                    Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                    
                    Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                    
                    Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                    
                    Circle().fill(Color("communalstart")).frame(width: 6, height: 6)
                }
                
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
            ZStack {
                Image("congrats_confetti")
                    .resizable()
                    .scaledToFit()
                
                VStack(spacing: 0) {
                    Image("congrats_thumbs_up")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 116, height: 125)
                    
                    Text(" GREAT JOB ")
                        .kerning(-4.5)
                        .font(.custom("Boogaloo", size: 45))
                        .foregroundColor(Color("blue_color_7"))
                        .padding(.top, -20)
                        .padding(.bottom, 50)
                }
            }
            .frame(height: 330)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.bottom, -185)
            .zIndex(2)
            
            VStack(spacing: 0) {
                Image("score_banner")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 265, height: 105)
                    .overlay(Text(Unity.shared.lifeSpectrum?.category_title ?? "")
                        .multilineTextAlignment(.center)
                           .frame(width: 200)
                    .font(.custom("IrishGrover", size: 15)).foregroundColor(.white)
                    .padding(.bottom, 28))
                    .padding(.bottom, -60)
                    
                    .padding(.top, 85)
                    .zIndex(1)
                
                Image("score_container")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 190, height: 115)
                    .overlay(Text("\(Unity.shared.lifeSpectrum?.category_total ?? 0)").font(.custom("Boogaloo", size: 45)).shadow(radius: 4).foregroundColor(.white))
                    .padding(.bottom, 30)
                
                Text(Unity.shared.lifeSpectrum?.category_comment ?? "")
                    .font(.custom("Inter", size: 15))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                
                Text(Unity.shared.lifeSpectrum?.direction ?? "")
                    .font(.custom("Inter", size: 15))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                
                
                NavigationLink(destination: getDestination(), tag: 1, selection: $selection) {
                    Button(action: {
                       
                        if AppUserDefault.shared.selectedCategoryIndex <= 8 {
                            AppUserDefault.shared.selectedCategoryIndex = AppUserDefault.shared.selectedCategoryIndex + 1
                            selection = 1
                           // loadUnity()
                        } else {
                            AppUserDefault.shared.selectedCategoryIndex = 0
                            selection = 1
                        }
                    }) {
                        Text("CONTINUE")
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(Color("text_color_10"))
                            .padding(.vertical, 10)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .overlay(Rectangle().stroke(Color("blue_color_6"), lineWidth: 1))
                            
                    }
                    .padding([.horizontal, .bottom], 30)
                }
                
                
            }
            .frame(width: 320)
            .background(.white)
            .cornerRadius(10)
            .padding(.bottom, 60)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Image("congrats_view_bg").resizable().edgesIgnoringSafeArea(.all))
    }
    
    
    @ViewBuilder func getDestination() -> some View {
           if AppUserDefault.shared.selectedCategoryIndex < 8  {
               PrimerFourView()
               //ValueMeInventoryView()
           } else {
                PrimerFourView()
           }
       }
    
    func loadUnity() {

        let lifeSpectrum = LifeSpectrum()
                
        if let profile = Unity.shared.profileData, let spectrumResponse =  Unity.shared.lifeSpectrum {
            
            if Unity.shared.unityMode == .DEMO_MODE {
                Unity.shared.unityMode = .REGISTRATION_MODE
            }
            lifeSpectrum.unityModuleState = Unity.shared.unityMode.rawValue
            lifeSpectrum.audioURL = spectrumResponse.spectrum_response
        
            let format = Date().getFormattedDate(format: "MMM dd yyyy")
            lifeSpectrum.day = "as of " + format
            Unity.shared.profileData?.spectrum.lastUpdated = lifeSpectrum.day ?? ""
            lifeSpectrum.aspectsOfMyLife = spectrumResponse.running_total
           
            let aspect = Aspects()
            
            aspect.aesthetic = spectrumResponse.aesthetic_side
            aspect.emotional = spectrumResponse.emotional_side
            aspect.entertainment = spectrumResponse.entertainment_side
            aspect.intellectual = spectrumResponse.intellectual_side
            aspect.professional = spectrumResponse.professional_side
            aspect.sexual = spectrumResponse.sexual_side
            aspect.spiritual = spectrumResponse.spiritual_side
            aspect.village = spectrumResponse.community_side
            lifeSpectrum.aspects = aspect
            
            if let url = URL(string: profile.avatar) {
                lifeSpectrum.imageURL = url.absoluteString
            }
            
            lifeSpectrum.registrationLevel = AppUserDefault.shared.selectedCategoryIndex
            
            print("AppUserDefault.shared.selectedCategoryIndex")
            print(AppUserDefault.shared.selectedCategoryIndex)
            
            let encoder = JSONEncoder()
            
            let data = try! encoder.encode(lifeSpectrum)
            
            let json = String(data: data, encoding: .utf8)!
            
            Unity.shared.setHostMainWindow(UIApplication.shared.windows.first!)
            
            Unity.shared.show()
            Unity.shared.sendMessage(
                "Recieve From Host App Message",
                methodName: "MessageFromHostiOSApp",
                message: json)
        }
    }
}

struct CongratsView_Previews: PreviewProvider {
    static var previews: some View {
        CongratsView()
    }
}
