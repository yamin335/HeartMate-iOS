//
//  ViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 19/07/2022.
//

import UIKit

class LoginController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var forgetView: UIView!
    @IBOutlet weak var txtFieldForgot: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        forgetView.isHidden = true
    }

    //MARK: - Custom Functions

    func login(){
        AppLoader.shared.show(currentView: self.view)
        let params = ["email":txtFieldEmail.text!,"password":txtFieldPassword.text!,"key":key] as [String:Any]
        API.shared.sendData(url: APIPath.login, requestType: .post, params: params, objectType: LoginModel.self) { (loginData,status)  in
            if status {
                guard loginData != nil else {return}
                AppUserDefault.shared.set(value: loginData?.user?.id ?? 0, for: .UserID)
                AppUserDefault.shared.set(value: loginData?.cookie ?? "", for: .Cookie)
                AppUserDefault.shared.set(value: 1, for: .IsLoggedIn)
                AppLoader.shared.hideWithHandler { isComplete in
                    if isComplete{
                        let nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                        UIApplication.shared.windows.first?.rootViewController = nav
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    }
                }

            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    func forgotPassword(){
        AppLoader.shared.show(currentView: self.view)
        let params = ["user_login":txtFieldForgot.text!] as [String:Any]
        API.shared.sendData(url: APIPath.forgotPassword, requestType: .post, params: params, objectType: FogotModel.self, isTokenRequired: false) { (forgotData,status)  in
            if status {
                guard forgotData != nil else {return}
                AppLoader.shared.hide()
                self.generateAlert(withMsg: forgotData?.msg ?? "Link for password reset has been emailed to you. Please check your email.", otherBtnTitle: "OK") { refresh in
                    self.txtFieldForgot.text = ""
                    self.forgetView.isHidden = true
                }
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    //MARK: - Validations

    func loginFieldsValidation() -> (Bool,String){

        var validationPass = true
        var message = ""
        if txtFieldEmail.text == "" {
            message = "Fields are mandatory"
            validationPass = false
        }else if !txtFieldEmail.isEmail() {
            validationPass = false
            message = "Email should be a valid"
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

    func forgotFieldsValidation() -> (Bool,String){

        var validationPass = true
        var message = ""

        if txtFieldForgot.text == "" {
            message = "Field is mandatory"
            validationPass = false
        }else if !txtFieldForgot.isEmail() {
            validationPass = false
            message = "Eamil should be a valid"
        }

        return (validationPass,message)
    }

    //MARK: - Button Actions

    @IBAction func btnLoginAction(_ sender: Any) {
        let (isValid,validationMsg) = loginFieldsValidation()
        if !isValid {
            showAlert(message: validationMsg, titled: "Error")
        }else{
            login()
        }
    }

    @IBAction func btnConfirm(_ sender: Any) {
        let (isValid,validationMsg) = forgotFieldsValidation()
        if !isValid {
            showAlert(message: validationMsg, titled: "Error")
        }else{
            forgotPassword()
        }
    }

    @IBAction func btnCancel(_ sender: Any) {
        forgetView.isHidden = true
    }

    @IBAction func btnForget(_ sender: Any) {
        forgetView.isHidden = false
    }


}

