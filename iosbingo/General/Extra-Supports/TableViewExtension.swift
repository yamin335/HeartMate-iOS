//
//  TableViewExtension.swift
//  iosbingo
//
//  Created by Mac mac on 08/12/22.
//

import Foundation
import UIKit
extension UITableView{
    func dequeCell<T:UITableViewCell>(of type:T,with identier:String, to indexpath:IndexPath) -> UITableViewCell {
        //        guard let storyCell = self.self.dequeueReusableCell(withIdentifier: "OurStoryCell", for: indexPath) as? T else { return UITableViewCell.init()}
        guard let cell = self.dequeueReusableCell(withIdentifier: identier, for: indexpath) as? T
        else { return UITableViewCell.init()}
        return cell
    }
    
}
