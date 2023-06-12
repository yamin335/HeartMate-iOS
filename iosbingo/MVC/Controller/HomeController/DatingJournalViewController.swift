//
//  DatingJournalViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 12/10/2022.
//

import UIKit
import SDWebImage

class DatingJournalViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgUser1: UIImageView!
    @IBOutlet weak var imgUser2: UIImageView!
    @IBOutlet weak var btn30Day: UIButton!
    @IBOutlet weak var lbl30Day: UILabel!
    @IBOutlet weak var img30Day: UIImageView!
    @IBOutlet weak var lblCreateDateNight: UILabel!
    @IBOutlet weak var lblCalendar: UILabel!
    @IBOutlet weak var lblUpdatingJourney: UILabel!
    @IBOutlet weak var imgCreateDateNight: UIImageView!
    @IBOutlet weak var imgCalendar: UIImageView!
    @IBOutlet weak var dateNightView: UIView!

    var journeyModel : DatingJourneyJournalModel?
    var journey : Journey?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true

        dateNightView.isHidden = true
        imgUser1.layer.cornerRadius = imgUser1.frame.size.width/2
        imgUser1.layer.masksToBounds = true

        imgUser2.layer.cornerRadius = imgUser2.frame.size.width/2
        imgUser2.layer.masksToBounds = true


        if journey?.ourStatus?.level == "Level 1" {
            img30Day.isHidden = true
            lbl30Day.isHidden = true
            btn30Day.isHidden = true
        }
       
        
        
        getJournal()
    }

    //MARK: - Custom Functions

    func getJournal(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = ["group_id":self.journey?.groupId ?? 0] as [String:Any]
                API.shared.sendData(url: APIPath.getDatingJournal, requestType: .post, params: params, objectType: DatingJourneyJournalModel.self) { (data,status)  in
                    if status {
                        guard let datingJournal = data else {
                            AppLoader.shared.hide()
                            return}
                        self.journeyModel = datingJournal
                        self.updateUI()
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

    func updateUI(){
        lblTitle.text = self.journeyModel?.journeyHome[0].datingStatus ?? ""
        lblUpdatingJourney.text = self.journeyModel?.journeyHome[0].goalDescription ?? ""
        imgUser1.sd_setImage(with: URL(string: self.journeyModel?.journeyHome[0].myAvatar ?? ""), placeholderImage: UIImage(named: "notificationdummy"))
        imgUser2.sd_setImage(with: URL(string: self.journeyModel?.journeyHome[0].partnerAvatar ?? ""), placeholderImage: UIImage(named: "notificationdummy"))
    }

    //MARK: - IBActions

    @IBAction func btnActionHeart(_ sender: UIButton) {
    }

    @IBAction func btnActionCreateDateNight(_ sender: UIButton) {
        dateNightView.isHidden = false
    }

    @IBAction func btnActionHideDateNightView(_ sender: Any) {
        dateNightView.isHidden = true
    }

    @IBAction func btnActionCustomDateNight(_ sender: Any) {
        dateNightView.isHidden = true
        let vc = UIStoryboard(name: "DatingJourney", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomDateNightViewController") as! CustomDateNightViewController
        vc.groupId = self.journey?.groupId ?? 0
        vc.partnerId = self.journey?.dating_partner_id ?? 0
        vc.weekId = self.journeyModel?.journeyHome[0].weekId ?? 1
        vc.topicId = self.journeyModel?.journeyHome[0].topicId ?? 1

        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActionCalendar(_ sender: UIButton) {
        let vc = UIStoryboard(name: "DatingJourney", bundle: Bundle.main).instantiateViewController(withIdentifier: "JourneyCalendarViewController") as! JourneyCalendarViewController
        vc.groupId = self.journey?.groupId ?? 0
        vc.partnerId = self.journey?.dating_partner_id ?? 0
        vc.weekId = self.journeyModel?.journeyHome[0].weekId ?? 1
        vc.topicId = self.journeyModel?.journeyHome[0].topicId ?? 1
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnAction30DaysPlan(_ sender: UIButton) {
        if journey?.ourStatus?.level?.lowercased() == "level 3" {
        }else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateLevel2InvitationViewController") as! CreateLevel2InvitationViewController
            vc.journey = journey
            vc.isCameForJourneyHomeScreen = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    @IBAction func btnActionBack(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateOurJournal(_ sender: UIButton) {
        if journey?.ourStatus?.level?.lowercased() == "level 2" {
            let vc = UIStoryboard(name: "DatingJourney", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateDatingJournalViewController") as! UpdateDatingJournalViewController
            vc.groupId = self.journey?.groupId ?? 0
            vc.partnerId = self.journey?.dating_partner_id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Level2DatingJourneySubscriptionVC") as! Level2DatingJourneySubscriptionVC
            vc.journey = self.journey
            vc.isCameFromSnapCrousal = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
