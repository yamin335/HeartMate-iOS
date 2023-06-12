//
//  Level2GuidanceViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 04/09/2022.
//

import UIKit

class Level2GuidanceViewController: UIViewController {

    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblQuestion1: UILabel!
    @IBOutlet weak var lblQuestion2: UILabel!
    @IBOutlet weak var lblQuestion3: UILabel!
    @IBOutlet weak var txtFieldQ1: UITextField!
    @IBOutlet weak var txtFieldQ2: UITextField!
    @IBOutlet weak var txtFieldQ3: UITextField!

    var commitmentModel : CommitmentModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        lblDetail.attributedText = NSMutableAttributedString().normal("Share your responses to the following questions with ").bold("Kenesha ").normal("along with your ").bold("Level 2 invitation:")
//        lblQuestion1.attributedText = NSMutableAttributedString().normal("What do you look for to know when ").bold("Kenesha ").normal("is uncomfortable?")
//        lblQuestion2.attributedText = NSMutableAttributedString().normal("Share a few actions you’ve learned to use to bring ").bold("Kenesha ").normal("back from discomfort to balance & serenity?")
//        lblQuestion3.attributedText = NSMutableAttributedString().normal("Is ").bold("Kenesha ").normal("capable of hiding their discomfort from you; if so share a few ways you’ve learned to make ").bold("Kenesha ").normal("feel safe enough to...")

        lblDetail.text = commitmentModel?.level2_Invitation?.level2_InvitationDescription
        lblTitle.text = commitmentModel?.level2_Invitation?.header
        lblQuestion1.text = commitmentModel?.level2_Invitation?.comfortableText
        lblQuestion2.text = commitmentModel?.level2_Invitation?.balanceText
        lblQuestion3.text = commitmentModel?.level2_Invitation?.safeText

    }


    func acceptOffer(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let cookie = AppUserDefault.shared.getValue(for: .Cookie)
                let params = ["offer_post_id":self.commitmentModel?.offerPostID ?? 0,"group_id":self.commitmentModel?.groupID ?? 0,"comfort_response":self.txtFieldQ1.text ?? "test" ,"balance_response":self.txtFieldQ2.text ?? "test","safety_response":self.txtFieldQ3.text ?? "test"] as [String:Any]
                API.shared.sendData(url: APIPath.acceptOffer, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                    if status {
                        AppLoader.shared.hide()
                        self.generateAlert(withMsg: "Invitatiaon accepted", otherBtnTitle: "Ok") { status in
                            if status {
                                self.tabBarController?.tabBar.isHidden = false
                                self.navigationController?.popToRootViewController(animated: true)
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
        acceptOffer()
    }

}
