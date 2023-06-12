//
//  MangeMemberShipViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 07/12/2022.
//

import UIKit

class MangeMemberShipViewController: UIViewController {

    //MARK: - IB Outlets
    @IBOutlet weak var imgHeaderForLevel2: UIImageView!
    @IBOutlet weak var imgHeaderForLevel3: UIImageView!
    @IBOutlet weak var imgHeaderForLevel3_1: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var lblExpiryDate: UILabel!
    @IBOutlet weak var btnSubscriptionTitle: UIButton!

    var subscritionType : MemberShipLevel = .onDemand
    var duration = ""
    var price = ""
    var expiryDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {

        duration = AppUserDefault.shared.getValue(for: .subscriptionDuration)
        price = AppUserDefault.shared.getValue(for: .subscriptionPrice)
        expiryDate = AppUserDefault.shared.getValue(for: .subscriptionExpirydate)

        lblPriceTitle.text = duration
        lblPrice.text = price
        let date = dateFromString(fromString: expiryDate, format: .DOB) ?? Date()
        let formattedStrDate = stringFromDate(date: date, format: .DOB)
        lblExpiryDate.text = formattedStrDate

        imgHeaderForLevel3.isHidden = true
        imgHeaderForLevel3_1.isHidden = true

        if subscritionType == .level2{
            lblTitle.text = "Level 2 - Dating Journey Experience"
            btnSubscriptionTitle.setTitle("Upgrade", for: .normal)
        }else if subscritionType == .level3{
            btnSubscriptionTitle.setTitle("Downgrade", for: .normal)
            lblTitle.text = "Level 3 - Committed Couple Experience"
            imgHeaderForLevel3.isHidden = false
            imgHeaderForLevel3_1.isHidden = false
            imgHeaderForLevel2.isHidden = true
        }
    }

    //MARK: - Custom Functions



    //MARK: - IB Actions

    @IBAction func btnActionUpgradeDowngrade(_ sender: UIButton) {
        if subscritionType == .level2 {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipController") as! MembershipController
            vc.subscritionType = .level3
            self.navigationController?.pushViewController(vc, animated: true)
        }else if subscritionType == .level3{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipController") as! MembershipController
            vc.subscritionType = .level2
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func btnActionCancel(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!)
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
