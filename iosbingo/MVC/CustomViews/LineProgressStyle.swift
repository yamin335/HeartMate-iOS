//
//  LineProgressStyle.swift
//  iosbingo
//
//  Created by Md. Yamin on 11/19/22.
//

import SwiftUI

struct LineProgressStyle<Background: ShapeStyle>: ProgressViewStyle {
    var backgroundColor: Background
    var progressColor: Background
    var cornerRadius: CGFloat
    var height: CGFloat
    var caption: String = ""
    var animation: Animation = .easeInOut
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return VStack {
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    Rectangle()
                        .fill(backgroundColor)
                        .frame(maxWidth: geo.size.width)
                    
                    Rectangle()
                        .fill(progressColor)
                        .frame(maxWidth: geo.size.width * CGFloat(fractionCompleted))
                        .animation(animation, value: 0)
                }
            }
            .frame(height: height)
            .cornerRadius(cornerRadius)
//            .overlay(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                        .stroke(stroke, lineWidth: 2)
//            )
            
            if !caption.isEmpty {
                Text("\(caption)")
                    .font(.caption)
            }
        }
    }
}
