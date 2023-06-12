//
//  AcceptInvitationCodeViewController.swift
//  iosbingo
//
//  Created by mac on 07/10/22.
//

import UIKit

class AcceptInvitationCodeViewController: UIViewController {

    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_toValueMe: UILabel!
    @IBOutlet weak var lbl_invite: UILabel!
    
    var profileData : UserExistsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        do {
            profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .userData, castTo: UserExistsModel.self)
            print(profileData!)
        } catch {
            print(error.localizedDescription)
        }
        print(profileData)
        
        lbl_name.text = profileData?.invitedBy
        img_user.sd_setImage(with: URL(string: profileData?.inviterPicture ?? ""), placeholderImage: UIImage(named: "defaultProfile"))
        lbl_toValueMe.text = profileData?.inviterToValueMe ?? ""
        lbl_invite.text = "I invite you to invest in \(profileData?.inviterToValueMe ?? "") Experiences to ensure I feel seen & heard by you."
        
        self.lbl_name.layer.cornerRadius = self.lbl_name.frame.width/2
        self.lbl_name.layer.masksToBounds = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "acceptInvitation"{
            if let vc = segue.destination as? ConfirmedYesViewController{
                vc.profileData = self.profileData
            }
        }
    }
    
    @IBAction func btn_acceptInvitation(_ sender: UIButton) {

        let params = ["invitation_code": profileData?.invitationCode ?? ""] as [String:Any]
        print(params)
        API.shared.sendData(url: APIPath.datingPartnershipAccepted, requestType: .post, params: params, objectType: RegistrationModel.self) { (data,status)  in
            if status {
                guard let invitationData = data else {return}
                AppLoader.shared.hide()
                self.generateAlert(withMsg: "invitation Accepted successfully", otherBtnTitle: "OK") { isPressedOkBtn in
                    self.performSegue(withIdentifier: "acceptInvitation", sender: self)
                    //self.pushController(controllerName: "BirthdayViewController", storyboardName: "Main")
                }
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }

    }
    
    @IBAction func btn_declineInvitation(_ sender: UIButton) {
        
        let params = ["invitation_code": profileData?.invitationCode ?? ""] as [String:Any]
        print(params)
        API.shared.sendData(url: APIPath.datingPartnershipRejected, requestType: .post, params: params, objectType: RegistrationModel.self) { (data,status)  in
            if status {
                guard let invitationData = data else {return}
                AppLoader.shared.hide()
                self.generateAlert(withMsg: "invitation Rejected successfully", otherBtnTitle: "OK") { isPressedOkBtn in
                    self.performSegue(withIdentifier: "RejectInvitation", sender: self)
                    //self.pushController(controllerName: "BirthdayViewController", storyboardName: "Main")
                }
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
        
        
    }
    
    
}
