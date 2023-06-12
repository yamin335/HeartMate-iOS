//
//  DatingNightCatelogHeader.swift
//  iosbingo
//
//  Created by mac on 29/09/22.
//

import UIKit

class DatingNightCatelogHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_seeAll: UIButton!
    
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
