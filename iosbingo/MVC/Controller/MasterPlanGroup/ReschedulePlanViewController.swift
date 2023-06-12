//
//  ReschedulePlanViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 25/09/2022.
//

import UIKit

class ReschedulePlanViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var txtFieldStartTime: UITextField!
    @IBOutlet weak var txtFieldEndTime: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblLink: UILabel!
    @IBOutlet weak var lblLocation: UILabel!

    var upcomingModel : UpcomingEventModel?
    var dateNightOfferModel : GetDateNightOfferModel?
    let startTimeDatePicker = UIDatePicker()
    let endTimeDatePicker = UIDatePicker()
    var bookingId = 0
    var startDate = ""
    var type = ""
    var startTime = ""
    var endDate = ""
    var endTime = ""
    var isDatingJourneyModule = false
    var isComingFromNotificationScreen = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        txtFieldStartTime.setLeftPaddingPoints(10)
        txtFieldEndTime.setLeftPaddingPoints(10)
        showDatePicker()

        if isComingFromNotificationScreen {
            getEventDetail()
        }else{
            updateUI()
        }

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

    func getEventDetail(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let cache = randomString(length: 32)
                let param = ["event_id":self.bookingId,"cache":cache] as [String:Any]
                API.shared.sendData(url: APIPath.upcomingEvent, requestType: .post, params: param, objectType: UpcomingEventModel.self) { (data,status)  in
                    if status {
                        guard let eventData = data else {
                            AppLoader.shared.hide()
                            return
                        }
                        self.upcomingModel = eventData
                        self.updateUI()
                        AppLoader.shared.hide()
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

    func submitDateNightOfferDecision(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let param = ["date_night_offer_id":self.bookingId,"decision":3,"event_start_date":self.startDate,"event_start_time":self.startTime,"event_end_date":self.endDate,"event_end_time":self.endTime] as [String:Any]
                API.shared.sendData(url: APIPath.submitDateNightOfferDecision, requestType: .post, params: param, objectType: EmptyModel.self) { (data,status)  in
                    if status {
                        AppLoader.shared.hideWithHandler(completion: { isDone in
                            if isDone{
                                self.generateAlert(withMsg: "Rescheduled Successfully", otherBtnTitle: "Ok") { isPressed in
                                    if isPressed{
                                        if self.isDatingJourneyModule{
                                            for controller in self.navigationController!.viewControllers as Array {
                                                if controller.isKind(of: JourneyCalendarViewController.self) {
                                                    self.navigationController!.popToViewController(controller, animated: true)
                                                    break
                                                }
                                            }
                                        }else if self.isComingFromNotificationScreen{
                                            self.tabBarController?.tabBar.isHidden = false
                                            self.navigationController!.popViewController(animated: true)

                                        }else {
                                            self.tabBarController?.tabBar.isHidden = false
                                            self.navigationController?.popToRootViewController(animated: true)
                                        }
                                    }
                                }
                            }
                        })
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

    func acceptEvent(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let param = ["event_id":self.upcomingModel?.dateNightEvent.eventID ?? "", "event_start_date":self.startDate,"event_start_time":self.startTime,"event_end_date":self.endDate,"event_end_time":self.endTime] as [String:Any]
                API.shared.sendData(url: APIPath.acceptEvent, requestType: .post, params: param, objectType: EmptyModel.self) { (data,status)  in
                    if status {
                        AppLoader.shared.hideWithHandler(completion: { isDone in
                            if isDone{
                                self.generateAlert(withMsg: "Rescheduled Successfully", otherBtnTitle: "Ok") { isPressed in
                                    if isPressed{
                                        if self.isDatingJourneyModule{
                                            for controller in self.navigationController!.viewControllers as Array {
                                                if controller.isKind(of: JourneyCalendarViewController.self) {
                                                    self.navigationController!.popToViewController(controller, animated: true)
                                                    break
                                                }
                                            }
                                        }else if self.isComingFromNotificationScreen{
                                            self.tabBarController?.tabBar.isHidden = false
                                            self.navigationController!.popViewController(animated: true)

                                        }else{
                                            self.tabBarController?.tabBar.isHidden = false
                                            self.navigationController?.popToRootViewController(animated: true)
                                        }
                                    }
                                }
                            }
                        })
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

    func updateUI(){
        if type == "event" || type == "me_time" {
            txtFieldStartTime.text = stringFromDate(date: Date(), format: .advanceFullCalendar)
            txtFieldEndTime.text = stringFromDate(date: Date(), format: .advanceFullCalendar)
            lblTitle.text = upcomingModel?.dateNightEvent.eventTitle
            lblLocation.text = upcomingModel?.dateNightEvent.eventAddress
            lblLink.text = upcomingModel?.dateNightEvent.eventWebsite
            lblDescription.text = upcomingModel?.dateNightEvent.eventDescription
        }else{
            txtFieldStartTime.text = stringFromDate(date: Date(), format: .advanceFullCalendar)
            txtFieldEndTime.text = stringFromDate(date: Date(), format: .advanceFullCalendar)
            lblTitle.text = dateNightOfferModel?.dateNightOffer.dateNightTitle
            lblLocation.text = dateNightOfferModel?.dateNightOffer.location
            lblLink.text = dateNightOfferModel?.dateNightOffer.eventWebsite
            lblDescription.text = dateNightOfferModel?.dateNightOffer.dateNightDescription
        }

    }
    //MARK: - Button Actions

    @IBAction func btnActionSend(_ sender: Any) {
        if type == "event" || type == "me_time"{
            acceptEvent()
        }else{
            submitDateNightOfferDecision()
        }

    }

    @IBAction func btnActionBack(_ sender: Any) {
        if self.isComingFromNotificationScreen{
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController!.popViewController(animated: true)

        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }

}
