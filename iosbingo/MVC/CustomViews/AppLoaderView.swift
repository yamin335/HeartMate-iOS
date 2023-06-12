//
//  AppLoaderView.swift
//  iosbingo
//
//  Created by Md. Yamin on 10/24/22.
//

import SwiftUI

struct AppLoaderView<Content, LoaderView>: View where Content: View, LoaderView: View {
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    @ViewBuilder let loaderView: () -> LoaderView
    let backgroundColor: Color
    let animation: Animation?
    
    var body: some View {
        content()
            .animation(nil, value: isPresented)
            .overlay(isPresented ? backgroundColor.ignoresSafeArea() : nil)
            .overlay(isPresented ? loaderView() : nil)
            .animation(animation, value: isPresented)
        
    }
}

extension View {
    func appLoaderView<LoaderView>(isPresented: Binding<Bool>, loaderView: @escaping () -> LoaderView, backgroundColor: Color, animation: Animation? = .default) -> some View where LoaderView: View {
        return AppLoaderView(isPresented: isPresented, content: { self }, loaderView: loaderView, backgroundColor: backgroundColor, animation: animation)
    }
}
