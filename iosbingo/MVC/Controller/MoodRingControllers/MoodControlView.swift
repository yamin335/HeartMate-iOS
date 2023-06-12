//
//  MoodControlView.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 10/13/22.
//

import SwiftUI

struct MoodControlView: View {
    
    @Binding var existingMoodRingID: Int
    @Binding var emotionalValue: Float
    @Binding var mentalValue: Float
    @Binding var spiritualValue: Float
    @Binding var communalValue: Float
    @Binding var physicalValue: Float
    @Binding var professionalValue: Float
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        if emotionalValue < 100 {
                            emotionalValue += 10
                        }
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        
                }
                .disabled(existingMoodRingID != 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 28)
                
                Text("Emotionally")
                    .font(.system(size: 7))
                    .padding(.horizontal, 2)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color("purple_color_1"))
                
                Button(action: {
                    withAnimation {
                        if emotionalValue > 0 {
                            emotionalValue -= 10
                        }
                    }
                }) {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                }
                .disabled(existingMoodRingID != 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 28)
                
            }
            .background(Color("blue_color_1"))
            .cornerRadius(22)
            
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        if mentalValue < 100 {
                            mentalValue += 10
                        }
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        
                }
                .disabled(existingMoodRingID != 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 28)
                
                Text("Mentally")
                    .font(.system(size: 7))
                    .padding(.horizontal, 2)
                    .padding(.vertical, 8)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .background(Color("cyan_color_1"))
                
                Button(action: {
                    withAnimation {
                        if mentalValue > 0 {
                            mentalValue -= 10
                        }
                    }
                }) {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                }
                .disabled(existingMoodRingID != 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 28)
                
            }
            .background(Color("blue_color_1"))
            .cornerRadius(22)
            
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        if spiritualValue < 100 {
                            spiritualValue += 10
                        }
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        
                }
                .disabled(existingMoodRingID != 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 28)
                
                Text("Spiritually")
                    .font(.system(size: 7))
                    .padding(.horizontal, 2)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color("orange_color_2"))
                
                Button(action: {
                    withAnimation {
                        if spiritualValue > 0 {
                            spiritualValue -= 10
                        }
                    }
                }) {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                }
                .disabled(existingMoodRingID != 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 28)
                
            }
            .background(Color("blue_color_1"))
            .cornerRadius(22)
            
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        if communalValue < 100 {
                            communalValue += 10
                        }
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        
                }
                .disabled(existingMoodRingID != 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 28)
                
                Text("Communally")
                    .font(.system(size: 7))
                    .padding(.horizontal, 2)
                    .padding(.vertical, 8)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .background(Color("gray_color_1"))
                
                Button(action: {
                    withAnimation {
                        if communalValue > 0 {
                            communalValue -= 10
                        }
                    }
                }) {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                }
                .disabled(existingMoodRingID != 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 28)
                
            }
            .background(Color("blue_color_1"))
            .cornerRadius(22)
            
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        if physicalValue < 100 {
                            physicalValue += 10
                        }
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        
                }
                .disabled(existingMoodRingID != 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 28)
                
                Text("Physically")
                    .font(.system(size: 7))
                    .padding(.horizontal, 2)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color("green_color_4"))
                
                Button(action: {
                    withAnimation {
                        if physicalValue > 0 {
                            physicalValue -= 10
                        }
                    }
                }) {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                }
                .disabled(existingMoodRingID != 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 28)
                
            }
            .background(Color("blue_color_1"))
            .cornerRadius(22)
            
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        if professionalValue < 100 {
                            professionalValue += 10
                        }
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        
                }
                .disabled(existingMoodRingID != 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 28)
                
                Text("Professionally")
                    .font(.system(size: 7))
                    .padding(.horizontal, 2)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color("yellow_color_2"))
                
                Button(action: {
                    withAnimation {
                        if professionalValue > 0 {
                            professionalValue -= 10
                        }
                    }
                }) {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                }
                .disabled(existingMoodRingID != 0)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 28)
                
            }
            .background(Color("blue_color_1"))
            .cornerRadius(22)
        }
    }
}

//struct MoodControlView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoodControlView(existingMoodRingID: Binding<0>, emotionalValue: .constant(1), mentalValue: .constant(1), spiritualValue: .constant(1), communalValue: .constant(1), physicalValue: .constant(1), professionalValue: .constant(1))
//    }
//}
