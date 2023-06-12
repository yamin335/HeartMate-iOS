//
//  NameViewController.swift
//  iosbingo
//
//  Created by apple on 30/08/22.
//

import UIKit

class NameViewController: UIViewController {

    @IBOutlet weak var txt_firstName: UITextField!
    @IBOutlet weak var txt_lastName: UITextField!
    
    var profileData : UserExistsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //AppUserDefault.shared.set(value: "16505555153", for: .mobileNumber)
        do {
            profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .userData, castTo: UserExistsModel.self)
            print(profileData!)
        } catch {
            print(error.localizedDescription)
        }
        print(profileData)
    }
    
    @IBAction func next(_ sender: Any) {
        if isValid(testStr: txt_firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""){
            if profileData?.invitationCode?.count ?? 0 > 0{
//                if isValid(testStr: txt_lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""){
//                    self.updateLastName()
//                }
                self.updateFirstName()
            }else{
                self.pushController(controllerName: "EmailViewController", storyboardName: "Main")
            }
        }else{
            self.generateAlert(withMsg: "Please enter valid first name", otherBtnTitle: "OK") { refresh in
            }
        }
    }
    
    func updateFirstName(){
        
        let params = ["first_name":txt_firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", "last_name" : txt_lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""] as [String:Any]
        print(params)
        API.shared.sendData(url: APIPath.updateProfile, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
            if status {
                self.generateAlert(withMsg: "User registered successfully", otherBtnTitle: "OK") { isPressedOkBtn in
                    self.pushController(controllerName: "EmailViewController", storyboardName: "Main")
                }
                //self.performSegue(withIdentifier: "notification", sender: self)
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
        
//        let params = ["meta_key" : "first_name",
//                      "meta_value" : txt_firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""] as [String:Any]
//        print(params)
//        API.shared.sendData(url: APIPath.updateUserMetaVar, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
//            if status {
//                //guard let nameData = data else {return}
//                //print(nameData)
//                self.pushController(controllerName: "EmailViewController", storyboardName: "Main")
//                //self.performSegue(withIdentifier: "notification", sender: self)
//            }else{
//                AppLoader.shared.hide()
//                print("Error found")
//            }
//        }
    }
    
    func updateLastName(){
        let params = ["meta_key" : "last_name",
                      "meta_value" : txt_lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""] as [String:Any]
        print(params)
        API.shared.sendData(url: APIPath.updateUserMetaVar, requestType: .post, params: params, objectType: BirthdayModel.self) { (data,status)  in
            if status {
                //guard let nameData = data else {return}
                //print(nameData)
                //self.pushController(controllerName: "EmailViewController", storyboardName: "Main")
                //self.performSegue(withIdentifier: "notification", sender: self)
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }
    
    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName) as! EmailViewController
        vc.firstName = txt_firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        vc.lastName = txt_lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        vc.profileData = self.profileData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func isValid(testStr:String) -> Bool {
        guard testStr.count > 2, testStr.count < 18 else { return false }

        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: testStr)
    }

}
