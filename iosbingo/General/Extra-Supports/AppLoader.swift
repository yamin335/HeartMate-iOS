//
//  AppLoader.swift
//  Safidence
//
//  Created by Hamza Saeed on 28/10/2021.
//

import UIKit
import SwiftGifOrigin

extension UIView {
    func showBlurLoader() {
        let blurLoader = AppLoader(frame: frame)
        self.addSubview(blurLoader)
    }

    func removeBluerLoader() {
        if let blurLoader = subviews.first(where: { $0 is AppLoader }) {
            blurLoader.removeFromSuperview()
        }
    }
}

class AppLoader: UIView {
    static var shared = AppLoader()
    var gifImage = UIImageView()
    var blurView = UIView()
    var mainView = UIView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        /* Disabling Alternative approach for showing loader on screen
         blurView.frame = frame//CGRect(x: 0, y: 0, width: keyWindow!.frame.width, height: keyWindow!.frame.height)
         gifImage.image = UIImage.gif(name: "animation_Default")
         gifImage.contentMode = .scaleAspectFit
         gifImage.frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 200.0)
         gifImage.center = blurView.center
         blurView.addSubview(gifImage)
         self.addSubview(blurView)
         */
        super.init(frame: frame)

    }

    func show(currentView:UIView) {
        blurView.frame = CGRect(x: 0, y: 0, width: currentView.frame.width, height: currentView.frame.height)
        mainView.frame = CGRect(x: 0, y: 0, width: currentView.frame.width, height: currentView.frame.height)//UIView(frame: window.bounds)
        gifImage.image = UIImage.gif(name: "animation_Default")
        gifImage.contentMode = .scaleAspectFit
        gifImage.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        gifImage.center = blurView.center
        blurView.backgroundColor = .white
        mainView.backgroundColor = .white
        blurView.addSubview(gifImage)
        mainView.addSubview(blurView)
        currentView.addSubview(mainView)

    }

    func hide() {
        UIView.animate(withDuration: 2, delay: 0 , options: .curveEaseOut, animations: {
            print(self.blurView.frame.origin.y)
            let translationY = self.blurView.frame.height
            self.blurView.transform = CGAffineTransform(translationX: 0, y:  translationY * (-1))
            self.mainView.alpha = 0

        }, completion: {_ in
            self.mainView.alpha = 1
            self.blurView.transform = CGAffineTransform.identity
            self.blurView.removeFromSuperview()
            self.gifImage.removeFromSuperview()
            self.mainView.removeFromSuperview()
        })

    }

    func hideWithHandler(completion: @escaping (_ isCompletetd:Bool) -> Void) {
        UIView.animate(withDuration: 2, delay: 0 , options: .curveEaseOut, animations: {
            print(self.blurView.frame.origin.y)
            let translationY = self.blurView.frame.height
            self.blurView.transform = CGAffineTransform(translationX: 0, y:  translationY * (-1))
            self.mainView.alpha = 0

        }, completion: {_ in
            self.blurView.transform = CGAffineTransform.identity
            self.mainView.alpha = 1
            self.blurView.removeFromSuperview()
            self.gifImage.removeFromSuperview()
            self.mainView.removeFromSuperview()
            completion(true)

        })
    }

}
