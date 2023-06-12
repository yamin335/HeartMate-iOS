//
//  EmailViewController.swift
//  iosbingo
//
//  Created by apple on 30/08/22.
//

import UIKit

class EmailViewController: UIViewController {

    @IBOutlet weak var btn_select: UIButton!
    @IBOutlet weak var txt_email: UITextField!
    
    var checked = false
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var profileData : UserExistsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .userData, castTo: UserExistsModel.self)
            print(profileData!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func btn_next(_ sender: UIButton) {
        if txt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            email = "\(AppUserDefault.shared.getValue(for: .mobileNumber))@tovalueme.com"
        }else if !(txt_email.text?.isEmail() ?? false){
            self.generateAlert(withMsg: "Please enter valid email address", otherBtnTitle: "OK") { refresh in
            }
        }else{
            email = txt_email.text ?? ""
        }
        //self.pushController(controllerName: "PasswordViewController", storyboardName: "Main")
        
        self.verifyEmail()
        
    }
    
    @IBAction func btn_select(_ sender: UIButton) {
        if(checked){
            btn_select.setImage(UIImage(named: "circle"), for: .normal)
            checked = false
        } else {
            btn_select.setImage(UIImage(named: "checked"), for: .normal)
            checked = true
        }
    }
    
    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName) as! BirthdayViewController
//        vc.firstName = self.firstName
//        vc.lastName = self.lastName
//        vc.email = self.email
        //vc.password = password
        vc.profileData = self.profileData
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName) as! PasswordViewController
//        vc.firstName = self.firstName
//        vc.lastName = self.lastName
//        vc.email = self.email
//        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension EmailViewController{
    
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
                      /*"user_pass":password,*/
                      "last_name": lastName,
                      "email": email,
                      "username":AppUserDefault.shared.getValue(for: .mobileNumber),
                      "display_name":firstName,
                      "nonce":nonce,
                      "reference": ""] as [String:Any]
        print(params)
        API.shared.sendData(url: APIPath.register, requestType: .post, params: params, objectType: RegistrationModel.self) { (data,status)  in
            if status {
                guard let registrationData = data else {return}
                print("token",registrationData.jwt ?? "")
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
    
    func updateEmail(){
        let params = ["user_email":txt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""] as [String:Any]
        print(params)
        API.shared.sendData(url: APIPath.updateProfile, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
            if status {
                self.generateAlert(withMsg: "User registered successfully", otherBtnTitle: "OK") { isPressedOkBtn in
                    self.pushController(controllerName: "BirthdayViewController", storyboardName: "Main")
                }
                //self.performSegue(withIdentifier: "notification", sender: self)
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }
    
    func verifyEmail(){
        let params = ["email" : txt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""] as [String:Any]
        print(params)
        API.shared.sendData(url: APIPath.emailExists, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
            if status {
                if self.profileData?.invitationCode?.count ?? 0 > 0{
                    self.updateEmail()
                }else{
                    self.getNonce()
                }
                //self.performSegue(withIdentifier: "notification", sender: self)
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    
}

