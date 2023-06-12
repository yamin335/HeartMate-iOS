//
//  CreateLevel2InvitationViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 09/10/2022.
//

import UIKit

class CreateLevel2InvitationViewController: UIViewController {

    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblQuestion1: UILabel!
    @IBOutlet weak var lblQuestion2: UILabel!
    @IBOutlet weak var lblQuestion3: UILabel!
    @IBOutlet weak var txtFieldQ1: UITextField!
    @IBOutlet weak var txtFieldQ2: UITextField!
    @IBOutlet weak var txtFieldQ3: UITextField!

    var journey : Journey?
    var isCameForJourneyHomeScreen = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true

//        lblDetail.attributedText = NSMutableAttributedString().normal("Share your responses to the following questions with ").bold("Kenesha ").normal("along with your ").bold("Level 2 invitation:")
//        lblQuestion1.attributedText = NSMutableAttributedString().normal("What do you look for to know when ").bold("Kenesha ").normal("is uncomfortable?")
//        lblQuestion2.attributedText = NSMutableAttributedString().normal("Share a few actions you’ve learned to use to bring ").bold("Kenesha ").normal("back from discomfort to balance & serenity?")
//        lblQuestion3.attributedText = NSMutableAttributedString().normal("Is ").bold("Kenesha ").normal("capable of hiding their discomfort from you; if so share a few ways you’ve learned to make ").bold("Kenesha ").normal("feel safe enough to...")

        lblDetail.text = journey?.level2_Commiement?.level2_InvitationDescription
        lblTitle.text = journey?.level2_Commiement?.header
        lblQuestion1.text = journey?.level2_Commiement?.comfortableText
        lblQuestion2.text = journey?.level2_Commiement?.balanceText
        lblQuestion3.text = journey?.level2_Commiement?.safeText

    }


    func createInvitation(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = ["group_id":self.journey?.groupId ?? 0,"comfort_response":self.txtFieldQ1.text ?? "test" ,"balance_response":self.txtFieldQ2.text ?? "test","safety_response":self.txtFieldQ3.text ?? "test"] as [String:Any]
                API.shared.sendData(url: APIPath.createLevel2Invitation, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                    if status {
                        AppLoader.shared.hide()
                        self.generateAlert(withMsg: "Invitatiaon created", otherBtnTitle: "Ok") { status in
                            if status {
                                self.tabBarController?.tabBar.isHidden = false
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else{
                        AppLoader.shared.hide()
                        print("Error found")
                    }
                }
            }else{
                AppLoader.shared.hideWithHandler(completion: { isDone in
                    if isDone{
                        removeUserPreference()
                        navigatetoLoginScreen()
                    }
                })

            }
        }
    }

    @IBAction func btnActonSubmit(_ sender: UIButton) {
        if isCameForJourneyHomeScreen{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipController") as! MembershipController
            vc.subscritionType = .level3
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            createInvitation()
        }
    }

    @IBAction func btnActionBack(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
        
    }

}
