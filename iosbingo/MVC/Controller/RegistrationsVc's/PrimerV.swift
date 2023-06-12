//
//  PrimerV.swift
//  iosbingo
//
//  Created by Md. Mamun Ar Rashid on 11/19/22.
//

import SwiftUI

struct PrimerV: View {
    
    @State var selection: Int? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Understanding the Possibilities")
                .font(.custom("Acme-Regular", size: 24))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
                .padding(.bottom, 55)
                .padding(.top, 40)
            
            Text("52 Weeks in a year.")
                .font(.custom("Inter-Light", size: 15))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                //.padding(.horizontal, 30)
                .padding(.bottom, 40)
            
            Text("104 dates & other experiences are\navailable if you are willing to see \nyour dating partner 2 times a week.")
                .font(.custom("Inter-Light", size: 15))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                //.padding(.horizontal, 30)
                .padding(.bottom, 40)
            
            Text("365 experiences per year await you \nand your potential marriage partner.")
                .font(.custom("Inter-Light", size: 15))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                //.padding(.horizontal, 30)
                .padding(.bottom, 93)
     
            
            Text("Welcome to\nPurpose-Driven Dating")
                .fontWeight(.bold)
                .font(.custom("Inter", size: 20))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            Spacer()
            NavigationLink(destination: ToValueMeReportViewControllerWrapper(), tag: 1, selection: $selection) {
                Button(action: {
                    selection = 1
                    //                let nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    //                UIApplication.shared.windows.first?.rootViewController = nav
                    //                UIApplication.shared.windows.first?.makeKeyAndVisible()
                }) {
                    Text("Review My Value")
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

struct PrimerFourView_Previews: PreviewProvider {
    static var previews: some View {
        PrimerFourView()
    }
}
