//
//  CustomDateNightViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 09/11/2022.
//

import UIKit

class CustomDateNightViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var txtFieldTitle: UITextField!
    @IBOutlet weak var txtFieldDescription: UITextField!
    @IBOutlet weak var txtFieldStartDateTime: UITextField!
    @IBOutlet weak var txtFieldEndDateTime: UITextField!
    @IBOutlet weak var txtFieldUrl: UITextField!
    @IBOutlet weak var txtFieldDestination: UITextField!

    let startTimeDatePicker = UIDatePicker()
    let endTimeDatePicker = UIDatePicker()
    var startDate = ""
    var startTime = ""
    var endDate = ""
    var endTime = ""
    var imagePicker: ImagePicker!
    var imageData : Data?
    var groupId = 0
    var partnerId = 0
    var topicId = 0
    var weekId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        txtFieldStartDateTime.setLeftPaddingPoints(10)
        txtFieldEndDateTime.setLeftPaddingPoints(10)
        txtFieldTitle.setLeftPaddingPoints(10)
        txtFieldDescription.setLeftPaddingPoints(10)
        txtFieldUrl.setLeftPaddingPoints(10)
        txtFieldDestination.setLeftPaddingPoints(10)
        txtFieldStartDateTime.text = stringFromDate(date: Date(), format: .advanceFullCalendar)
        txtFieldEndDateTime.text = stringFromDate(date: Date(), format: .advanceFullCalendar)
        startDate = stringFromDate(date: Date(), format: .short)
        startTime = stringFromDate(date: Date(), format: .time)
        endDate = stringFromDate(date: Date(), format: .short)
        endTime = stringFromDate(date: Date(), format: .time)
        showDatePicker()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    //MARK: - TextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFieldStartDateTime {
            return false
        }else if textField == txtFieldEndDateTime {
            return false
        }
        return true
    }

    //MARK: - CustomFunctions

    func showDatePicker(){

       //Formate Date
        startTimeDatePicker.datePickerMode = .dateAndTime
        endTimeDatePicker.datePickerMode = .dateAndTime


       if #available(iOS 13.4, *) {
           startTimeDatePicker.preferredDatePickerStyle = .wheels
           endTimeDatePicker.preferredDatePickerStyle = .wheels
       }

      //ToolBar
       let startTimetoolbar = UIToolbar();
        startTimetoolbar.sizeToFit()
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartdatePicker));
       let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
       let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        startTimetoolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        let endTimetoolbar = UIToolbar();
        endTimetoolbar.sizeToFit()
        let endDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEnddatePicker));
        let endSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let endCancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        endTimetoolbar.setItems([endDoneButton,endSpaceButton,endCancelButton], animated: false)

        txtFieldStartDateTime.inputAccessoryView = startTimetoolbar
        txtFieldStartDateTime.inputView = startTimeDatePicker

        txtFieldEndDateTime.inputAccessoryView = endTimetoolbar
        txtFieldEndDateTime.inputView = endTimeDatePicker
   }

    @objc func doneStartdatePicker(){
        startDate = stringFromDate(date: startTimeDatePicker.date, format: .short)
        startTime = stringFromDate(date: startTimeDatePicker.date, format: .time)
        txtFieldStartDateTime.text = stringFromDate(date: startTimeDatePicker.date, format: .advanceFullCalendar)
        self.view.endEditing(true)
    }

    @objc func doneEnddatePicker(){
        endDate = stringFromDate(date: endTimeDatePicker.date, format: .short)
        endTime = stringFromDate(date: endTimeDatePicker.date, format: .time)
        txtFieldEndDateTime.text = stringFromDate(date: endTimeDatePicker.date, format: .advanceFullCalendar)
        self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    func createOffer(){
        let (isValid,message) = fieldsValidation()
        if isValid{
            AppLoader.shared.show(currentView: self.view)
            API.shared.ValidateToken { isValid in
                if isValid {
                    let params = ["event_description":self.txtFieldDescription.text!, "date_night_id":4, "date_week_id":1, "inventory_topic":"career_goals", "partner_id":self.partnerId, "title":self.txtFieldTitle.text!, "event_address":self.txtFieldDestination.text!, "event_end_date":self.endDate, "event_start_date":self.startDate, "event_start_time":self.startTime, "event_end_time":self.endTime, "group_id":self.groupId, "url":self.txtFieldUrl.text!] as [String:Any]

                    if let image = self.imageData {
                        API.shared.sendMultiPartData(url: APIPath.offerDateNight, requestType: .post, params: params, objectType: EmptyModel.self, imageData: image, imageKey: "attachment") { (data, status) in
                            if status {
                                AppLoader.shared.hide()
                                self.generateAlert(withMsg: "Offer created successfully", otherBtnTitle: "Ok") { refresh in
                                    if refresh{
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }else{
                                AppLoader.shared.hide()
                                print("Error found")
                            }
                        }
                    }else{
                        API.shared.sendData(url: APIPath.offerDateNight, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                            if status {
                                self.generateAlert(withMsg: "Offer created successfully", otherBtnTitle: "Ok") { refresh in
                                    if refresh{
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
                    AppLoader.shared.hide()
                    removeUserPreference()
                    navigatetoLoginScreen()
                }
            }
        }else{
            self.showAlert(message: message, titled: "Alert")
        }

    }

    func fieldsValidation() -> (Bool,String){
        var message = ""
        var isValid = true
        if txtFieldTitle.text == "" {
            isValid = false
        }

        if txtFieldStartDateTime.text == "" {
            isValid = false

        }

        if txtFieldEndDateTime.text == "" {
            isValid = false

        }

        if txtFieldDescription.text == "" {
            isValid = false

        }

        if txtFieldDestination.text == "" {
            isValid = false

        }

        if !isValid{
            message = "Fields are mandatory"
        }

        return (isValid,message)
    }

    //MARK: - IBActions

    @IBAction func btnActionOpenPicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }

    @IBAction func btnActionSend(_ sender: Any) {
        createOffer()
    }

    @IBAction func btnActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CustomDateNightViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?, imageURL: String?) {
        if let img = image {
            self.imageData = self.imagePicker.convertImageToBase64String(img: img)
        }
    }

}
