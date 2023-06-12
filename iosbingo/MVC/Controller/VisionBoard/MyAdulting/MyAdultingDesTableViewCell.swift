//
//  MyAdultingDesTableViewCell.swift
//  iosbingo
//
//  Created by Hamza Saeed on 16/12/2022.
//

import UIKit

protocol VisionSeeDescriptionProtocol{
    func onPress(index:IndexPath)
}
class MyAdultingDesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSessionEntry: UILabel!

    var delegate : VisionSeeDescriptionProtocol?
    var index:IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnActionDescription(_ sender: UISwitch) {
        delegate?.onPress(index: index!)
    }

}
