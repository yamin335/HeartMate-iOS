//
//  PrimerVIViewController.swift
//  iosbingo
//
//  Created by Md. Yamin on 12/22/22.
//

import UIKit

class PrimerVIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnActionToValueMe(_ sender: UIButton) {
        if AppUserDefault.shared.getValueBool(for: .isUserRegistering) {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ToYourPartnerVC") as! ToYourPartnerVC
            self.navigationController?.pushViewController(vc, animated: true)
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
