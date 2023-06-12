//
//  IceBreakerTableViewCell.swift
//  iosbingo
//
//  Created by Hamza Saeed on 17/12/2022.
//

import UIKit

protocol IceBreakerCopy{
    func onPress(index:IndexPath)
}

class IceBreakerTableViewCell: UITableViewCell {

    @IBOutlet weak var lblIceBreaker: UILabel!

    var delegate : IceBreakerCopy?
    var index:IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnActionCopy(_ sender: UISwitch) {
        delegate?.onPress(index: index!)
    }

}

