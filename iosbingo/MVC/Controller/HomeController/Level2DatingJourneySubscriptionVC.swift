//
//  Level2DatingJourneySubscriptionVC.swift
//  iosbingo
//
//  Created by Hamza Saeed on 11/12/2022.
//

import UIKit

class Level2DatingJourneySubscriptionVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_toValueMe: UILabel!
    @IBOutlet weak var lbl_Detail: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!

    var journey : Journey?
    var isCameFromSnapCrousal = true

    override func viewDidLoad() {
        super.viewDidLoad()

        if isCameFromSnapCrousal{
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
        }

        lbl_name.text = journey?.first_name
        img_user.sd_setImage(with: URL(string: journey?.avatar ?? ""), placeholderImage: UIImage(named: "defaultProfile"))
        lbl_toValueMe.text = "234"
        lbl_Detail.text = "\(journey?.first_name ?? "John"), I am ready to grow from random ‘meet & greets’ to a consistent dating journey"
        lbl_Title.text = "Invite \(journey?.first_name ?? "John") to Level 2"


        self.lbl_name.layer.cornerRadius = self.lbl_name.frame.width/2
        self.lbl_name.layer.masksToBounds = true

    }

    @IBAction func btnActionSendToLevel(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipController") as! MembershipController
        vc.subscritionType = .level2
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActionBack(_ sender: UIButton) {
        if isCameFromSnapCrousal{
            self.tabBarController?.tabBar.isHidden = false
        }
        self.navigationController?.popViewController(animated: true)
    }

}
