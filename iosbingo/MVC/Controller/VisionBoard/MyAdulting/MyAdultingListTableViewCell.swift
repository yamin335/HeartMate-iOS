//
//  MyAdultingListTableViewCell.swift
//  iosbingo
//
//  Created by Hamza Saeed on 16/12/2022.
//

import UIKit

class MyAdultingListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSessionEntry: UILabel!
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
