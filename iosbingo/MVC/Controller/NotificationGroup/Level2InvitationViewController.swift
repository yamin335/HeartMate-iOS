//
//  Level2InvitationViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 08/10/2022.
//

import UIKit
import DropDown


class Level2InvitationViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblInvitieName: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblComfort: UILabel!
    @IBOutlet weak var lblComfortResponse: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblBalanceResponse: UILabel!
    @IBOutlet weak var lblSafe: UILabel!
    @IBOutlet weak var lblSafeResponse: UILabel!
    @IBOutlet weak var lblFooter: OutlinedText!

    let acceptCategroy = ["Yes, Let’s do this!","Let’s explore each other more, first","No, let’s end this."]
    let invitationAcceptDropDown = DropDown()
    var commitmentModel : CommitmentModel?
    var notification : Notification!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        getCommitmentOffer()
    }

    //MARK: - Custom Functions
    func getCommitmentOffer(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = ["offer_post_id":self.notification.itemID] as [String:Any]
                print(params)
                API.shared.sendData(url: APIPath.commitment, requestType: .post, params: params, objectType: CommitmentModel.self) { (data,status)  in
                    if status {
                        guard let commitmentData = data else {
                            AppLoader.shared.hide()
                            return}
                        self.commitmentModel = commitmentData
                        self.initializeUI()
                        AppLoader.shared.hide()
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

    func acceptOffer(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let cookie = AppUserDefault.shared.getValue(for: .Cookie)
                let params = ["offer_post_id":self.notification.itemID,"group_id":self.commitmentModel?.groupID ?? 0,"comfort_response":self.commitmentModel?.comfortableResponse ?? "","balance_response":self.commitmentModel?.balanceResponse ?? "","safety_response":self.commitmentModel?.safeResponse ?? ""] as [String:Any]
                API.shared.sendData(url: APIPath.acceptOffer, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                    if status {
                        AppLoader.shared.hide()
                        self.showAlert(message: "Invitation accepted")
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

    func doubleConfirmation(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = ["acceptance_post_id":self.notification.itemID,"group_id":self.commitmentModel?.groupID ?? 0] as [String:Any]
                print(params)
                API.shared.sendData(url: APIPath.doubleAcceptOffer, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                    if status {
                        AppLoader.shared.hide()
                        self.showAlert(message: "Double Invitation Confirmed")
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

    func rejectOffer(decisionResponse:Int){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let cookie = AppUserDefault.shared.getValue(for: .Cookie)
                let params = ["offer_post_id":self.notification.itemID,"group_id":self.commitmentModel?.groupID ?? 0,"decision_response": decisionResponse] as [String:Any]
                print(params)
                API.shared.sendData(url: APIPath.rejectOffer, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                    if status {
                        AppLoader.shared.hide()
                        self.showAlert(message: "Invitation Rejected")
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

    func initializeUI(){
        imageProfile.sd_setImage(with: URL(string: commitmentModel?.inviterAvatar ?? ""), placeholderImage: UIImage(named: "notificationdummy"))
        lblInvitieName.text = commitmentModel?.inviterName
        lblDescription.text = commitmentModel?.descriptionText
        lblComfort.text = commitmentModel?.comfortableLabel
        lblComfortResponse.text = commitmentModel?.comfortableResponse
        lblBalance.text = commitmentModel?.balanceLabel
        lblBalanceResponse.text = commitmentModel?.balanceResponse
        lblSafe.text = commitmentModel?.safeLabel
        lblSafeResponse.text = commitmentModel?.safeResponse
        lblFooter.text = commitmentModel?.footerText
    }

    //MARK: - Button Actions

    @IBAction func btnActionBack(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)

    }

    @IBAction func btnActionAccept(_ sender: UIButton) {
        invitationAcceptDropDown.cellHeight = 60
        invitationAcceptDropDown.dataSource = commitmentModel?.submissionOptions.map({$0}) ?? acceptCategroy
        invitationAcceptDropDown.anchorView = sender
        invitationAcceptDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        invitationAcceptDropDown.separatorColor = .gray
        invitationAcceptDropDown.show()
        invitationAcceptDropDown.selectionAction = { [weak self] (index: Int, item: String) in
          guard let _ = self else { return }
            print("selected category id is",(self?.acceptCategroy[index]) ?? "no value")
            if index == 0 {
                if self?.commitmentModel?.acceptanceStatus == 0 {
                    if self?.commitmentModel?.sender == 0 {
                        let vc = UIStoryboard(name: "Notifications", bundle: Bundle.main).instantiateViewController(withIdentifier: "Level2GuidanceViewController") as! Level2GuidanceViewController
                        vc.commitmentModel = self?.commitmentModel
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self?.doubleConfirmation()
                    }
                }
            }else{
                if self?.commitmentModel?.acceptanceStatus == 0 {
                    self?.rejectOffer(decisionResponse: index)
                }
            }
        }
    }

}
