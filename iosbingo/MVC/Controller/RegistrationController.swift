//
//  RegistrationController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 19/07/2022.
//

import UIKit

class RegistrationController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!

    var registrationModel : RegistrationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Custom Functions

    func getNonce(){
        AppLoader.shared.show(currentView: self.view)
        let params = ["json":"get_nonce","controller":"userplus","method":"register"] as [String:Any]
        API.shared.sendData(url: APIPath.nonce, requestType: .post, params: params, objectType: NonceModel.self) { (data,status)  in
            if status {
                guard let nonceData = data else {return}
                print("Nonce method is",nonceData.method ?? "")
                self.register(nonce: nonceData.nonce ?? "")
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    func register(nonce:String){
        /*let params = ["first_name":txtFieldFirstName.text!,"user_pass":txtFieldPassword.text!,"last_name":txtFieldLastName.text!,"email":txtFieldEmail.text!,"username":"\(txtFieldFirstName.text!)_\(txtFieldLastName.text!)","display_name":txtFieldLastName.text!,"nonce":nonce] as [String:Any]
        API.shared.sendData(url: APIPath.register, requestType: .post, params: params, objectType: RegistrationModel.self, isTokenRequired: false) { (data,status)  in
            if status {
                guard let registrationData = data else {return}
                print("UserID is",registrationData.userID ?? "")
                AppLoader.shared.hide()
                self.generateAlert(withMsg: "User registered successfully", otherBtnTitle: "OK") { isPressedOkBtn in
                    if isPressedOkBtn {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
         */
    }

    //MARK: - Validations

    func registrationFieldsValidation() -> (Bool,String){

        var validationPass = true
        var message = ""

        if txtFieldFirstName.text == "" {
            message = "Fields are mandatory"
            validationPass = false
        }

        if txtFieldLastName.text == "" {
            message = "Fields are mandatory"
            validationPass = false
        }

        if txtFieldEmail.text == "" {
            message = "Fields are mandatory"
            validationPass = false
        }else if !txtFieldEmail.isEmail() {
            validationPass = false
            message = "Eamil should be a valid"
        }

        if txtFieldPassword.text == "" {
            message = "Fields are mandatory"
            validationPass = false
        }else if txtFieldPassword.text!.count < 8 {
            validationPass = false
            message = "Password length at least should be 8 characters"

        }

        return (validationPass,message)
    }

    //MARK: - Button Actions

    @IBAction func btnActionLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActionRegistration(_ sender: Any) {
        let (isValid,validationMsg) = registrationFieldsValidation()
        if !isValid {
            showAlert(message: validationMsg, titled: "Error")
        }else{
            getNonce()
        }
    }


}
