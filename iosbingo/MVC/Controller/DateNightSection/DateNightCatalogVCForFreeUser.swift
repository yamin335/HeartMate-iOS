//
//  DateNightCatalogVCForFreeUser.swift
//  iosbingo
//
//  Created by Hamza Saeed on 10/12/2022.
//

import UIKit

class DateNightCatalogVCForFreeUser: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!

    var dateNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        lblTitle.text = "\(dateNumber) Date Ideas"

    }

    //MARK: - IBActions

    @IBAction func btnActionLearnMore(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipController") as! MembershipController
        vc.subscritionType = .level2
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActionBack(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)

    }
}
