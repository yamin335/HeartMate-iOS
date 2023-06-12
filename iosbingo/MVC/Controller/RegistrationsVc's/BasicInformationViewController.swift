//
//  BasicInformationViewController.swift
//  iosbingo
//
//  Created by Gursewak singh on 21/10/22.
//

import UIKit

class BasicInformationViewController: UIViewController {

    var profileData : UserExistsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            self.profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .userData, castTo: UserExistsModel.self)
            print(self.profileData!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func btn_nextClicked(_ sender: Any) {
        self.pushController(controllerName: "NameViewController", storyboardName: "Main")
    }
    
    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName) as! NameViewController
        vc.profileData = self.profileData
        self.navigationController?.pushViewController(vc, animated: true)
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
