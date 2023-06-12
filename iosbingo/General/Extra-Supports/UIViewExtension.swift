//
//  UIViewExtension.swift
//  iosbingo
//
//  Created by Mac mac on 08/12/22.
//

import Foundation
import UIKit

extension UIView{
    func dropShadow(scale: Bool = true) {
        
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity = 0.2;
        layer.shadowRadius = 1.0;
        layer.masksToBounds = false;
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
    }
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func BottomBorderWithColor(color: UIColor, width: CGFloat,isHidden:Bool = false) {
        
//        let border = CALayer()
//        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        let thickness: CGFloat = 3.0
        let topBorder = CALayer()
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = color.cgColor
        bottomBorder.frame = CGRect(x:0, y: self.frame.size.height - thickness, width: self.frame.size.width, height:thickness)
        if isHidden {
            bottomBorder.removeFromSuperlayer()
        }else{
            self.layer.addSublayer(bottomBorder)
        }
        
        
        
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }

}

