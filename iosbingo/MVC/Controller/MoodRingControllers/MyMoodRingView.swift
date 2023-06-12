//
//  MyMoodRingView.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 10/13/22.
//

import SwiftUI

struct MyMoodRingView: View {
    
    @State var existingMoodRingID: Int
    @State var mooodRing: MoodRing? = nil
    @State private var showingAlert = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    

    @State var moodRing: MoodRing?
    
    @State var emotionalValue: Float = 20.0
    @State var mentalValue: Float = 25.0
    @State var spiritualValue: Float = 15.0
    @State var communalValue: Float = 20.0
    @State var physicalValue: Float = 25.0
    @State var professionalValue: Float = 20.0
    
    @State var emotionalExplanation: String = ""
    @State var mentalExplanation: String = ""
    @State var spiritualExplanation: String = ""
    @State var communalExplanation: String = ""
    @State var physicalExplanation: String = ""
    @State var professionalExplanation: String = ""
    
    @State var includeExplanation: Bool = false
    @State var seeExplanationSeeker: Bool = true
    
    @State private var selectedTag: Int? = -1
    
    @State var showMoodRingExplanationView: Bool = false
    
    @State var isLoaderShown: Bool = false
    
    @State var isEmptyExplanation: Bool = false
    
    var shareView: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                VStack(alignment: .center, spacing: 0) {
                    Image("thumb")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .padding(.top, 20)
                    
                    Text("To Value Me")
                        .font(.custom("Acme", size: 32))
                        .foregroundColor(.white)
                        .padding(.top, 18)
                        .padding(.bottom, 18)
                }
                
                ZStack {
                    CircularProgressBar(progress:  $communalValue,
                                        trackColorStart: Color("communalstart"),
                                        trackColorEnd: Color("communalend"),
                                        progressColor: Color("purple_color_1"))
                    
                    CircularProgressBar(progress: $professionalValue,
                                        trackColorStart: Color("professionalstart"),
                                        trackColorEnd: Color("professionalend"), progressColor: Color("cyan_color_1"))
                    .padding(25)
                    CircularProgressBar(progress: $physicalValue,
                                        trackColorStart: Color("physicalstart"),
                                        trackColorEnd: Color("physicalend"), progressColor: Color("orange_color_2"))
                    .padding(50)
                    CircularProgressBar(progress: $mentalValue,
                                        trackColorStart: Color("mentalstart"),
                                        trackColorEnd: Color("mentalend"), progressColor: Color("gray_color_1"))
                    .padding(75)
                    
                    CircularProgressBar(progress: $emotionalValue,
                                        trackColorStart: Color("emotionalstart"),
                                        trackColorEnd: Color("emotionalend"), progressColor: Color("green_color_4"))
                    .padding(100)
                    
                    CircularProgressBar(progress: $spiritualValue,    trackColorStart: Color("spiritualstart"),
                                        trackColorEnd: Color("spiritualend"),
                                        progressColor: Color("yellow_color_2"))
                    .padding(125)
                    .overlay(Text("My Mood Ring")
                        .foregroundColor(.white)
                        .font(.custom("Acme", size: 12))
                        .padding(.top, 20))
                }
                .padding(.horizontal, 16)
                .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                .padding(.top, 10)
                
                ShareStatusView(moodRing: $moodRing)
                
                MoodControlView(existingMoodRingID: $existingMoodRingID, emotionalValue: $emotionalValue, mentalValue: $mentalValue, spiritualValue: $spiritualValue, communalValue: $communalValue, physicalValue: $physicalValue, professionalValue: $professionalValue)
                    .padding(.horizontal, 8)
                    .padding(.top, 10)
            }
        }
        .background(
                LinearGradient(gradient: Gradient(colors: [Color("moodringbgstart"), Color("moodringbgend")]), startPoint: .top, endPoint: .bottom)
            )

        }
    
    var shareViewDisplayInApp: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    CircularProgressBar(progress:  $communalValue,
                                        trackColorStart: Color("communalstart"),
                                        trackColorEnd: Color("communalend"),
                                        progressColor: Color("purple_color_1"))
                    
                    CircularProgressBar(progress: $professionalValue,
                                        trackColorStart: Color("professionalstart"),
                                        trackColorEnd: Color("professionalend"), progressColor: Color("cyan_color_1"))
                    .padding(25)
                    CircularProgressBar(progress: $physicalValue,
                                        trackColorStart: Color("physicalstart"),
                                        trackColorEnd: Color("physicalend"), progressColor: Color("orange_color_2"))
                    .padding(50)
                    CircularProgressBar(progress: $mentalValue,
                                        trackColorStart: Color("mentalstart"),
                                        trackColorEnd: Color("mentalend"), progressColor: Color("gray_color_1"))
                    .padding(75)
                    
                    CircularProgressBar(progress: $emotionalValue,
                                        trackColorStart: Color("emotionalstart"),
                                        trackColorEnd: Color("emotionalend"), progressColor: Color("green_color_4"))
                    .padding(100)
                    
                    CircularProgressBar(progress: $spiritualValue,    trackColorStart: Color("spiritualstart"),
                                        trackColorEnd: Color("spiritualend"),
                                        progressColor: Color("yellow_color_2"))
                    .padding(125)
                    .overlay(Text("My Mood Ring")
                        .foregroundColor(.white)
                        .font(.custom("Acme", size: 12))
                        .padding(.top, 10))
                }
                .padding(.horizontal, 16)
                .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                .padding(.top, 5)
            }
        }

    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(spacing: 0) {
                    NavigationLink(destination: MoodRingHistoryView(), tag: 1, selection: self.$selectedTag) {
                        EmptyView()
                    }.isDetailLink(false)
                    
                  
                    HStack {
                        
                        
                        Button(action: {
                            
                            self.mode.wrappedValue.dismiss()
                            
                        }) {
                            Image("backarrow")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 18, height: 25)
                                .foregroundColor(.white)
                                .padding()
                            //.padding(.bottom, 8)
                        }
                        Spacer()
                        if existingMoodRingID == 0 {
                     
                        
                        Text("Today I’m feeling...")
                            .font(.system(size: 16))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                        //UIFont(name: "Inter-Bold", size: 16)
                        Spacer()
                      
                        } else {
                            Text(moodRing?.date_heading ?? "")
                                .font(.system(size: 16))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .foregroundColor(.white)
                            Spacer()
                            
                        }
                        
                        Button(action: {
                            isLoaderShown = true
                            withAnimation {
                                let image = shareView.takeScreenshot(origin: geometry.frame(in: .global).origin, size: geometry.size)
                                self.shareClick(image: image)
                            }
                        }) {
                            Image("cloud_upload")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 22)
                                .foregroundColor(.white)
                                .padding(.trailing, 5)
                            // .padding(.bottom, 8)
                        }
                        
                        }  .padding(.top, 5)
                    
                    if existingMoodRingID != 0 {
                        Text(moodRing?.summary ??  "")
                            .font(.custom("Inter-Light", size: 16))
                            .foregroundColor(.init(white: 0.7))
                            .padding(.bottom, 5)
                            .padding(.top, 5)
                    }
                    
                    ScrollView {
                        ScrollViewReader { value in
                            VStack(spacing: 0) {
                                if existingMoodRingID == 0 {
                                    Text("Capture and share your daily mood and pay attention to how your partner shows up for you")
                                        .font(.system(size: 11))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 20)
                                        .padding(.top, 10)
                                        .foregroundColor(Color.white.opacity(0.7))
                                        .id(0)
                                }
                                shareViewDisplayInApp.frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                                
                               
                                    HStack(alignment: .center) {
                                     
                                        if existingMoodRingID == 0 {
                                            Text("Daily Mood Tracking")
                                                .foregroundColor(.white)
                                                .font(.system(size: 20, weight: .bold))
                                            
                                            Spacer()
                                            Text("View History")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15, weight: .light))
                                                .onTapGesture {
                                                    selectedTag = 1
                                                }
                                        } else {
                                            Text("Mood Tracking for " + (moodRing?.date ?? "") )
                                                .foregroundColor(.white)
                                                .font(.system(size: 15, weight: .bold))
                                            Spacer()
                                        }
                                    }
                                    .padding(.top, 20)
                                    .padding(.bottom, 5)
                                    .padding(.horizontal, 20)
                                
                                MoodControlView(existingMoodRingID: $existingMoodRingID, emotionalValue: $emotionalValue, mentalValue: $mentalValue, spiritualValue: $spiritualValue, communalValue: $communalValue, physicalValue: $physicalValue, professionalValue: $professionalValue)
                                    .padding(.horizontal, 8)
                                    .padding(.top, 5)
                                
                                if existingMoodRingID == 0 {
                                    //shareViewDisplay
                                    HStack(alignment: .center) {
                                        VStack {
                                            HStack(alignment: .top) {
                                                Image(systemName: includeExplanation ? "checkmark.circle.fill" : "circle.fill")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .foregroundColor(includeExplanation ? Color("green_color_1") : Color("gray_color_2"))
                                                    .frame(width: 14, height: 14)
                                                    .onTapGesture {
                                                        withAnimation {
                                                            includeExplanation = true
                                                            seeExplanationSeeker = false
                                                            showMoodRingExplanationView = true
                                                        }
                                                    }
                                                
                                                Text("I would like to include an explanation")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.white)
                                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            }
                                            
                                            HStack(alignment: .top) {
                                                Image(systemName: seeExplanationSeeker ? "checkmark.circle.fill" : "circle.fill")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .foregroundColor(seeExplanationSeeker ? Color("green_color_1") : Color("gray_color_2"))
                                                    .frame(width: 14, height: 14)
                                                    .onTapGesture {
                                                        withAnimation {
                                                            includeExplanation = false
                                                            seeExplanationSeeker = true
                                                        }
                                                    }
                                                
                                                Text("I would like to see who asks me for the explanation")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.white)
                                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            }
                                        }
                                        
                                        Button(action: {
//                                            let image = shareView.takeScreenshot(origin: geometry.frame(in: .global).origin, size: geometry.size)
                                            self.saveRingMood()
                                     
                                        }) {
                                            Text("SHARE")
                                                .font(.system(size: 14))
                                                .foregroundColor(.black)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 6)
                                                .background(Color("yellow_color_1"))
                                                .cornerRadius(6)
                                        }
                                    }
                                    .padding(.top, 20)
                                    .padding(.horizontal, 8)
                                    .padding(.bottom, 10)
                                }
                                
                                if existingMoodRingID != 0 {
                                    MoodRingExplanationView(isPresented: $showMoodRingExplanationView, existingMoodRingID: existingMoodRingID, emotionalValue: emotionalValue, mentalValue: mentalValue, spiritualValue: spiritualValue, communalValue: communalValue, physicalValue: physicalValue, professionalValue: professionalValue, emotionalExplanation: $emotionalExplanation, mentalExplanation: $mentalExplanation, spiritualExplanation: $spiritualExplanation, communalExplanation: $communalExplanation, physicalExplanation: $physicalExplanation, professionalExplanation: $professionalExplanation, isEmptyExplanation: $isEmptyExplanation)
                                    
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            withAnimation {
                                                value.scrollTo(0, anchor: .top)
                                            }
                                        }) {
                                            HStack {
                                                Image(systemName: "arrow.up")
                                                    .foregroundColor(.black)
                                                Text("Back To Top")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.black)
                                            }.padding(.horizontal, 16)
                                                .padding(.vertical, 6)
                                                .background(Color("yellow_color_1"))
                                                .cornerRadius(6)
                                        }
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.top, 20)
                                    .padding(.bottom, 120)
                                }
                                
                               

                            }
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }//.padding()
                    //.background(Color("green_color_3"))
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color("moodringbgstart"), Color("moodringbgend")]), startPoint: .leading, endPoint: .trailing)
                        )
                
            }
            .navigationBarHidden(true)

            .ignoresSafeArea(.all, edges: .bottom)
            .padding(.top,0)
            //  .fullBackground(color: Color("green_color_3"))
            .enableLightStatusBar()
            .customPopupView(isPresented: $showMoodRingExplanationView, popupView: { MoodRingExplanationView(isPresented: $showMoodRingExplanationView, existingMoodRingID: existingMoodRingID, emotionalValue: emotionalValue, mentalValue: mentalValue, spiritualValue: spiritualValue, communalValue: communalValue, physicalValue: physicalValue, professionalValue: professionalValue, emotionalExplanation: $emotionalExplanation, mentalExplanation: $mentalExplanation, spiritualExplanation: $spiritualExplanation, communalExplanation: $communalExplanation, physicalExplanation: $physicalExplanation, professionalExplanation: $professionalExplanation, isEmptyExplanation: $isEmptyExplanation) })

            .onAppear() {
   
                
                self.emotionalValue = 30.0
                self.mentalValue = 40.0
                self.spiritualValue = 100.0
                self.communalValue = 70.0
                self.physicalValue = 50.0
                self.professionalValue = 60.0
                
                   
                self.emotionalExplanation = ""
                self.mentalExplanation = ""
                self.spiritualExplanation = ""
                self.communalExplanation = ""
                self.physicalExplanation = ""
                self.professionalExplanation = ""
                
                if existingMoodRingID != 0 {
                    self.emotionalValue = 0
                    self.mentalValue = 0
                    self.spiritualValue = 0
                    self.communalValue = 0
                    self.physicalValue = 0
                    self.professionalValue = 0
                    
                  
                    self.loadMoodRing(mooodRingID: existingMoodRingID)
                    
                }
            }.padding(.top,0)
                .alert(isPresented: self.$showingAlert) {
                        Alert(title: Text("Success"), message:Text("Successfully Shared"), dismissButton: .default(Text("Ok")))
                }
        }
        .appLoaderView(isPresented: $isLoaderShown, loaderView: { SwiftUISpinLoaderView() }, backgroundColor: Color("loader_bg_color"))
    }
    
    func saveRingMood(){
        
        isLoaderShown = true

        let cookie = AppUserDefault.shared.getValue(for: .Cookie)
        
        var params = [:] as [String:Any]
        
        
        params["emotionally"] = emotionalValue
        params["mentally"] = mentalValue
        params["physically"] = physicalValue
        params["communally"] = communalValue
        params["professionally"] = professionalValue
        params["spiritually"] = spiritualValue
        
        if includeExplanation {
            if  AppUserDefault.shared.getValueBool(for: "emotionalAdded") {
                params["emotionally_explanation"] = emotionalExplanation
            }
            
            if   AppUserDefault.shared.getValueBool(for: "mentalAdded") {
                params["mentally_explanation"] = mentalExplanation
            }
            
            if   AppUserDefault.shared.getValueBool(for: "spiritualAdded") {
                params["spiritually_explanation"] = spiritualExplanation
            }
            
            if AppUserDefault.shared.getValueBool(for: "communalAdded")  {
                params["communally_explanation"] = communalExplanation
            }
            
            if AppUserDefault.shared.getValueBool(for: "physicalAdded")  {
                params["physically_explanation"] = physicalExplanation
            }
            
            if AppUserDefault.shared.getValueBool(for: "professionalAdded")   {
                params["professionally_explanation"] = professionalExplanation
            }
        }
        
        API.shared.sendData(url: APIPath.saveDailyMoodRing, requestType: .post, params: params, objectType: MoodRingSaveItem.self) { (data,status)  in
            
            isLoaderShown = false

            
            if status {
                showingAlert = true
                //isPresented = false
                guard let moodRingSaveItem = data else {return}
                
                self.loadMoodRing(mooodRingID: moodRingSaveItem.id)
              
            } else {
                print("Error found")
               // completion(false)
            }
        }
    }
    
    func shareClick(image: UIImage) {
        
        withAnimation {
            //let image = shareView.snapshot()
        
            
            let share = [image]
            let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
            
            //activityViewController.popoverPresentationController?.sourceView = self.view
            
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            
            
            
            windowScene?.keyWindow?.rootViewController?.present(activityViewController, animated: true) {
                isLoaderShown = false
            }
        }
    }
    
    func loadMoodRing(mooodRingID: Int) {
        //AppLoader.shared.show(currentView: self.view)
        isLoaderShown = true
        
        let cookie = AppUserDefault.shared.getValue(for: .Cookie)
        let params = ["mood_ring_id": existingMoodRingID] as [String:Any]
        
        API.shared.sendData(url: APIPath.getMoodRing, requestType: .post, params: params, objectType: MoodRingData.self) { (data,status)  in
            isLoaderShown = false
            guard let mooodRingData = data?.moodRing else {return}
            self.moodRing = data?.moodRing
            self.emotionalValue = Float(mooodRingData.emotional)
            self.mentalValue = Float(mooodRingData.mental)
            self.spiritualValue = Float(mooodRingData.spiritual)
            self.communalValue = Float(mooodRingData.communal)
            self.physicalValue = Float(mooodRingData.physical)
            self.professionalValue = Float(mooodRingData.professional)
            
            self.emotionalExplanation = mooodRingData.emotional_explanation
            self.mentalExplanation = mooodRingData.mental_explanation
            self.spiritualExplanation = mooodRingData.spiritual_explanation
            self.communalExplanation = mooodRingData.communal_explanation
            self.physicalExplanation = mooodRingData.physical_explanation
            self.professionalExplanation = mooodRingData.professional_explanation
            
            if emotionalExplanation.isEmpty && emotionalExplanation.isEmpty && emotionalExplanation.isEmpty && emotionalExplanation.isEmpty && emotionalExplanation.isEmpty && emotionalExplanation.isEmpty {
                isEmptyExplanation = true
            } else {
                isEmptyExplanation = false
            }

            
        }
    }
}

struct MyMoodRingView_Previews: PreviewProvider {
    static var previews: some View {
        MyMoodRingView(existingMoodRingID: 0)
    }
}


extension View {
    func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        let hosting = UIHostingController(rootView: self)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
    }
}
extension UIView {
    var renderedImage: UIImage {
        // rect of capure
        let rect = self.bounds
        // create the context of bitmap
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        // get a image from current context bitmap
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
}



struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}




struct LightStatusBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                UIApplication.shared.statusBarStyle = .lightContent
            }
            .onDisappear {
                UIApplication.shared.statusBarStyle = .default
            }
    }
}

extension View {
    func enableLightStatusBar() -> some View {
        self.modifier(LightStatusBarModifier())
    }
}

struct ShareStatusView: View {
    @Binding var moodRing: MoodRing?

    
    var body: some View {
        
        VStack(spacing: 0) {
            if let moodRing = moodRing {
                
                Text("First Name is in a " + (moodRing.first_name ) )
                    .font(.custom("Inter-Light", size: 11))
                    .foregroundColor(.init(white: 0.7))
                    .padding(.top,20)
                
                
                Text(moodRing.summary )
                    .font(.custom("Inter-Light", size: 16))
                    .foregroundColor(.init(white: 0.7))
                    
                
            } else {
                Text("")
            }
        }
    }
}
