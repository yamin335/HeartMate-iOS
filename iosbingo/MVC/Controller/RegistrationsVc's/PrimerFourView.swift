//
//  PrimerFourView.swift
//  iosbingo
//
//  Created by Md. Yamin on 11/19/22.
//

import SwiftUI

struct PrimerFourView: View {

    @State var selection: Int? = nil

    var body: some View {
        
        
        VStack(spacing: 0) {
            Text("Your story behind the\nnumbers")
                .fontWeight(.bold)
                .font(.custom("Inter", size: 22))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.init(top: 100, leading: 30, bottom: 40, trailing: 30))
            
            Text("It is now my dating parterner’s goal to curate dates, interactions, and experiences to learn the story behind my numbers")
                .font(.custom("Inter", size: 22))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
            
            Spacer()
            
            NavigationLink(destination: PrimerV(), tag: 1, selection: $selection) {
                Button(action: {
                    selection = 1
                    //                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ToValueMeReportViewController") as! ToValueMeReportViewController
                    //                fromVC.navigationController?.pushViewController(vc, animated: true)
                    
                }) {
                    Text("To Value Me I Need")
                        .font(.custom("Inter", size: 13).bold())
                        .foregroundColor(.black)
                        .padding(.init(top: 9, leading: 30, bottom: 9, trailing: 30))
                        .background(Color("blue_color_5"))
                        .cornerRadius(radius: 38, corners: .allCorners)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 200)
                }
            }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color("bg_color_2"), ignoresSafeAreaEdges: .all)
        
    }
}

//struct PrimerFourView_Previews: PreviewProvider {
//    static var previews: some View {
//        PrimerFourView()
//    }
//}
