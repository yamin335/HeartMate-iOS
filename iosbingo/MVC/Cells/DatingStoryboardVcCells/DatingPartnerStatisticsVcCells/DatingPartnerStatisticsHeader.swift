//
//  DatingPartnerStatisticsHeader.swift
//  iosbingo
//
//  Created by mac on 30/09/22.
//

import UIKit

class DatingPartnerStatisticsHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var btn_click: UIButton!
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
