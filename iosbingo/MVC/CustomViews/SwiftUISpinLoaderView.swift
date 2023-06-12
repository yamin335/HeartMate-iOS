//
//  SwiftUISpinLoader.swift
//  iosbingo
//
//  Created by Md. Yamin on 10/24/22.
//

import SwiftUI

struct SwiftUISpinLoaderView: View {
    var body: some View {
        VStack {
            GIFView(fileName: "animation_Default")
                .frame(width: 100, height: 100)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color("loader_bg_color"))
        .ignoresSafeArea()
    }
}

struct SwiftUISpinLoader_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISpinLoaderView()
    }
}
