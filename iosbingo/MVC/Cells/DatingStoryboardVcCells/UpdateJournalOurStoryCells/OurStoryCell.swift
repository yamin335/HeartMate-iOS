//
//  OurStoryCell.swift
//  iosbingo
//
//  Created by Mac mac on 08/12/22.
//

import UIKit

class OurStoryCell: UITableViewCell {

    
    @IBOutlet weak var MainLabel: UILabel!
    @IBOutlet weak var discoveryOtherLabel: UILabel!
    @IBOutlet weak var discoveryLabelYou: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateCountLabel: UILabel!
    @IBOutlet weak var discoviesView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        discoviesView.dropShadow()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
