//
//  PartnerVisionVC.swift
//  iosbingo
//
//  Created by Hamza Saeed on 17/12/2022.
//

import UIKit

class PartnerVisionVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var lblPartnerMindset: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSeasonOfBliss: UILabel!
    @IBOutlet weak var lblYourPerson: UILabel!
    @IBOutlet weak var lblMomentum: UILabel!
    @IBOutlet weak var lblBeAware: UILabel!

    var partnerVision : PartnerVisionBoardModel?
    var visionId = 0
    var profileData : UserExistsModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            self.profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .userData, castTo: UserExistsModel.self)
            lblTitle.text = profileData?.firstName ?? "N/A"
        } catch {
            print(error.localizedDescription)
        }
        getPartnerVision()
    }

    //MARK: - Custom Functions

    func updateUI(){
        lblPartnerMindset.text = partnerVision?.response.partnerMindset != nil ? partnerVision?.response.partnerMindset : "Not Found"
        lblSeasonOfBliss.text = partnerVision?.response.seasonOfBliss != nil ? partnerVision?.response.seasonOfBliss : "Not Found"
        lblYourPerson.text = partnerVision?.response.yourPerson != nil ? partnerVision?.response.yourPerson : "Not Found"
        lblMomentum.text = partnerVision?.response.datingMomentum != nil ? partnerVision?.response.datingMomentum : "Not Found"
        lblBeAware.text = partnerVision?.response.beAware != nil ? partnerVision?.response.beAware : "Not Found"
    }

    func getPartnerVision(){
        AppLoader.shared.show(currentView: self.view)
        let cache = randomString(length: 32)
        let params = ["vision_board_id":visionId,"cache":cache] as [String:Any]
        API.shared.sendData(url: APIPath.getPartnerVision, requestType: .post, params: params, objectType: PartnerVisionBoardModel.self) { (data,status)  in
            if status {
                guard let partner = data else{AppLoader.shared.hide()
                    return
                }
                self.partnerVision = partner
                self.updateUI()
                AppLoader.shared.hide()
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    //MARK: - IBActions
    @IBAction func btnActonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActonIceBreakers(_ sender: UIButton) {
        let vc = UIStoryboard(name: "VisionBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "IceBreakersVC") as! IceBreakersVC
        vc.visionId = visionId
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
