//
//  NotificationTableViewCell.swift
//  iosbingo
//
//  Created by Hamza Saeed on 07/10/2022.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNotificationType: UILabel!
    @IBOutlet weak var lblTimeSince: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!

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

//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0))
    }

}
