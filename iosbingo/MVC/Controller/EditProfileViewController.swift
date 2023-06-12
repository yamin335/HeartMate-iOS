//
//  ProfileViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 22/07/2022.
//

import UIKit
import SDWebImage

protocol UpdateProfileImg {
    func updateUserProfileImage(img:UIImage)
    func updateUserProfileModel(profile:ProfileModel)
}



class EditProfileViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldUpdatePassword: UITextField!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var imgUserProfile: UIImageView!

    var currentImage : UIImage?
    var delegate : UpdateProfileImg?
    var currentLastName = ""
    var imageData : Data?
    var profileData:ProfileModel?
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        if isPremium {
            helpView.isHidden = true
        }
        if let img = currentImage {
            imgUserProfile.image = img
        }else{
            imgUserProfile.sd_setImage(with: URL(string: (profileData?.avatar) ?? ""), placeholderImage: UIImage(named: "defaultProfile"))
        }
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        if profileData?.lastname != "" {
            txtFieldLastName.text = profileData?.lastname
            currentLastName = (profileData?.lastname) ?? ""
        }
    }
    
    //MARK: - Custom Fuctions

    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 0.7)?.base64EncodedString() ?? ""
    }

    func updateProfile(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid {
                let (lastNameValidation,updatePassValidaton) = self.fieldValidation()
                if lastNameValidation || updatePassValidaton{
                    var params : [String:Any]?
                    if self.txtFieldLastName.text != "" && self.txtFieldUpdatePassword.text != "" {
                        params = ["last_name":self.txtFieldLastName.text!,"password":self.txtFieldUpdatePassword.text!] as [String:Any]

                    }else if self.txtFieldUpdatePassword.text != "" {
                        params = ["password":self.txtFieldUpdatePassword.text!] as [String:Any]

                    }else if self.txtFieldLastName.text != ""{
                        params = ["last_name":self.txtFieldLastName.text!,"password":self.txtFieldUpdatePassword.text!] as [String:Any]
                    }
                    API.shared.sendData(url: APIPath.updateProfile, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                        if status {
                            AppLoader.shared.hideWithHandler { isComplete in
                                if isComplete {
                                    if self.txtFieldLastName.text != "" && self.txtFieldLastName.text != self.currentLastName{
                                        self.profileData?.lastname = self.txtFieldLastName.text!
                                        self.delegate?.updateUserProfileModel(profile: self.profileData!)
                                    }
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }else{
                            AppLoader.shared.hide()
                            print("Error found")
                        }
                    }
                }
            }else{
                AppLoader.shared.hideWithHandler { isComplete in
                    if isComplete {
                        removeUserPreference()
                        navigatetoLoginScreen()
                    }
                }
            }
        }
    }

    func uploadProfileImg(image:Data){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid {
                let cache = randomString(length: 32)
                let param = ["cache":cache]
                API.shared.sendMultiPartData(url: APIPath.uploadProfile, requestType: .post, params: param, objectType: UploadProfileModel.self, imageData: image) { (data, status) in
                    if status {
                        guard data != nil else {return}
                        AppLoader.shared.hide()
                        self.showAlert(message: "Profile image has uploaded successfully", titled: "")
                    }else{
                        AppLoader.shared.hide()
                        print("Error found")
                    }
                }
            }else{
                AppLoader.shared.hide()
                removeUserPreference()
                navigatetoLoginScreen()
            }
        }
    }

    func fieldValidation() -> (Bool,Bool){
        var validationLastNamePass = true
        var validationUpdatePassword = true

        if txtFieldLastName.text == "" {
            validationLastNamePass = false
        }else if txtFieldLastName.text == currentLastName{
            validationLastNamePass = false

        }

        if txtFieldUpdatePassword.text == "" {
            validationUpdatePassword = false
        }else if txtFieldUpdatePassword.text!.count < 8 {
            validationUpdatePassword = false
        }

        return (validationLastNamePass,validationUpdatePassword)
    }

    //MARK: - Button Actions

    @IBAction func btnActionOpenPicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }

    @IBAction func btnActionLearnMore(_ sender: UIButton) {
        pushController(controllerName: "MembershipController", storyboardName: "Main")
    }

    @IBAction func btnActionBack(_ sender: UIButton) {
        let (lastNameValidation,updatePassValidaton) = fieldValidation()
        if !lastNameValidation && !updatePassValidaton{
            self.navigationController?.popViewController(animated: true)
        }else{
            updateProfile()
        }
    }

}

extension EditProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?, imageURL: String?) {
        if let img = image {
            self.delegate?.updateUserProfileImage(img: img)
            self.imgUserProfile.image = img
            self.imageData = self.imagePicker.convertImageToBase64String(img: img)
            uploadProfileImg(image: self.imageData!)
        }
    }

}

