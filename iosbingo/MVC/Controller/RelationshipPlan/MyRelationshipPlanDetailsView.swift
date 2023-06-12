//
//  MyRelationshipPlanDetailsView.swift
//  iosbingo
//
//  Created by Md. Yamin on 12/16/22.
//

import SwiftUI

struct MyRelationshipPlanDetailsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var planId: Int?
    @State var showEmptyView: Bool = true
    @State var relationshipTaskIntervals: [MyRelationshipPlanChecklistItem] = []
    @State var isLoaderShown: Bool = false
    @State var title: String? = "Untitled Plan"
    @State var assignedTo: String? = "No One Yet"
    @State var taskCompleted: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                }) {
                    Image("backarrow")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 25)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing])
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title ?? "Untitled Plan")
                        .font(.custom("Inter", size: 20))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 5) {
                        Text("Assign To")
                            .font(.custom("Inter", size: 11))
                            .foregroundColor(.white)
                        Text(assignedTo ?? "No One Yet")
                            .fontWeight(.bold)
                            .font(.custom("Inter", size: 11))
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Image("three_dot_menu")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 23, height: 25)
                    .foregroundColor(.white)
                    .padding([.leading, .trailing])
                
            }
            .padding(.bottom)
            
            Rectangle()
                .fill(Color("purple_color_4"))
                .frame(height: 1)
            
            HStack(spacing: 6) {
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 13, height: 13)
                    .foregroundColor(Color("text_color_15"))
                
                Text("CHECK OFF TASKS AS YOU COMPLETE THEM!")
                    .fontWeight(.light)
                    .font(.custom("Inter", size: 13))
                    .foregroundColor(.black)
                
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 13, height: 13)
                    .foregroundColor(Color("text_color_15"))
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(Color("purple_color_3"))
            
            ScrollView {
                if showEmptyView {
                    Text("No relationship tasks found!")
                        .font(.custom("Acme", size: 22))
                        .foregroundColor(Color("text_color_13"))
                        .opacity(0.75)
                        .padding(.top, 100)
                    Spacer()
                    
                } else {
                    VStack(spacing: 0) {
                        ForEach(Array($relationshipTaskIntervals.enumerated()), id: \.offset) { index, $interval in
                            RelationshipTaskIntervalView(interval: $interval)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color("communalstart"))
            
            VStack(spacing: 8) {
                Text("\(taskCompleted)% COMPLETE")
                    .fontWeight(.bold)
                    .font(.custom("Inter", size: 26))
                    .foregroundColor(.black)
                    .padding(.top, 8)
                HStack(spacing: 18) {
                    Button(action: {
                        var taskIds = ""
                        for interval in relationshipTaskIntervals {
                            for task in interval.tasks {
                                if task.isChecked == true {
                                    taskIds = taskIds.isEmpty ? "\(task.task_id ?? 0)" : "\(taskIds),\(task.task_id ?? 0)"
                                }
                            }
                        }
                        
                        updateMyRelationshipPlanProgress(planId: planId, taskId: taskIds)
                    }) {
                        Text("SAVE AND CLOSE")
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("communalstart"))
                    }
                    
                    Button(action: {
//                        var modifiedCheckList: [MyRelationshipPlanChecklistItem] = []
//                        for interval in relationshipTaskIntervals {
//                            var tempInterval = interval
//                            var tasks: [MyRelationshipPlanTask] = []
//                            for task in interval.tasks {
//                                var tempTask = task
//                                tempTask.isChecked = tempTask.status == "completed"
//                                tasks.append(tempTask)
//                            }
//                            tempInterval.tasks = tasks
//                            modifiedCheckList.append(tempInterval)
//                        }
//                        self.relationshipTaskIntervals = modifiedCheckList
                        for intervalIndex in relationshipTaskIntervals.indices {
                            for taskIndex in relationshipTaskIntervals[intervalIndex].tasks.indices {
                                relationshipTaskIntervals[intervalIndex].tasks[taskIndex].isChecked = false
                            }
                        }
                    }) {
                        Text("CLEAR")
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("communalstart"))
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.horizontal, 18)
            }
            .padding(.bottom, 10)
        }
        .appLoaderView(isPresented: $isLoaderShown, loaderView: { SwiftUISpinLoaderView() }, backgroundColor: Color("loader_bg_color"))
        .background(Color("purple_color_2"), ignoresSafeAreaEdges: .all)
        .onAppear {
            getMyRelationshipPlanDetails(planId: planId)
        }
        .navigationBarHidden(true)
    }
    
    func getMyRelationshipPlanDetails(planId: Int?) {
        isLoaderShown = true
        
        var params : [String : Any] = [:]
        params["plan_id"] = planId ?? 1
        
        let queryItems = [URLQueryItem(name: "plan_id", value: "\(planId ?? 1)")]
        var urlComps = URLComponents(string: APIPath.myRelationshipPlanDetails)!
        urlComps.queryItems = queryItems
        
        API.shared.sendData(url: urlComps.url?.absoluteString ?? APIPath.myRelationshipPlanDetails, requestType: .post, params: params, objectType: MyRelationshipPlanDetailsResponse.self, isTokenRequired: true) { (data, status)  in
            isLoaderShown = false
            
            if status == false {
                showEmptyView = true
                return
            }
            
            if let planDetails = data?.plan_details {
                if let title = planDetails.title {
                    self.title = title.isEmpty ? "Untitled Plan" : title
                }
                
                if let assignment = planDetails.partner_assignment {
                    self.assignedTo = assignment.isEmpty ? "No One Yet" : assignment
                }
                
                self.taskCompleted = planDetails.completed_task_percentage ?? 0
            }
            
            guard let checklist = data?.checklist, !checklist.isEmpty else {
                showEmptyView = true
                return
            }
            showEmptyView = false
            var modifiedCheckList: [MyRelationshipPlanChecklistItem] = []
            for interval in checklist {
                var tempInterval = interval
                var tasks: [MyRelationshipPlanTask] = []
                for task in interval.tasks {
                    var tempTask = task
                    tempTask.isChecked = tempTask.status == "completed"
                    tasks.append(tempTask)
                }
                tempInterval.tasks = tasks
                modifiedCheckList.append(tempInterval)
            }
            self.relationshipTaskIntervals = modifiedCheckList
        }
    }
    
    func updateMyRelationshipPlanProgress(planId: Int?, taskId: String) {
        isLoaderShown = true
        
        var params : [String : Any] = [:]
        params["plan_id"] = planId ?? 1
        params["task_id"] = taskId
        
        let queryItems = [URLQueryItem(name: "plan_id", value: "\(planId ?? 1)"), URLQueryItem(name: "task_id", value: taskId)]
        var urlComps = URLComponents(string: APIPath.updateMyRelationshipPlanProgress)!
        urlComps.queryItems = queryItems
        
        API.shared.sendData(url: urlComps.url?.absoluteString ?? APIPath.updateMyRelationshipPlanProgress, requestType: .post, params: params, objectType: DefaultApiResponse.self, isTokenRequired: true) { (data, status)  in
            isLoaderShown = false
            self.mode.wrappedValue.dismiss()
        }
    }
}

struct MyRelationshipPlanDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MyRelationshipPlanDetailsView()
    }
}
