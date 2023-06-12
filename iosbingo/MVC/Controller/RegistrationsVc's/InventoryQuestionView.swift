//
//  InventoryQuestionView.swift
//  iosbingo
//
//  Created by Md. Yamin on 11/30/22.
//

import SwiftUI

struct InventoryQuestionView: View {
    @Binding var question: LifeInventoryQuestion
    @State private var progressValue: Double = 0.0
    @State private var txtValue: String = "0"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(question.question)
                .foregroundColor(.white)
                .font(.custom("Inter", size: 14))
                .padding(.top, 10)
                .padding(.horizontal, 16)
            
            HStack(spacing: 0) {
                Slider(value: $progressValue, in: question.min...question.max, step: 1) { value in
                    self.txtValue = String(format: "%.0f", Double(progressValue))
                }
                
                TextField("", text: $txtValue)
                    .font(.custom("Inter", size: 12))
                    .keyboardType(.decimalPad)
                    .foregroundColor(Color("dark_gray_bg"))
                    .padding(2)
                    .background(.white)
                    .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.gray, lineWidth: 1))
                    .frame(width: 50)
                    .multilineTextAlignment(.center)
                    .padding(.leading, 15)
                
                VStack(spacing: 0) {
                    Button(action: {
                        if progressValue <= 99 {
                            progressValue += 1
                            self.txtValue = String(format: "%.0f", Double(progressValue))
                        }
                    }) {
                        Image(systemName: "chevron.up")
                            .resizable()
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .black))
                            .frame(width: 10, height: 7.5)
                            .padding(5)
                    }
                    
                    Button(action: {
                        if progressValue >= 1 {
                            progressValue -= 1
                            self.txtValue = String(format: "%.0f", Double(progressValue))
                        }
                    }) {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .black))
                            .frame(width: 10, height: 7.5)
                            .padding(5)
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("text_color_11"), lineWidth: 1))
                .padding(.leading, 8)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(Color("gray_color_5"))
            .padding(.top, 15)
            .padding(.horizontal, 15)
        }
        .padding(.vertical, 5)
        .onChange(of: progressValue) { newValue in
            question.answer = newValue
            txtValue = String(format: "%.0f", Double(newValue))
        }
        .onChange(of: txtValue) { newValue in
            guard let value = Double(newValue), value != progressValue else {return}
            progressValue = value
        }
    }
}

//struct InventoryQuestionView_Previews: PreviewProvider {
//    static var previews: some View {
//        InventoryQuestionView()
//    }
//}
