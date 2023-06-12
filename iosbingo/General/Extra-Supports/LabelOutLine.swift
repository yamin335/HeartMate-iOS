//
//  LabelOutLine.swift
//  iosbingo
//
//  Created by Hamza Saeed on 08/10/2022.
//

import UIKit


public class OutlinedText: UILabel{
    internal var mOutlineColor:UIColor?
    internal var mOutlineWidth:CGFloat?

    @IBInspectable var outlineColor: UIColor{
        get { return mOutlineColor ?? UIColor.clear }
        set { mOutlineColor = newValue }
    }

    @IBInspectable var outlineWidth: CGFloat{
        get { return mOutlineWidth ?? 0 }
        set { mOutlineWidth = newValue }
    }

    override public func drawText(in rect: CGRect) {
        let shadowOffset = self.layer.shadowOffset
        let textColor = self.textColor

        let c = UIGraphicsGetCurrentContext()
        c?.setLineWidth(outlineWidth)
        c?.setLineJoin(.round)
        c?.setTextDrawingMode(.stroke)
        self.textColor = mOutlineColor;
        super.drawText(in:rect)

        c?.setTextDrawingMode(.fill)
        self.textColor = textColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in:rect)

        self.layer.shadowOffset = shadowOffset
    }
}
