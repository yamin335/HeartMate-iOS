//
//  DatingNightCatelogIdeaPremiumExperienceCollectionViewCell.swift
//  iosbingo
//
//  Created by Gursewak singh on 15/12/22.
//

import UIKit

class DatingNightCatelogIdeaPremiumExperienceCollectionViewCell: UICollectionViewCell {

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
