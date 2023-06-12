//
//  DatingPreferenceLocationTableViewCell.swift
//  iosbingo
//
//  Created by Hamza Saeed on 27/10/2022.
//

import UIKit

class DatingPreferenceLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFlag: UILabel!
    @IBOutlet weak var lblCity: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
