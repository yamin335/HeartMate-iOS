//
//  NotificationCell.swift
//  iosbingo
//
//  Created by Hamza Saeed on 02/08/2022.
//

import UIKit

protocol NotificationCellToggle{
    func onToggle(index:IndexPath,sender:UISwitch)
}

class NotificationCell: UITableViewCell {

    @IBOutlet weak var lblNotificationName: UILabel!
    @IBOutlet weak var lblNotificationSecondaryName: UILabel!
    @IBOutlet weak var btnToggle: UISwitch!
    @IBOutlet weak var constraintSecondaryLbl: NSLayoutConstraint!
    var delegate : NotificationCellToggle?
    var index:IndexPath?

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

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }

    @IBAction func btnToggleAction(_ sender: UISwitch) {
        delegate?.onToggle(index: index!, sender: sender)
    }

}
