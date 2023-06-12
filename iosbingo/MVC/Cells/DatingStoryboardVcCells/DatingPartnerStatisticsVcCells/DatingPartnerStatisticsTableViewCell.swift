//
//  DatingPartnerStatisticsTableViewCell.swift
//  iosbingo
//
//  Created by mac on 30/09/22.
//

import UIKit

class DatingPartnerStatisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var btn_plus: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
