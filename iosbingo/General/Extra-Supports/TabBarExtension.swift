//
//  TabBarExtension.swift
//  iosbingo
//
//  Created by Hamza Saeed on 07/10/2022.
//

import UIKit

//extension UITabBar {
//    func addBadge(index:Int,value:String) {
//        if let tabItems = self.items {
//            let tabItem = tabItems[index]
//            tabItem.badgeValue = value
//            tabItem.badgeColor = .black
//            tabItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
//        }
//    }
//    func removeBadge(index:Int) {
//        if let tabItems = self.items {
//            let tabItem = tabItems[index]
//            tabItem.badgeValue = nil
//        }
//    }
//
// }

private let lxfFlag: Int = 678

extension UITabBar {
    //MARK:-show small red dot
    func showBadgOn (index itemIndex: Int, count:String) {
        // Remove the previous red dot
        self.removeBadge(on: itemIndex)    //get total items
        let tabbarItemNums: CGFloat = CGFloat(self.items?.count ?? 5)     // create a little red dot
        //this view can hold anything text image
        let bageView = UIView()
        bageView.tag = itemIndex + lxfFlag
        bageView.layer.cornerRadius = 7.5
        bageView.backgroundColor = UIColor.red
        let tabFrame = self.frame    // determine the position of the small red dot
        let percentX: CGFloat = (CGFloat(itemIndex) + 0.59) / tabbarItemNums
        let xPos: CGFloat = CGFloat(ceilf(Float(percentX * tabFrame.size.width) - 5))
        let yPos: CGFloat = CGFloat(ceilf(Float(tabFrame.size.height * 0.115) + 2))
        bageView.frame = CGRect(x: xPos, y: yPos, width: 15, height: 15)

        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width:bageView.bounds.size.width, height: bageView.bounds.size.height))
        headerLabel.textColor = UIColor.white
        headerLabel.text = count
        headerLabel.font = UIFont.boldSystemFont(ofSize: 10)
        headerLabel.textAlignment = .center
        bageView.addSubview(headerLabel)
        self.addSubview(bageView)
    }

    //MARK:-hide the red dot
    func hideBadg(on itemIndex: Int) {
        // remove the little red dot
        self.removeBadge(on: itemIndex)
    }

    //MARK:-remove the red dot
    private func removeBadge(on itemIndex: Int) {
        // Remove by tag value
        _ = subviews.map {
        if $0.tag == itemIndex + lxfFlag {
            $0.removeFromSuperview()
            }
        }
    }
}
