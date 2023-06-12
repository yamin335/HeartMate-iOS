//
//  CurvedShapes.swift
//  iosbingo
//
//  Created by Hamza Saeed on 11/12/2022.
//

import UIKit

@IBDesignable class CurvedShapes: UIView {

    var path: UIBezierPath!
    var viewColor : UIColor = .red

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func draw(_ rect: CGRect) {
    }

    func drawCurve() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 80))
        path.addCurve(to: CGPoint(x: self.frame.size.width, y: 0.0),
                      controlPoint1: CGPoint(x: 50, y: 0),
                      controlPoint2: CGPoint(x: self.frame.size.width - 50, y: 100))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: 0, y: 50))

        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        self.backgroundColor = viewColor
        self.layer.mask = shapeLayer
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}
