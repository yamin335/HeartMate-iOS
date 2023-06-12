//
//  CircularProgressBar.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 10/13/22.
//

import SwiftUI



struct CircularProgressBar: View {
    @Binding var progress: Float
    let trackColorStart: Color
    let trackColorEnd: Color
    let progressColor: Color
 
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                Text(String(format: "%.0f%%", min(self.progress, 100)))
                    .foregroundColor(.white)
                    .padding(.bottom, -2)
                    .zIndex(1)
                Circle()
                    .stroke(lineWidth: 12.0)
                    //.foregroundColor(trackColor)
                    .overlay(Circle()
                                .trim(from: 0.0, to: CGFloat(min(self.progress/100, 1.0)))
                                .stroke(AngularGradient(colors: [trackColorStart, trackColorEnd], center: .center), style: StrokeStyle(lineWidth: 12, lineCap: .butt, lineJoin: .miter))
                                .rotationEffect(.degrees(-90))
                                //.shadow(radius: 2)
                                //.stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                                .foregroundColor(progressColor)
                                //.rotationEffect(Angle(degrees: 270.0))
                                .animation(.linear, value: true))
                    .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                Spacer()
            }
        }
    }
}



struct CustomProgressView: View {
    @Binding var progress: CGFloat
    var body: some View {
        ZStack {
            // placeholder
            Circle() .stroke(lineWidth: 20) .foregroundColor(.gray) .background(Color("ringbg"))
            // progresscircle
            Circle() .trim(from: 0.0, to: min(progress, 1.0))
            .stroke(AngularGradient(colors: [.yellow, .orange, .pink, .red], center: .center), style: StrokeStyle(lineWidth: 20, lineCap: .butt, lineJoin: .miter))
            .rotationEffect(.degrees(-90))
            .shadow(radius: 2);
            
            Text("\(String(format: "%0.0f", progress * 100))%") .font(.largeTitle) } .frame(width: 200, height: 200) .padding() .animation(.easeInOut, value: progress) } }
