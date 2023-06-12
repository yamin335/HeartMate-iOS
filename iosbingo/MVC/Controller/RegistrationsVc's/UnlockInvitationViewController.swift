//
//  UnlockInvitationViewController.swift
//  iosbingo
//
//  Created by Gursewak singh on 23/10/22.
//

import UIKit

class UnlockInvitationViewController: UIViewController {

    var profileData : UserExistsModel?
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
    @IBOutlet weak var text_weekdays: UITextField!
    @IBOutlet weak var text_year: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .userData, castTo: UserExistsModel.self)
            print(profileData!)
        } catch {
            print(error.localizedDescription)
        }
        
        // Do any additional setup after loading the view.
        lbl_title.text = "Unlock \(profileData?.invitedBy ?? "")’s  Value"
        lbl_subTitle.text = "If you had 2 dates & other experiences per week with \(profileData?.invitedBy ?? "") - how many experiences would that be per year?"
    }
    
    @IBAction func btn_submitClicked(_ sender: Any) {
        if(text_weekdays.text != "52"){
            self.generateAlert(withMsg: "your first answer is wrong", otherBtnTitle: "OK") { refresh in
            }
        }else if(text_year.text != "104"){
            self.generateAlert(withMsg: "your second answer is wrong", otherBtnTitle: "OK") { refresh in
            }
        }else{
            self.performSegue(withIdentifier: "prespective", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ""{
            if let vc = segue.destination as? PrespectiveViewController{
                vc.profileData = self.profileData
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

}
