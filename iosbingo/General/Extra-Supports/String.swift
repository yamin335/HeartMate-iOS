//
//  String.swift
//  iosbingo
//
//  Created by Hamza Saeed on 29/08/2022.
//

import UIKit
extension NSMutableAttributedString {

    func bold(_ value:String, point:CGFloat = 15) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [.font : UIFont(name: "Inter-SemiBold", size: point) ?? UIFont.systemFont(ofSize: point)]

       self.append(NSAttributedString(string: value, attributes:attributes))
       return self
   }

   func normal(_ value:String, point:CGFloat = 15) -> NSMutableAttributedString {

       let attributes:[NSAttributedString.Key : Any] = [.font : UIFont(name: "Inter-Regular", size: point) ?? UIFont.systemFont(ofSize: point)]

       self.append(NSAttributedString(string: value, attributes:attributes))
       return self
   }
}

extension String {
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }

        return try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
    }

    func convertToAttributedString() -> NSAttributedString? {
            let modifiedFontString = "<span style=\"font-family: Inter-Regular; font-size: 14; color: rgb(60, 60, 60)\">" + self + "</span>"
            return modifiedFontString.htmlAttributedString()
        }
}
