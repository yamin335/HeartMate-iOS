//
//  RelationshipPlanTaskView.swift
//  iosbingo
//
//  Created by Md. Yamin on 12/17/22.
//

import SwiftUI

struct RelationshipPlanTaskView: View {
    @Binding var task: MyRelationshipPlanTask
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Button(action: {
                withAnimation {
                    var isChecked = task.isChecked ?? false
                    task.isChecked = !isChecked
                }
            }) {
                Image(systemName: task.isChecked == true ? "checkmark.square.fill" : "square")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(task.isChecked == true ? Color("check_box_pressed_color") : Color.black)
                    .frame(width: 21, height: 21)
                    .padding(.leading, 13)
                    .padding(.vertical, 9)
                    .padding(.trailing, 21)
            }
            
            Text(task.task ?? "Unknown Task")
                .font(.custom("Inter", size: 15))
                .foregroundColor(.black)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
    }
}
