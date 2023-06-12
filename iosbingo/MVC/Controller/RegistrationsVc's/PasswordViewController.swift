//
//  PasswordViewController.swift
//  iosbingo
//
//  Created by apple on 30/08/22.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_confirmPassword: UITextField!
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var password = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func btn_next(_ sender: Any) {
        if(txt_password.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 && txt_confirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0){
            self.password = "auto_generated"
        }else if txt_password.text != txt_confirmPassword.text{
            self.generateAlert(withMsg: "Password not matched", otherBtnTitle: "OK") { refresh in
            }
            return
        }else{
            self.password = txt_password.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
        
        getNonce()
    }
    
    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName) as! BirthdayViewController
//        vc.firstName = self.firstName
//        vc.lastName = self.lastName
//        vc.email = self.email
//        vc.password = password
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension PasswordViewController{
    
    //MARK: - Custom Functions
    func getNonce(){
        AppLoader.shared.show(currentView: self.view)
        let params = ["json":"get_nonce","controller":"userplus","method":"register"] as [String:Any]
        API.shared.sendData(url: APIPath.nonce, requestType: .get, params: params, objectType: NonceModel.self) { (data,status)  in
            if status {
                guard let nonceData = data else {return}
                self.register(nonce: nonceData.nonce ?? "")
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }
    
    func register(nonce:String){
        let params = ["first_name": firstName,
                      "user_pass":password,
                      "last_name": lastName,
                      "email": email,
                      "username":AppUserDefault.shared.getValue(for: .mobileNumber),
                      "display_name":firstName,
                      "nonce":nonce,
                      "reference": ""] as [String:Any]
        print(params)
        API.shared.sendData(url: APIPath.register, requestType: .post, params: params, objectType: RegistrationModel.self, isTokenRequired: false) { (data,status)  in
            if status {
                guard let registrationData = data else {return}
                AppUserDefault.shared.set(value: registrationData.userID ?? 0, for: .UserID)
                AppUserDefault.shared.set(value: registrationData.jwt ?? "", for: .Token)
                AppUserDefault.shared.set(value: 1, for: .IsLoggedIn)
                AppLoader.shared.hide()
                self.generateAlert(withMsg: "User registered successfully", otherBtnTitle: "OK") { isPressedOkBtn in
                        self.pushController(controllerName: "BirthdayViewController", storyboardName: "Main")
                }
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }
    
}
