//
//  OtpViewController.swift
//  iosbingo
//
//  Created by apple on 30/08/22.
//

import UIKit
import FirebaseAuth

class OtpViewController: UIViewController {
    
    @IBOutlet var text_Field: [UITextField]!
    @IBOutlet weak var lbl_number: UILabel!
    
    var number = ""
    var verificationCode = ""
    var profileData : UserExistsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbl_number.text! = "Sent to" + " " + self.number
    }
    
    @IBAction func btn_next(_ sender: Any) {
        if (getOTP().isEmpty) {
            self.generateAlert(withMsg: "Please enter valid otp", otherBtnTitle: "Try Again") { refresh in
            }
        } else {
            verifyMobileNumber()
        }
    }
    
    func verifyMobileNumber(){
		let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationCode,
																 verificationCode: getOTP())
		Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                do {
                    try  Auth.auth().signOut()
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
				AppUserDefault.shared.set(value: self.number, for: .mobileNumber)
				self.checkUserExists()
//                self.generateAlert(withMsg: error.localizedDescription, otherBtnTitle: "OK") { refresh in
//                }
            }else{
                AppUserDefault.shared.set(value: self.number, for: .mobileNumber)
                self.checkUserExists()
            }
        }
    }
    
    func checkUserExists(){
        let params = ["username":AppUserDefault.shared.getValue(for: .mobileNumber), "cache":randomString(length: 32)] as [String:Any]
        print(params)
        API.shared.sendData(url: APIPath.usernameExists, requestType: .post, params: params, objectType: UserExistsModel.self, isTokenRequired: false) { (data,status)  in
            if status {
                guard let UserData = data else {return}
                self.profileData = UserData
                do {
                    try AppUserDefault.shared.sharedObj.setObject(UserData, forKey: .userData)
                } catch {
                    print(error.localizedDescription)
                }
                if UserData.msg == "\(AppUserDefault.shared.getValue(for: .mobileNumber)) is available for registration."{
                    AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                    self.performSegue(withIdentifier: "verified", sender: self)
                }else{
                    do {
                        print("token",UserData.jwt)
                        
                        let decodedData = try decode(jwtToken: UserData.jwt!)
                        let userObj = decodedData["user"] as! [String:Any]
                        print(userObj["id"] as! Int)
                        
                        AppUserDefault.shared.set(value: userObj["id"] as? Int ?? 0, for: .UserID)
                        AppUserDefault.shared.set(value: UserData.jwt ?? "", for: .Token)
                        
                        AppLoader.shared.hideWithHandler { isComplete in
                            if isComplete{
                                //                                let nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                                //                                UIApplication.shared.windows.first?.rootViewController = nav
                                //                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                                
                                var nav : UIViewController?
                                if(self.profileData?.registrationStatus == ""){

                                    AppUserDefault.shared.set(value: 1, for: .IsLoggedIn)
                                    nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController

                                   AppUserDefault.shared.set(value: 1, for: .IsLoggedIn)
                                   nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController

                                }else if(self.profileData?.registrationStatus == "name"){
                                    AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                                    nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicInformationViewController") as! BasicInformationViewController
                                }else if(self.profileData?.registrationStatus == "email"){
                                    AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                                    nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
                                }else if(self.profileData?.registrationStatus == "birthday"){
                                    AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                                    nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BirthdayViewController") as! BirthdayViewController
                                }else if(self.profileData?.registrationStatus == "notification"){
                                    AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                                    nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationSettingsViewController") as! NotificationSettingsViewController
                                }else if(self.profileData?.registrationStatus == "photo"){
                                    AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                                    nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UploadProfileViewController") as! UploadProfileViewController
                                }else if(self.profileData?.registrationStatus == "location"){
                                    AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                                    nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LocationSettingsViewController") as! LocationSettingsViewController
                                }else if(self.profileData?.registrationStatus == "availability"){
                                    AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                                    nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DatingAvailabilityViewController") as! DatingAvailabilityViewController
                                    
                                } else if (self.profileData?.registrationStatus == "radar") {
                                    AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                                    nav = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ToValueMeReportViewController") as! ToValueMeReportViewController
                                } else if (self.profileData?.registrationStatus == "catalog"){
                                    AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                                    nav = UIStoryboard(name: "Dating", bundle: nil).instantiateViewController(identifier: "DateNightCatelogCoverViewController") as! DateNightCatelogCoverViewController
                                    
                                } else {
                                    
                                    
                                    AppUserDefault.shared.set(value: false, for: .isUserRegistering)
                                    AppUserDefault.shared.set(value: 1, for: .IsLoggedIn)
                                    nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                                }
                                let navViewController = UINavigationController(rootViewController: nav ?? UIViewController())
                                navViewController.isNavigationBarHidden = true
                                UIApplication.shared.windows.first?.rootViewController = nav
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                            }
                        }
                    }catch let err{
                        print("Decode error",err)
                    }
                }
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }
    
    
    @IBAction func btn_edit(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getOTP() -> String {
        var OTP = ""
        for textField in self.text_Field{
            OTP += textField.text ?? ""
        }
        return OTP
    }
    
}

extension OtpViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verified"{
            if let vc = segue.destination as? BasicInformationViewController{
                vc.profileData = self.profileData
            }
            
        }
    }
}

extension OtpViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text!.count < 1 && string.count > 0 {
            let tag = textField.tag + 1;
            let nextResponder = view.viewWithTag(tag)
            
            if   (nextResponder != nil){
                textField.resignFirstResponder()
                
            }
            textField.text = string;
            if (nextResponder != nil){
                nextResponder?.becomeFirstResponder()
                
            }
            return false;
            
            
        }else if (textField.text?.count)! >= 1 && string.count == 0 {
            let prevTag = textField.tag - 1
            let prevResponser = view.viewWithTag(prevTag)
            if (prevResponser != nil){
                textField.resignFirstResponder()
            }
            textField.text = string
            if (prevResponser != nil){
                prevResponser?.becomeFirstResponder()
                
            }
            return false
        }
        
        let maxLength = 1
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
    }
}
