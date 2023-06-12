//
//  CircularProgressView.swift
//  iosbingo
//
//  Created by Hamza Saeed on 23/07/2022.
//

import UIKit

@IBDesignable class ActivityIndicatorCircle: UIView {
    var  timerInterval: Double = 0.05
    var timer : Timer?
    var endAngle: CGFloat   = 0.0
    var angleStep           = CGFloat.pi / 20.0
    var angleOffset         = -CGFloat.pi / 2.0
    var stopValue = 0.0
    var shapeLayer = CAShapeLayer()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func startAnimating() {
        superview?.bringSubviewToFront(self)

        layer.cornerRadius = frame.width / 2
        self.clipsToBounds = true

        isHidden = false
        timer?.invalidate()
        timer = nil

        timer = Timer.scheduledTimer(timeInterval: timerInterval,
                                 target: self,
                                 selector: #selector(self.updateCircle),
                                 userInfo: nil,
                                 repeats: true)
    }

    func stopAnimating() {
        isHidden = true
        timer?.invalidate()
        timer = nil
    }

    @objc func updateCircle() {
        if endAngle >= stopValue {
            timer?.invalidate()
            timer = nil
        }else{
            endAngle += angleStep
            print("end angle value",endAngle)


            DispatchQueue.main.async {
                self.shapeLayer.removeFromSuperlayer() // remove the previous version

                let lineWidth: CGFloat = 6.0
                let radius = self.frame.size.width / 2.0 // if the view is square, this gives us center as well

                let circlePath = UIBezierPath(arcCenter: CGPoint(x: radius,y: radius), radius: radius - lineWidth, startAngle: self.angleOffset, endAngle: self.endAngle + self.angleOffset, clockwise: true)

                self.shapeLayer.path = circlePath.cgPath
                self.shapeLayer.position = CGPoint(x: 0, y: 0)
                self.shapeLayer.fillColor = UIColor.clear.cgColor
                self.shapeLayer.strokeColor = UIColor(red: 129/255, green: 205/255, blue: 217/255, alpha: 1).cgColor
                self.shapeLayer.lineWidth = lineWidth
                let one : NSNumber = 1
                let two : NSNumber = 10
                self.shapeLayer.lineDashPattern = [one,two]
                self.shapeLayer.lineCap = CAShapeLayerLineCap.round
                self.layer.addSublayer(self.shapeLayer)
            }
        }
    }

    func fillCircleWithoutAnimate() {
        superview?.bringSubviewToFront(self)
        layer.cornerRadius = frame.width / 2
        self.clipsToBounds = true
        isHidden = false
        endAngle = 6.2
        //Total value is 6.2 to fill the whole circle

        DispatchQueue.main.async {
            self.shapeLayer.removeFromSuperlayer() // remove the previous version

            let lineWidth: CGFloat = 6.0
            let radius = self.frame.size.width / 2.0 // if the view is square, this gives us center as well

            let circlePath = UIBezierPath(arcCenter: CGPoint(x: radius,y: radius), radius: radius - lineWidth, startAngle: self.angleOffset, endAngle: self.endAngle + self.angleOffset, clockwise: true)

            self.shapeLayer.path = circlePath.cgPath
            self.shapeLayer.position = CGPoint(x: 0, y: 0)
            self.shapeLayer.fillColor = UIColor.clear.cgColor
            self.shapeLayer.strokeColor = UIColor(red: 129/255, green: 205/255, blue: 217/255, alpha: 1).cgColor
            self.shapeLayer.lineWidth = lineWidth
            let one : NSNumber = 1
            let two : NSNumber = 10
            self.shapeLayer.lineDashPattern = [one,two]
            self.shapeLayer.lineCap = CAShapeLayerLineCap.round
            self.layer.addSublayer(self.shapeLayer)
        }
    }
}
