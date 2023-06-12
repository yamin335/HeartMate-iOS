//
//  Level1GuidanceViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 04/09/2022.
//

import UIKit
import MessageUI
import DropDown

class Level1GuidanceViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var radioImgLevel1: UIImageView!
    @IBOutlet weak var radioImgLevel2: UIImageView!
    @IBOutlet weak var radioImgLevel3: UIImageView!
    @IBOutlet weak var btnDropDown: UIButton!

    @IBOutlet weak var btnNextStep: UIButton!
    @IBOutlet weak var btnManageInvitation: UIButton!
    @IBOutlet weak var btnSendInvitation: UIButton!
    
    var profileData:ProfileModel?
    let matchDropDown = DropDown()
    var matchValue = ""
    var isLevel1Selected = true
    var isLevel2Selected = false
    var isLevel3Selected = false
    var levelValue = 1
    var isPremiurm = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFieldEmail.setLeftPaddingPoints(10.0)
        txtFieldName.setLeftPaddingPoints(10.0)
        levelValue = 1
        radioImgLevel1.image = UIImage(named: "checked")
        radioImgLevel2.image = UIImage(named: "uncheckRadio")
        radioImgLevel3.image = UIImage(named: "uncheckRadio")
        
        if AppUserDefault.shared.getValueBool(for: .isUserRegistering) {
            btnNextStep.isHidden = true
            btnManageInvitation.isHidden = true
            btnSendInvitation.isHidden = false
        } else {
            btnNextStep.isHidden = false
            btnManageInvitation.isHidden = false
            btnSendInvitation.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        isPremiurm = AppUserDefault.shared.getValueBool(for: .premiumUnlocked)
        self.getProfileData()

    }
    //MARK: - CustoM Functions

    @IBAction func btnActionSendInvitation(_ sender: Any) {
        
    }
    func getProfileData() {
        AppLoader.shared.show(currentView: self.view)
        let userID = AppUserDefault.shared.getValueInt(for: .UserID)
        let cache = randomString(length: 32)
        let params = ["user_id":userID,"cache":cache] as [String:Any]
        API.shared.sendData(url: APIPath.profile, requestType: .get, params: params, objectType: ProfileModel.self, isTokenRequired: false) { (data,status)  in
            if status {
                guard let profileData = data else {return}
                self.profileData = profileData
                AppLoader.shared.hide()
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    func sendInvitationCode(){
        if fieldValidation() {
            AppLoader.shared.show(currentView: self.view)
            API.shared.ValidateToken { isValid in
                if isValid{
                    let params = ["firstName":self.txtFieldName.text!,"invitee_phone_number": self.txtFieldEmail.text!, "cache": randomString(length: 32),"invitation_type":"level_\(self.levelValue)","group_level":self.levelValue,"match_source":self.matchValue] as [String:Any]
                    print(params)
                    API.shared.sendData(url: APIPath.invitation1, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                        if status {
                            AppLoader.shared.hide()
                            self.sendIMessage(self.txtFieldEmail.text!)
                            //self.showAlert(message: "Invitation code sent successfully", titled: "Alert")
                            //self.navigationController?.popViewController(animated: true)

                        }else{
                            AppLoader.shared.hide()
                            print("Error found")
                        }
                    }
                }else{
                    AppLoader.shared.hide()
                    removeUserPreference()
                    navigatetoLoginScreen()
                }
            }
        }else{
            showAlert(message: "Fields are mandatory")
        }

    }

    func fieldValidation() -> Bool{
        var  isValid = false
        if txtFieldEmail.text != ""{
            isValid = true
        }

        if txtFieldName.text != ""{
            isValid = true
        }else{
            isValid = false
        }

        if matchValue != ""{
            isValid = true
        }else{
            isValid = false
        }

        return isValid
    }

    func sendIMessage(_ phoneNumber : String) {
        if MFMailComposeViewController.canSendMail() {
            let messageVC = MFMessageComposeViewController()
            if levelValue == 1 {
                messageVC.body = "I invite you To Value Me. \nIf you should accept, this marks the start of a guided exploration of one another beyond the physical towards purpose-driven dating.\nI added you using \(phoneNumber), so make sure to use that number when you register. Here is the link! https://applestore.com/app."
            }else if levelValue == 2{
                messageVC.body = "I invite you To Value Me. \nIf you should accept, this marks the beginning of our dating journey. And I'll learn to value you too.\nI added you using \(phoneNumber), so make sure to use that number when you register. Here is the link! https://applestore.com/app."
            }else{
                messageVC.body = "I invite you To Value Me. \n\\ If you should accept, this marks the beginning of our journey to marry our two lives together into one.\nI added you using \(phoneNumber), so make sure to use that number when you register. Here is the link! https://applestore.com/app."
            }
            messageVC.recipients = [phoneNumber]
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true, completion: nil)
        }else {
            self.showAlert(message: "Unable to send message", titled: "Oops!")
        }
    }

    //MARK: - IB Actios

    @IBAction func btn_DropDown(_ sender: UIButton) {
        guard let profileData = profileData else {return}
        matchDropDown.cellHeight = 50
        matchDropDown.dataSource = profileData.matchSource.map({$0})
        matchDropDown.anchorView = sender
        matchDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        matchDropDown.separatorColor = .gray
        matchDropDown.show()
        matchDropDown.selectionAction = { [weak self] (index: Int, item: String) in
          guard let _ = self else { return }
            self?.btnDropDown.setTitle(profileData.matchSource[index], for: .normal)
            self?.matchValue = profileData.matchSource[index]
        }
    }

    @IBAction func btn_ActionLevel1(_ sender: Any) {
        levelValue = 1
        radioImgLevel1.image = UIImage(named: "checked")
        radioImgLevel2.image = UIImage(named: "uncheckRadio")
        radioImgLevel3.image = UIImage(named: "uncheckRadio")

    }

    @IBAction func btn_ActionLevel2(_ sender: Any) {
        if (profileData?.subscriptionType == "level_2" || profileData?.subscriptionType == "level_3" ) && isPremiurm{
            levelValue = 2
            radioImgLevel1.image = UIImage(named: "uncheckRadio")
            radioImgLevel2.image = UIImage(named: "checked")
            radioImgLevel3.image = UIImage(named: "uncheckRadio")
        }else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipController") as! MembershipController
            vc.subscritionType = .level2
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func btn_ActionLevel3(_ sender: Any) {
        if profileData?.subscriptionType == "level_3" && isPremiurm{
            levelValue = 3
            radioImgLevel1.image = UIImage(named: "uncheckRadio")
            radioImgLevel2.image = UIImage(named: "uncheckRadio")
            radioImgLevel3.image = UIImage(named: "checked")
        }else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipController") as! MembershipController
            vc.subscritionType = .level3
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func btnActonSubmit(_ sender: UIButton) {
        sendInvitationCode()
    }
    
}

extension Level1GuidanceViewController: MFMessageComposeViewControllerDelegate{
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch (result) {
            case .cancelled:
                print("Message was cancelled")
            case .failed:
                print("Message failed")
                self.showAlert(message: "Failed to send message, try again", titled: "Oops!")
            case .sent:
                print("Message was sent")
                self.navigationController?.popViewController(animated: true)
            default:
                return
            }
            dismiss(animated: true, completion: nil)
        }

    @IBAction func btnActonManageInvitation(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Level1HistoyViewController") as! Level1HistoyViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
