//
//  DatingJourneyUpcomingDatesDetailTableViewCell.swift
//  iosbingo
//
//  Created by mac on 30/09/22.
//

import UIKit

class DatingJourneyUpcomingDatesDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_reschedule: UIButton!
    
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
