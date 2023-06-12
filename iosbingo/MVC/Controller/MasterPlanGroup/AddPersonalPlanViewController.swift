//
//  AddPersonalPlanViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 25/09/2022.
//

import UIKit

class AddPersonalPlanViewController: UIViewController,UITextFieldDelegate {

    //MARK: - IBOutlets

    @IBOutlet weak var txtFieldTitle: UITextField!
    @IBOutlet weak var txtFieldStartTime: UITextField!
    @IBOutlet weak var txtFieldEndTime: UITextField!

    let startTimeDatePicker = UIDatePicker()
    let endTimeDatePicker = UIDatePicker()
    var startDate = ""
    var endDate = ""
    var startTime = ""
    var endTime = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        txtFieldTitle.setLeftPaddingPoints(10)
        txtFieldStartTime.setLeftPaddingPoints(10)
        txtFieldEndTime.setLeftPaddingPoints(10)
        txtFieldStartTime.text = stringFromDate(date: Date(), format: .advanceFullCalendar)
        txtFieldEndTime.text = stringFromDate(date: Date(), format: .advanceFullCalendar)
        startDate = stringFromDate(date: Date(), format: .short)
        startTime = stringFromDate(date: Date(), format: .time)
        endDate = stringFromDate(date: Date(), format: .short)
        endTime = stringFromDate(date: Date(), format: .time)
        showDatePicker()

    }

    //MARK: - TextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFieldStartTime {
            return false
        }else if textField == txtFieldEndTime {
            return false
        }
        return true
    }

    //MARK: - Custom Functions

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

        txtFieldStartTime.inputAccessoryView = startTimetoolbar
        txtFieldStartTime.inputView = startTimeDatePicker

        txtFieldEndTime.inputAccessoryView = endTimetoolbar
        txtFieldEndTime.inputView = endTimeDatePicker
   }

    @objc func doneStartdatePicker(){
        startDate = stringFromDate(date: startTimeDatePicker.date, format: .short)
        startTime = stringFromDate(date: startTimeDatePicker.date, format: .time)
        txtFieldStartTime.text = stringFromDate(date: startTimeDatePicker.date, format: .advanceFullCalendar)
        self.view.endEditing(true)
    }

    @objc func doneEnddatePicker(){
        endDate = stringFromDate(date: endTimeDatePicker.date, format: .short)
        endTime = stringFromDate(date: endTimeDatePicker.date, format: .time)
        txtFieldEndTime.text = stringFromDate(date: endTimeDatePicker.date, format: .advanceFullCalendar)
        self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    func scheduleMeTime(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = ["event_start_date":self.startDate,"event_start_time":self.startTime,"event_end_date":self.endDate,"event_end_time":self.endTime] as [String:Any]
                API.shared.sendData(url: APIPath.scheduleMeTime, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                    if status {
                        AppLoader.shared.hide()
                        self.generateAlert(withMsg: "Successfully blocked out your 'Me Time', your dating partners will NOT be able to offer date nights during your 'Me Time'.", otherBtnTitle: "Ok") { refresh in
                            if refresh{
                                self.tabBarController?.tabBar.isHidden = false
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else{
                        AppLoader.shared.hide()
                        print("Error found")
                    }
                }
            }else{
                AppLoader.shared.hideWithHandler(completion: { isDone in
                    if isDone{
                        removeUserPreference()
                        navigatetoLoginScreen()
                    }
                })
            }
        }
    }

    //MARK: - Button Actions

    @IBAction func btnActionSend(_ sender: Any) {
        self.scheduleMeTime()
    }

    @IBAction func btnActionBack(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

}
