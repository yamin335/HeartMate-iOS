//
//  ConfirmedYesViewController.swift
//  iosbingo
//
//  Created by Gursewak singh on 26/10/22.
//

import UIKit

class ConfirmedYesViewController: UIViewController {

    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var img_user: UIImageView!
    
    var profileData : UserExistsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbl_name.text = "Your dating journey with \(profileData?.invitedBy ?? "") begins here"
        img_user.sd_setImage(with: URL(string: profileData?.inviterPicture ?? ""), placeholderImage: UIImage(named: "defaultProfile"))
        
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
