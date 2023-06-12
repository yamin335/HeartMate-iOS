//
//  PrimerV.swift
//  iosbingo
//
//  Created by Md. Mamun Ar Rashid on 11/19/22.
//

import SwiftUI

struct PrimerVI: View {
    
    @State var selection: Int? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text("Progress is made by \npaying attention to \none another.")
                .font(.custom("Inter-Light", size: 15))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                //.padding(.horizontal, 30)
                .padding(.bottom, 40)
            
      
            
            Spacer()
            NavigationLink(destination: ToYourPartnerVCWrapper(), tag: 1, selection: $selection) {
                Button(action: {
                    selection = 1
                    //                let nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    //                UIApplication.shared.windows.first?.rootViewController = nav
                    //                UIApplication.shared.windows.first?.makeKeyAndVisible()
                }) {
                    Text("To Value Me I Need")
                        .font(.custom("Inter-Bold", size: 13))
                        .foregroundColor(.black)
                        .padding(.init(top: 9, leading: 30, bottom: 9, trailing: 30))
                        .background(Color("yellow_color_1"))
                        .cornerRadius(radius: 38, corners: .allCorners)
                    
                        .padding(.bottom, 50)
                } .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.white, ignoresSafeAreaEdges: .all)
        .padding(.leading, 45)
        .padding(.trailing, 45)
    }
}


