//
//  ReviewTableViewCell.swift
//  iosbingo
//
//  Created by user229230 on 12/19/22.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var updatebutton: UIButton!
    @IBOutlet weak var exp: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
}
