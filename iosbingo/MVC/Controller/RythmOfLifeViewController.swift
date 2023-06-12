//
//  RythmOfLifeViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 05/09/2022.
//

import UIKit
import SDWebImage

class RythmOfLifeViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAspectNo: UILabel!

    var profileModel : ProfileModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        profileImage.sd_setImage(with: URL(string: (profileModel.avatar )), placeholderImage: UIImage(named: "defaultProfile"))
        lblDate.text = profileModel.spectrum.lastUpdated
        lblAspectNo.text = String(profileModel.spectrum.aspectsToLife)
    }

    //MARK: - IBActions

    @IBAction func btnActionWhatDoesAllMean(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ToValueMeReportViewController") as! ToValueMeReportViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActionUdpateInventory(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateValueInventoryViewController") as! UpdateValueInventoryViewController
        vc.profileModel = profileModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActionBack(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
}
