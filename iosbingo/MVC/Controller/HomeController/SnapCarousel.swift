//
//  ContentView.swift
//  SnapCarousel
//
//  Created by ericg on 5/17/20.
//  Copyright © 2020 ericg. All rights reserved.
//

import SwiftUI

struct SnapCarousel: View
{
    //    @EnvironmentObject var UIState: UIStateModel

    var UIState: UIStateModel

    @State var journeys: [Journey] = []

    @State var selectedJourneys: Journey?

    @State var exitReasons: [ExistReason] = []
    @State private var showStacked = false
    @State var showExitDialog = false
    @State private var showingAlert = false
    @State private var showingAlertMessage: String = ""
    @State private var showTutorial: Bool = false
    @State private var tutorial: DatingJourneyTutorial = DatingJourneyTutorial()

    var present: ((_ selectedJourneys : Journey?)->Void)?

    var exitDialog: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "multiply.circle")
                        .resizable()
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding(20)
                        .onTapGesture {
                            withAnimation {
                                self.showExitDialog = false
                            }
                        }
                }
                Spacer()
            }

            VStack(spacing: 0) {
                Text("Share your reason for exiting this dating journey")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color("text_color_1"))
                    .padding(8)

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(exitReasons, id:\.id) { reason in

                            HStack {
                                Spacer()
                                Text(reason.reason_text)
                                    .font(.system(size: 14, weight: .light))
                                    .foregroundColor(.black)
                                    .padding(8)
                                Spacer()
                            }
                            .background(RoundedRectangle(cornerRadius: 20, style: .circular).fill(Color("gray_color_2")))
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                self.callExitApiWith(reason: reason)
                                withAnimation {
                                    self.showExitDialog = false
                                }
                            }

                        }
                    }.padding(.vertical, 10)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 6).style (
                    withStroke: Color("green_color_1"),
                    lineWidth: 2,
                    fill: Color.white
                ))
                .padding([.leading, .trailing, .bottom], 15)

            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 280)
            .background(RoundedRectangle(cornerRadius: 0, style: .circular).fill(Color("gray_color_1")))
            .padding(.leading, 25)
            .padding(.trailing, 25)
        }
        .edgesIgnoringSafeArea(.all)
    }

    var body: some View {
        let spacing:            CGFloat = 16
        let widthOfHiddenCards: CGFloat = 32

        // UIScreen.main.bounds.width - 10
        // let cardHeight:         CGFloat = 279

        let items = [
            Card( id: 0, name: "Hey" ),
            Card( id: 1, name: "Ho" ),
            Card( id: 2, name: "Lets" ),
            Card( id: 3, name: "Go" )
        ]

        GeometryReader { geometry in
            Canvas {
                if !showTutorial {
                    VStack {
                        Text("My Active Dating Journeys")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color.white)
                            .padding(.bottom,10)
                            .padding(.top,10)

                        // find a way to avoid passing same arguments to Carousel and Item
                        Carousel( numberOfItems: CGFloat( journeys.count ), spacing: spacing,
                                  widthOfHiddenCards: geometry.size.width * 0.05 ) {

                            ForEach( journeys , id: \.id) { item in

                                Item( _id:                 item.id ?? 0,
                                      spacing:              spacing,
                                      widthOfHiddenCards:   geometry.size.width * 0.05,
                                      cardHeight:           geometry.size.height * 0.85 )
                                {



                                    VStack(spacing:0) {
                                        ZStack(alignment: .bottomTrailing) {

                                           // AsyncImage(url: URL(string: item.avater ?? ""))
                                            Spacer()
                                            AsyncImage(url: URL(string: (item.avatar ?? ""))) { image in
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    //.padding(.top,0)
                                                    .padding(.bottom,0)
                                                    .cornerRadius( radius: 8 , corners: [.topRight, .topLeft])
                                            } placeholder: {
                                                Color.gray
                                            }
       //                                        .frame(width: 128, height: 128)
       //                                        .clipShape(RoundedRectangle(cornerRadius: 25))
       //
       //                                    Image("homethumb")
       //                                                    .resizable()
       //                                                    .aspectRatio(contentMode: .fit)
       //                                                    .padding(.top,0)
       //                                                    .padding(.bottom,0)

                                            //VStack {

                                                HStack(alignment: .bottom) {
                                                Text(item.first_name ?? "")
                                                        .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                                        .font(.custom("Inter-Bold", size: 24))
                                                        //.frame(alignment: .leading)
                                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                                            //.background(Color.green)
                                                                            .padding()
                                                Spacer()
                                                Text("\(item.value_me_score ?? 0)" + " To Value Me" )
                                                        .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                                        .font(.custom("Inter-SemiBold", size: 12))
                                                        //.frame(alignment: .trailing)
                                                        .frame(width: 120, alignment: .leading)
                                                        .lineLimit(1).padding()
                                                                            //.background(Color.blue)

                                            }.padding()
                                                .frame(width: geometry.size.width * 0.85)
                                                //.offset(x: -5, y: -5)
                                            //}
                                        }
                                      // Spacer()
                                        VStack() {
                                        HStack(spacing: 0) {
                                            VStack(alignment: .center) {
                                            Text("Our Status")
                                                    .foregroundColor(Color(red: 0.102, green: 0.098, blue: 0.69))
                                                    .font(.custom("Acme-Regular", size: 13))
                                            }

                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading,10)
                                            VStack {
                                                Text(item.ourStatus?.level ?? "")
                                                    .foregroundColor(Color(red: 0.102, green: 0.098, blue: 0.69))
                                                    .font(.custom("Inter-Regular", size: 12))
                                                Text(item.ourStatus?.title ?? "")
                                                    .foregroundColor(Color(red: 0.102, green: 0.098, blue: 0.69))
                                                    .font(.custom("Inter-Light", size: 10))
                                            } .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.leading,10)

                                        }.padding(.top,10)



                                        HStack {
                                            ZStack{

                                                RoundedRectangle(cornerRadius: 9)
                                                       .fill(Color("dark_gray_bg"))
                                                       .frame( height: 120)

                                                VStack {
                                                    HStack(alignment: .center) {
                                                        Text("Discoveries").padding(.top,5)
                                                    }
                                                    ZStack{
                                                        HStack(alignment: .center,spacing: 20) {

                                                        VStack {
                                                            Button() {

                                                            }label: {
                                                                Text(item.discovery?.user?.value == nil ?  "" : "\(item.discovery?.user?.value ?? 0)")
                                                                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                                                    .font(.custom("Inter-Bold", size: 24))
                                                                    .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4))
                                                            }
                                                            .frame(width:120)
                                                                .background(Color("homeleftbutton"))
                                                                .cornerRadius(9)


                                                            Text(item.discovery?.user?.level ?? "").padding(.bottom,5)
                                                        }

                                                        VStack {
                                                            Button() {

                                                            }label: {
                                                                Text(item.discovery?.partner?.value == nil ?  "" : "\(item.discovery?.partner?.value ?? 0)")
                                                                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                                                    .font(.custom("Inter-Bold", size: 24))
                                                                    .padding(EdgeInsets(top: 8, leading: 4, bottom:8, trailing: 4))
                                                            }
                                                            .frame(width:120)
                                                                .background(Color("homerightbutton"))
                                                                .cornerRadius(9)

                                                            Text(item.discovery?.partner?.level ?? "").padding(.bottom,5)

                                                        }
                                                    }
                                                    }

                                                }.foregroundColor(.white)

                                                HStack {
                                            Image("firelove")
                                                .resizable()
                                                   .aspectRatio(contentMode: .fit)
                                                   .frame(width: 28, height: 28, alignment: .center)
                                                }


                                            }

                                        }

                                            HStack(alignment: .center, spacing: 50) {
                                            Button {
                                                selectedJourneys = item

                                                //showStacked = true
                                                print("Edit button was tapped")
                                                withAnimation {
                                                    self.showExitDialog = true
                                                }
                                            } label: {
                                                Image("hcross")
                                            }

                                            Button {
                                                self.UIState.onInvitationAction(item)
                                                print("Edit button was tapped")
                                            } label: {
                                                Image("bookmark")
                                            }

                                            Button {
                                                self.UIState.onHeartAction(item)
                                                print("Edit button was tapped")
                                            } label: {
                                                Image(item.ourStatus?.level?.lowercased() ?? "level 1" == "level 1" ? "love" : "loveFill")
                                            }
                                        }
                                        }.padding(.top,0)
                                        .background( Color.white)
                                        //.fixedSize(horizontal: false, vertical: true)
                                           // .frame(maxHeight: 50)



                                    }
                                }
                                //.foregroundColor( Color.red )
                                .onTapGesture {
                                    self.UIState.onDatingJournal(item)
                                }
                                .cornerRadius( 8 )
                                .shadow( color: Color.gray.opacity(0.7), radius: 4, x: 0, y: 4 )
                                .transition( AnyTransition.slide )
                                .animation( .spring() )
                            }
                        }
                        .environmentObject( self.UIState )
                    }
                }
             }
        }
        .onAppear() {
            getExitReasonData()
        }.alert(showingAlertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        .customPopupView(isPresented: $showExitDialog, popupView: { exitDialog })
        .tutorialPopupView(isPresented: $showTutorial, popupView: { DatingJourneyTutorialView(tutorial: self.tutorial, buttonActionDelegate: nil) })
    }

    func callExitApiWith(reason: ExistReason) {
        print(reason.reason_text)
        exitDatingJourney(reason: reason)
    }


    func getDatingJourneyData(){
        //AppLoader.shared.show(currentView: self.view)
        API.shared.getDatingjourney(url: APIPath.datingJourneys, requestType: .get, params: nil) { (journeyData, tutorialData,status)  in
            DispatchQueue.main.async {
                if status {
                    if let datingJourneys = journeyData {
                        withAnimation {
                            showTutorial = false
                        }
                        self.journeys = datingJourneys
                    } else if let tutorial = tutorialData {
                        self.tutorial = tutorial
                        withAnimation {
                            showTutorial = true
                        }
                    }
                } else if let tutorial = tutorialData {
                    self.tutorial = tutorial
                    withAnimation {
                        showTutorial = true
                    }
                } else {
                    withAnimation {
                        showTutorial = true
                    }
                }
            }
        }
    }

    func getExitReasonData() {
        //AppLoader.shared.show(currentView: self.view)
        API.shared.getExitReasonData(url: APIPath.exitReason, requestType: .get, params: nil) { (data, status)  in
            getDatingJourneyData()
            DispatchQueue.main.async {
                guard let exitReasons = data, status else {return}
                self.exitReasons = exitReasons
            }
        }
    }

    func exitDatingJourney(reason: ExistReason) {
        //AppLoader.shared.show(currentView: self.view)
        if let partnerUserID = self.selectedJourneys?.dating_partner_id {
            let params = ["reason_id":reason.id, "partner_user_id" : partnerUserID] as [String:Any]
            API.shared.sendData(url: APIPath.exitDating, requestType: .get, params: params, objectType: ExitDatingStatus.self) { (data,status)  in

                guard let datingJourneyStatus = data else {return}
                self.getDatingJourneyData()

                self.showingAlert = true
                self.showingAlertMessage = datingJourneyStatus.datingJourneyStatus

                // guard let exitReasons = data, status else {return}
                //self.exitReasons = exitReasons
            }
        }
    }

}

struct CustomPopupView<Content, PopupView>: View where Content: View, PopupView: View {

    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    @ViewBuilder let popupView: () -> PopupView
    let backgroundColor: Color
    let animation: Animation?

    var body: some View {

        content()
            .animation(nil, value: isPresented)
            .overlay(isPresented ? backgroundColor.onTapGesture {
                withAnimation {
                    self.isPresented = false
                }
            }.ignoresSafeArea() : nil)
            .overlay(isPresented ? popupView() : nil)
            .animation(animation, value: isPresented)

    }
}

extension View {
    func customPopupView<PopupView>(isPresented: Binding<Bool>, popupView: @escaping () -> PopupView, backgroundColor: Color = .black.opacity(0.7), animation: Animation? = .default) -> some View where PopupView: View {
        return CustomPopupView(isPresented: isPresented, content: { self }, popupView: popupView, backgroundColor: backgroundColor, animation: animation)
    }
}

struct TutorialPopupView<Content, PopupView>: View where Content: View, PopupView: View {
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    @ViewBuilder let popupView: () -> PopupView
    let backgroundColor: Color
    let animation: Animation?

    var body: some View {

        content()
            .animation(nil, value: isPresented)
            .overlay(isPresented ? backgroundColor.ignoresSafeArea() : nil)
            .overlay(isPresented ? popupView() : nil)
            .animation(animation, value: isPresented)

    }
}

extension View {
    func tutorialPopupView<PopupView>(isPresented: Binding<Bool>, popupView: @escaping () -> PopupView, backgroundColor: Color = .black.opacity(0.7), animation: Animation? = .default) -> some View where PopupView: View {
        return TutorialPopupView(isPresented: isPresented, content: { self }, popupView: popupView, backgroundColor: backgroundColor, animation: animation)
    }
}

struct ExitDatingView: View {

    @State private var showingAlert = false

    @State private var item = "" // track last clicked item

    var testData = ["One","Two","Three"]

    var body: some View {

        List{
            ForEach(testData, id: \.self) { item in

                Button(action: {
                    self.item = item
                    self.showingAlert = true

                }) {
                    Text("\(item)")

                }

            }

        }.alert(isPresented: self.$showingAlert) {
            Alert(title: Text("Text"), message:Text(item), dismissButton: .default(Text("Ok")))
        }

    }

}

struct FooterView: View {

    var image: String
    var title: String
    var type: String
    var price: Double

    var body: some View {
        HStack(alignment: .center) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .padding(.all, 20)

            VStack(alignment: .leading) {
                Text("title")
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
                Text("type")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.gray)
                HStack {
                    Text("$" + String.init(format: "%0.2f", 234))
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
            }.padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        //.modifier(CardModifier())
        .padding(.all, 10)
    }
}

struct Card: Decodable, Hashable, Identifiable
{
    var id:     Int
    var name:   String = ""
}



public class UIStateModel: ObservableObject
{
    @Published var activeCard: Int      = 0
    @Published var screenDrag: Float    = 0.0
    var onHeartAction: ((_ journey:Journey)->Void)!
    var onDatingJournal: ((_ journey:Journey)->Void)!
    var onInvitationAction: ((_ journey:Journey)->Void)!

}



struct Carousel<Items : View> : View {
    let items: Items
    let numberOfItems: CGFloat //= 8
    let spacing: CGFloat //= 16
    let widthOfHiddenCards: CGFloat //= 32
    let totalSpacing: CGFloat
    let cardWidth: CGFloat

    @GestureState var isDetectingLongPress = false

    @EnvironmentObject var UIState: UIStateModel

    @inlinable public init(
numberOfItems: CGFloat,
spacing: CGFloat,
widthOfHiddenCards: CGFloat,
    @ViewBuilder _ items: () -> Items) {

        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        self.totalSpacing = (numberOfItems - 1) * spacing
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279

    }

    var body: some View {

        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing

        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard) + 1)

        var calcOffset = Float(activeOffset)

        if (calcOffset != Float(nextOffset)) {
            calcOffset = Float(activeOffset) + UIState.screenDrag
        }

        return HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: CGFloat(calcOffset), y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            self.UIState.screenDrag = Float(currentState.translation.width)

        }.onEnded { value in
            self.UIState.screenDrag = 0

            if (value.translation.width < -50) {

                if Int(numberOfItems) == self.UIState.activeCard + 1 {
                    return
                }

                self.UIState.activeCard = self.UIState.activeCard + 1



                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }

            if (value.translation.width > 50) {
                if  self.UIState.activeCard == 0 {
                    return
                }
                self.UIState.activeCard = self.UIState.activeCard - 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
        })
    }
}

struct Canvas<Content : View> : View {
    let content: Content
    @EnvironmentObject var UIState: UIStateModel

    @inlinable init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .fullBackground(imageName: "home_bg")
    }
}

public extension View {
    func fullBackground(imageName: String) -> some View {
        return background(
            Image(imageName)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }

    func fullBackground(color: Color) -> some View {
       return background(
                color.edgesIgnoringSafeArea(.all)
       )
    }
}

struct Item<Content: View>: View {
    @EnvironmentObject var UIState: UIStateModel
    let cardWidth: CGFloat
    let cardHeight: CGFloat

    var _id: Int
    var content: Content

    @inlinable public init(
_id: Int,
spacing: CGFloat,
widthOfHiddenCards: CGFloat,
cardHeight: CGFloat,
    @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
        self.cardHeight = cardHeight
        self._id = _id
    }

    var body: some View {
        content
            .frame(width: cardWidth, height: _id == UIState.activeCard ? cardHeight : cardHeight - 60, alignment: .center)
    }
}

//struct ContentView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        ContentView()
//    }
//}


struct CornerRadiusShape: Shape {
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

