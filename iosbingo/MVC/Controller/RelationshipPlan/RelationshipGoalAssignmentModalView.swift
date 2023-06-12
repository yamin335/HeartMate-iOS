//
//  RelationshipGoalAssignmentModal.swift
//  iosbingo
//
//  Created by Md. Yamin on 12/17/22.
//

import SwiftUI

struct RelationshipGoalAssignmentModalView: View {
    @State var deadLine: String = ""
    @State var menuLabel: String = "Select Partner"
    @State var partners: [String] = ["Partner-1", "Partner-2", "Partner-3"]
    @State var savedDate: Date = .now
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "multiply")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.black)
                        .frame(width: 18, height: 18)
                        .font(.system(size: 14, weight: .light))
                        .padding([.top, .trailing], 16)
                }
            }
            
            Text("Assign this \nrelationship goal to:")
                .font(.custom("Acme", size: 24))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 20)
            
            HStack(alignment: .center, spacing: 0) {
                Menu {
                    ForEach(partners.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                menuLabel = partners[index]
                            }
                        }) {
                            Text("\(partners[index])")
                        }
                    }
                } label: {
                    HStack(spacing: 10) {
                        Text(menuLabel)
                            .foregroundColor(.black)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 13, height: 13)
                            .foregroundColor(Color("text_color_15"))
                    }
                    .padding(10)
                }
            }
            .background(.white)
            .padding(.horizontal, 24)
            .padding(.top, 10)
            
            Text("Select a Deadline")
                .font(.custom("Acme", size: 24))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 26)
            
            Text("Optional")
                .foregroundColor(Color("text_color_16"))
                .font(.custom("Acme", size: 12))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 3)
            
            VStack(spacing: 0) {
                DatePicker(
                    "",
                    selection: $savedDate,
                    displayedComponents: [.date]
                )
                .background(.black)
                .labelsHidden()
                //.padding(.trailing,10)
                .colorScheme(.dark)
                .labelsHidden()
                //.transformEffect(.init(scaleX: 0.7, y: 0.7))
                //.foregroundColor(Color("gray_color_4"))
                .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 10)
            .background(.black)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .frame(height: 36)
            .padding(.top, 8)
            
//            TextField("", text: $deadLine)
//                .frame(height: 36)
//                .padding(.horizontal, 10)
//                .background(.white)
//                .padding(.horizontal, 24)
//                .padding(.top, 8)
            
            Button(action: {
                isPresented = false
            }) {
                Text("Update")
                    .foregroundColor(.black)
                    .font(.custom("Inter", size: 24))
            }
            .frame(width: 170, height: 55)
            .background(Color("yellow_color_1"))
            .cornerRadius(8)
            .padding(.top, 40)
            .padding(.bottom, 24)
        }
        .background(Color("communalstart"))
        .cornerRadius(10)
        .padding(.horizontal, 30)
    }
}
