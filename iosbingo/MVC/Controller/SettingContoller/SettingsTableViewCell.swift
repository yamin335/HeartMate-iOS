//
//  SettingsTableViewCell.swift
//  iosbingo
//
//  Created by Hamza Saeed on 22/07/2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSettingName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
            super.layoutSubviews()

            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        }

}
