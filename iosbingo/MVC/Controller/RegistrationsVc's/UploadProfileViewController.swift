//
//  UploadProfileViewController.swift
//  iosbingo
//
//  Created by apple on 30/08/22.
//

import UIKit
import AVFoundation
import MobileCoreServices

protocol UploadProfileImg {
    func updateUserProfileImage(img:UIImage)
    func updateUserProfileModel(profile:ProfileModel)
}

class UploadProfileViewController: UIViewController {

    @IBOutlet weak var img_profile: UIImageView!
    
    var currentImage : UIImage?
    var delegate : UploadProfileImg?
    var imagePicker: ImagePicker!
    var imageData : Data?
    var profileData:ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Unity.shared.profileData = profileData
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.uploadImage))
        self.img_profile.isUserInteractionEnabled = true
        self.img_profile.addGestureRecognizer(tap)
        
       
    }
    
    @IBAction func btn_next(_ sender: Any) {
        self.pushController(controllerName: "LocationSettingsViewController", storyboardName: "Main")
    }
    
    
    @IBAction func btn_uploadImage(_ sender: Any) {
        self.imagePicker.present(from:self.view)
    }
 
    @objc func uploadImage(_ sender: UITapGestureRecognizer) {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
//            self.FromCamera()
//        }))
//        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default , handler:{ (UIAlertAction)in
//            self.FromGallery()
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
//        }))
//        
//        self.present(alert, animated: true, completion: {
//            print("completion block")
//        })
    }
    
    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName)
        self.navigationController?.pushViewController(vc, animated: true)
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

   
}

extension UploadProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?, imageURL: String?) {
        if let img = image {
            self.delegate?.updateUserProfileImage(img: img)
            self.img_profile.image = img
            self.imageData = self.imagePicker.convertImageToBase64String(img: img)
            print(self.imageData)
            uploadProfileImg(image: self.imageData!)
        }
    }

}

extension UploadProfileViewController: UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        
    func FromGallery() -> Void {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let Picker = UIImagePickerController()
            Picker.delegate = self
            Picker.sourceType = .photoLibrary
            Picker.modalPresentationStyle = .overFullScreen
            UIApplication.shared.keyWindow?.rootViewController?.present(Picker, animated: true, completion: nil)
            Picker.allowsEditing = true
            Picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        }
        
    }
    
    func FromCamera() -> Void {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                
                let Picker = UIImagePickerController()
                Picker.delegate = self
                Picker.sourceType = .camera
                Picker.mediaTypes = [kUTTypeImage as String]
                Picker.modalPresentationStyle = .overFullScreen
                UIApplication.shared.keyWindow?.rootViewController?.present(Picker, animated: true, completion: nil)
                Picker.allowsEditing = true
                Picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        //access allowed
                        
                        let Picker = UIImagePickerController()
                        Picker.delegate = self
                        Picker.sourceType = .camera
                        Picker.mediaTypes = [kUTTypeImage as String]
                        Picker.modalPresentationStyle = .overFullScreen
                        UIApplication.shared.keyWindow?.rootViewController?.present(Picker, animated: true, completion: nil)
                        Picker.allowsEditing = true
                        Picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                        
                    } else {
                        //access denied
                        let alert = UIAlertController(
                            title: "IMPORTANT",
                            message: "Camera access required for capturing photos!",
                            preferredStyle: UIAlertController.Style.alert
                        )
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
                            //UIApplication.shared.openURL(URL(string: UIApplication.UIApplicationOpenSettingsURLString)!)
                            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                        }))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                        
                    }
                })
            }
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//           self.btn_addImage.setImage(pickedImage, for: .normal)
            self.img_profile.image = pickedImage
            
            }
        if let url = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.imageURL.rawValue)] as? URL {
                print(url.lastPathComponent)
//            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//                AFWrapper.uploadImage(image: pickedImage) { (imageUrl, status, message) in
//                    if(status){
//                        print(imageUrl)
//                    }else{
//                        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertController.Style.alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                    }
//
//                } failure: { (error) in
//                    let alert = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                }
//
//            }

        }else{
            let alert = UIAlertController(title: "Oops!", message: "Please select valid image", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
       
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 0.1)?.base64EncodedString() ?? ""
    }
    
}
