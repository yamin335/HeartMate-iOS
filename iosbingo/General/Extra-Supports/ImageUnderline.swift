//
//  ImageUnderline.swift
//  iosbingo
//
//  Created by Hamza Saeed on 01/09/2022.
//

import UIKit
extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        let xPosition = size.width/2
        let underLineBottomPosition = UIDevice.current.hasNotch ? 30.0 : 7.0
        UIRectFill(CGRect(x: xPosition/2, y: size.height - lineWidth - underLineBottomPosition, width: size.width / 2, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
