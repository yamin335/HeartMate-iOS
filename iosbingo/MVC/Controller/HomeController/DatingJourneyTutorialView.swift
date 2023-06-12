//
//  DatingJourneyTutorialView.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 10/10/22.
//



import SwiftUI

struct DatingJourneyTutorialView: View {
    @State var tutorial: DatingJourneyTutorial = DatingJourneyTutorial()
    let buttonActionDelegate: UIButtonActionDelegateForDatingJourney?
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("thumb")
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.top, 20)
            
            Text("To Value Me")
                .font(.custom("Acme", size: 16))
                .foregroundColor(.black)
                .padding(.top, 18)
            
            Text(tutorial.title)
                .font(.custom("Acme", size: 24))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .padding(.horizontal, 50)
            
            
            Text(tutorial.subTitle)
                .font(.custom("Inter", size: 15))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .padding(.horizontal, 10)

            if AppUserDefault.shared.getValueBool(for: .isUserRegistering) {
                VStack(spacing: 0) {
                    Text("Self-check before you start your")
                        .font(.custom("Inter", size: 15))
                        .fontWeight(.light)
                        .foregroundColor(.black)
                    
                    Text("To Value Me journey:")
                        .font(.custom("Inter", size: 13))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding(.top, 20)
                .padding(.bottom, 18)
            }

         

            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(tutorial.header)
                        .font(.custom("Inter", size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    ForEach(Array(tutorial.bullets.enumerated()), id: \.offset) { index, item in
                        HStack(alignment: .top, spacing: 10) {
                            Circle()
                                .frame(width: 5, height: 5)
                                .foregroundColor(.black)
                                .padding(.top, 6)
                            
                            Text(item)
                                .font(.custom("Inter", size: 15))
                                .fontWeight(.light)
                                .foregroundColor(.black)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                        
                        .padding(.top, 15)
                        
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
            }
            .background(Color.white.shadow(color: .gray, radius: 5))
            .padding(.top, 25)
            .padding(.horizontal, 15)

            Spacer()
            
            if AppUserDefault.shared.getValueBool(for: .isUserRegistering) {
                VStack {
                    Button(action: {
                        buttonActionDelegate?.onYesButtonAction()
                    }) {
                        Text("Yes, I Have Someone in Mind!")
                            .font(.custom("Inter", size: 16))
                            .fontWeight(.light)
                            .foregroundColor(.black)
                            .frame(height: 34)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("yellow_color_1"))
                            .cornerRadius(20)
                    }
                    .padding(.horizontal, 28)
                    
                    Button(action: {
                        buttonActionDelegate?.onNotYetButtonAction()
                    }) {
                        Text("Not Yet")
                            .font(.custom("Inter", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 22)
                }
                
            } else {
                Button(action: {
                    if let tabBarController =  UIApplication.shared.windows.first?.rootViewController as? UITabBarController {
                        tabBarController.selectedIndex = 3
                    }
                }) {
                    Text("Start My First Dating Journey")
                        .font(.custom("Inter", size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(height: 40)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color("yellow_color_1"))
                        .cornerRadius(20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                .padding(.bottom, 30)
            }

            Button(action: {
                if let tabBarController =  UIApplication.shared.windows.first?.rootViewController as? UITabBarController {
                       tabBarController.selectedIndex = 3
                   }
            }) {
                Text("Yes, I Have Someone in Mind!")
                    .font(.custom("Inter", size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(height: 40)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color("yellow_color_1"))
                    .cornerRadius(20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .padding(.bottom, 10)
            
            Button(action: {
                if let tabBarController =  UIApplication.shared.windows.first?.rootViewController as? UITabBarController {
                       tabBarController.selectedIndex = 3
                   }
            }) {
                Text("Not Yet")
                    .font(.custom("Inter", size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(height: 40)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(.clear)
                    .cornerRadius(20)
                    .frame(width: 100)
                    .frame(alignment: .center)
            }
            .padding(.top, 0)
            .padding(.bottom, 30)

        }
        .background(Color("bg_color_2"))
        .cornerRadius(23)
        .padding(AppUserDefault.shared.getValueBool(for: .isUserRegistering) ? 0 : 20)
        .onAppear() {
            if AppUserDefault.shared.getValueBool(for: .isUserRegistering) {
                self.tutorial = DatingJourneyTutorial(title: "Are You Ready?", subTitle: tutorial.subTitle, header: "Regarding your last few conversations", bullets: [
                    "Did I Feel Comfortable?",
                    "They were not hijacking the conversation from me?",
                    "They were adding value to the conversation(s) and not just waiting for their turn to speak when I shared?"
                ])
            } else {
                getDatingJourneyData()
            }
        }
    }
    
    
    func getDatingJourneyData(){
        //AppLoader.shared.show(currentView: self.view)
        API.shared.getDatingjourney(url: APIPath.datingJourneys, requestType: .get, params: nil) { (journeyData, tutorialData,status)  in
            DispatchQueue.main.async {
                if status {
                    if let datingJourneys = journeyData {
                        
                        //self.journeys = datingJourneys
                    } else if let tutorial = tutorialData {
                        self.tutorial = tutorial
                      
                    }
                } else if let tutorial = tutorialData {
                    self.tutorial = tutorial
                  
                } else {
                  
                }
            }
        }
    }
}
