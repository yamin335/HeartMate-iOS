//
//  NotificationSettingsViewController.swift
//  iosbingo
//
//  Created by apple on 30/08/22.
//

import UIKit
import DropDown

class NotificationSettingsViewController: UIViewController {

    @IBOutlet weak var btn_enableNotification: UIButton!
    @IBOutlet weak var btn_disableNotification: UIButton!
    
    var profileData : UserExistsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .userData, castTo: UserExistsModel.self)
            print(profileData!)
        } catch {
            print(error.localizedDescription)
        }
    }
    

    @IBAction func btn_next(_ sender: Any) {
        if profileData?.invitationCode?.count ?? 0 > 0{
            self.performSegue(withIdentifier: "invitation", sender: self)
        }else{
            self.performSegue(withIdentifier: "uploadImage", sender: self)
        }
    }
    
    @IBAction func btn_enableNotification(_ sender: Any) {
        btn_enableNotification.backgroundColor = UIColor(red: 129/255, green: 205/255, blue: 217/255, alpha: 1.0)
        btn_disableNotification.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        sendNotificationData(status: true)
    }
    
    @IBAction func btn_disableNotification(_ sender: Any) {
        btn_disableNotification.backgroundColor = UIColor(red: 129/255, green: 205/255, blue: 217/255, alpha: 1.0)
        btn_enableNotification.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        sendNotificationData(status: false)
    }
    
    func sendNotificationData(status : Bool){
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = ["push_mood_ring":status ? "1" : "0", "all_push_notifications":status ? "1" : "0", "push_new_discoveries":status ? "1" : "0", "push_new_invitations":status ? "1" : "0", "push_promotions":status ? "1" : "0", "push_announcements":status ? "1" : "0"] as [String:Any]
                API.shared.backgroundSendData(url: APIPath.updateUserMetaVar, requestType: .post, params: params)
            }else{
                self.generateAlert(withMsg: "Session expired", otherBtnTitle: "Ok") { refresh in
                    removeUserPreference()
                    navigatetoLoginScreen()
                }
            }
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "invitation"{
            if let vc = segue.destination as? UnlockInvitationViewController{
                vc.profileData = self.profileData
            }
        }
    }
}
