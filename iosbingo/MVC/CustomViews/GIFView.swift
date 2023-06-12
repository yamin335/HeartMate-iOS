//
//  GIFView.swift
//  iosbingo
//
//  Created by Md. Yamin on 10/24/22.
//

import Foundation
import SwiftUI

struct GIFView: UIViewRepresentable {
    
    var fileName: String
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let gifImageView = UIImageView()
        gifImageView.image = UIImage.gif(name: fileName)
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(gifImageView)
        
        NSLayoutConstraint.activate([
            gifImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            gifImageView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
