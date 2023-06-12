//
//  DateNightCatelogWeeksIdeaCollectionViewCell.swift
//  iosbingo
//
//  Created by mac on 29/09/22.
//

import UIKit

class DateNightCatelogWeeksIdeaCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img_background: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var btn_route: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
