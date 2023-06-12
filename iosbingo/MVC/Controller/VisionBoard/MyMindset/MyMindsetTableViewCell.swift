//
//  MyMindsetTableViewCell.swift
//  iosbingo
//
//  Created by Hamza Saeed on 14/12/2022.
//

import UIKit

class MyMindsetTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMindsetEntry: UILabel!
    @IBOutlet weak var imgRadio: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
