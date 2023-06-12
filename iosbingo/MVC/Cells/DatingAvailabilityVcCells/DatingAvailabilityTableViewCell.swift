//
//  DatingAvailabilityTableViewCell.swift
//  iosbingo
//
//  Created by apple on 30/08/22.
//

import UIKit

class DatingAvailabilityTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_days: UILabel!
    @IBOutlet weak var btn_checkUncheck: UIButton!

    var btnAvailabilityAction : ((Int, UIButton) -> ())?
    
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
    
//    func setData(index : Int){
//        self.btn_checkUncheck.tag = index
//        self.lbl_days.text! = self.days[index]
//    }
    
    @IBAction func btn_checkUncheck(_ sender: UIButton) {
        self.btnAvailabilityAction?(sender.tag, sender)
    }

}
