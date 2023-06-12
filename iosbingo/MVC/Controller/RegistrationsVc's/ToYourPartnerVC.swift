//
//  ToYourPartnerVC.swift
//  iosbingo
//
//  Created by Mamun Ar Rashid on 19/12/22.
//

import Foundation
import UIKit
import SwiftUI


class ToYourPartnerVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_toValueMe: UILabel!
    @IBOutlet weak var lbl_Detail: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!

    @IBOutlet weak var labelFooterTag: UILabel!
    
    var journey : Journey?
    var isCameFromSnapCrousal = true
    var profileData : ProfileModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            self.profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .ProfileData, castTo: ProfileModel.self)
            print(self.profileData!)
        } catch {
            print(error.localizedDescription)
        }

        AppUserDefault.shared.set(value: true, for: .isUserRegistering)
        
        if isCameFromSnapCrousal{
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
        }
        
        labelName.text = "TO VALUE \( profileData?.firstname ?? "ME")"
        
        labelFooterTag.text = "And, \( profileData?.firstname ?? "Dear"), you’re worth it."

        //lbl_name.text = journey?.first_name
       // lbl_toValueMe.text = "234"
       // lbl_Detail.text = "\(journey?.first_name ?? "John"), I am ready to grow from random ‘meet & greets’ to a consistent dating journey"
       // lbl_Title.text = "Invite \(journey?.first_name ?? "John") to Level 2"


        //self.lbl_name.layer.cornerRadius = self.lbl_name.frame.width/2
        //self.lbl_name.layer.masksToBounds = true

    }

    @IBAction func btnActionSendToLevel(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DatingJourneyTutorialViewVC") as! DatingJourneyTutorialViewVC
        vc.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActionBack(_ sender: UIButton) {
        if isCameFromSnapCrousal{
            self.tabBarController?.tabBar.isHidden = false
        }
        self.navigationController?.popViewController(animated: true)
    }

}


struct ToYourPartnerVCWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = ToYourPartnerVC

    func makeUIViewController(context: UIViewControllerRepresentableContext<ToYourPartnerVCWrapper>) -> ToYourPartnerVCWrapper.UIViewControllerType {

        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ToYourPartnerVC") as! ToYourPartnerVC
        return vc

    }

    func updateUIViewController(_ uiViewController: ToYourPartnerVCWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<ToYourPartnerVCWrapper>) {
        //
    }
}
