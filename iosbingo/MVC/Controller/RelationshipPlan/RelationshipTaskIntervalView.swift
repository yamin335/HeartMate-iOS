//
//  RelationshipTaskIntervalView.swift
//  iosbingo
//
//  Created by Md. Yamin on 12/17/22.
//

import SwiftUI

struct RelationshipTaskIntervalView: View {
    @Binding var interval: MyRelationshipPlanChecklistItem
    @State var showEmptyView: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text(interval.interval ?? "Untitled Interval")
                .font(.custom("Inter", size: 20))
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.black)
            
            if showEmptyView {
                VStack {
                    Spacer()
                    Text("No relationship tasks found!")
                        .font(.custom("Acme", size: 22))
                        .foregroundColor(Color("text_color_13"))
                        .opacity(0.75)
                    Spacer()
                }
                .padding(.top, 100)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array($interval.tasks.enumerated()), id: \.offset) { index, $task in
                        RelationshipPlanTaskView(task: $task)
                    }
                }
            }
        }
        .onAppear {
            showEmptyView = interval.tasks.isEmpty
        }
    }
}
