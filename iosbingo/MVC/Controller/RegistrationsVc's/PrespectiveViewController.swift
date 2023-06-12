//
//  PrespectiveViewController.swift
//  iosbingo
//
//  Created by Gursewak singh on 23/10/22.
//

import UIKit

class PrespectiveViewController: UIViewController {

    @IBOutlet weak var btn_value: UIButton!
    
    var firstName : String = ""
    var profileData : UserExistsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .userData, castTo: UserExistsModel.self)
            print(profileData!)
        } catch {
            print(error.localizedDescription)
        }
        
        // Do any additional setup after loading the view.
        self.btn_value.setTitle("See \(profileData?.invitedBy ?? "")'s Value", for: .normal)
    }
    
    @IBAction func btn_submitClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "acceptInvitation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "acceptInvitation"{
            if let vc = segue.destination as? AcceptInvitationCodeViewController{
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
