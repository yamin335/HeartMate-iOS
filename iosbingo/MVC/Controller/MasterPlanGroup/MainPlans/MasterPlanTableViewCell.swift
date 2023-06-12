//
//  MasterPlanTableViewCell.swift
//  iosbingo
//
//  Created by Hamza Saeed on 16/09/2022.
//

import UIKit

class MasterPlanTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var imgPlan: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblExcerpt: UILabel!
    @IBOutlet weak var imgStart: UIImageView!
    @IBOutlet weak var lblOffer: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
