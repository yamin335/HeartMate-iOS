//
//  DateOfferViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 26/09/2022.
//

import UIKit
import SDWebImage
import WebKit

class DateOfferViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var lblDaysUntil: UILabel!
    @IBOutlet weak var lblDaysSoFar: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblLinkdetail: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var viewAccept: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var webContainerView: UIView!

    var type = ""
    var bookingId = 0
    var offerReschedule : OfferRescheduleEventModel?
    var dateNightOfferModel : GetDateNightOfferModel?
    var isDateNightOffer = false
    var isDatingJourneyModule = false
    var isComingFromNotificationScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        isDateNightOffer = type == "date_night_offer" ? true : false
        webContainerView.isHidden = true
        webView.navigationDelegate = self
        if isDateNightOffer {
            getOfferDetail()
        }else{
            getOfferReschedule()
        }
    }

    //MARK: - Custom Functions

    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: - Custom Functions

    func getOfferReschedule(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let cache = randomString(length: 32)
                let param = ["event_reschedule_id":self.bookingId,"cache":cache] as [String:Any]
                API.shared.sendData(url: APIPath.getOfferReschedule, requestType: .post, params: param, objectType: OfferRescheduleEventModel.self) { (data,status)  in
                    if status {
                        guard let offerData = data else {
                            AppLoader.shared.hide()
                            return
                        }
                        self.offerReschedule = offerData
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

    func getOfferDetail(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let cache = randomString(length: 32)
                let param = ["date_night_offer_id":self.bookingId,"cache":cache] as [String:Any]
                API.shared.sendData(url: APIPath.getDateNightOffer, requestType: .post, params: param, objectType: GetDateNightOfferModel.self) { (data,status)  in
                    if status {
                        guard let offerData = data else {
                            AppLoader.shared.hide()
                            return
                        }
                        self.dateNightOfferModel = offerData
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

    func submitDateNightOfferDecision(decisionId:Int, id:Int){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let param = ["date_night_offer_id":id,"decision":decisionId] as [String:Any]
                API.shared.sendData(url: APIPath.submitDateNightOfferDecision, requestType: .post, params: param, objectType: EmptyModel.self) { (data,status)  in
                    if status {
                        AppLoader.shared.hideWithHandler(completion: { isDone in
                            if isDone{
                                let message = decisionId == 1 ? "Date Night Booked" : "Date Night Offer Declined"
                                self.generateAlert(withMsg: message, otherBtnTitle: "Ok") { isPressed in
                                    if isPressed{
                                        self.backButton()
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


    func acceptRescheduleDateNightEvent(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let param = ["event_id":self.offerReschedule?.dateNightEvent.parentEventID ?? "","reschedule_offer_id":self.offerReschedule?.dateNightEvent.rescheduleOfferID ?? "", "event_start_date":self.offerReschedule?.dateNightEvent.eventStartDate ?? "","event_start_time":self.offerReschedule?.dateNightEvent.eventStartTime ?? "","event_end_date":self.offerReschedule?.dateNightEvent.eventEndDate ?? "","event_end_time":self.offerReschedule?.dateNightEvent.eventEndTime ?? ""] as [String:Any]
                API.shared.sendData(url: APIPath.acceptRescheduleEvent, requestType: .post, params: param, objectType: EmptyModel.self) { (data,status)  in
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
        if isDateNightOffer{
            lblTitle.text = dateNightOfferModel?.dateNightOffer.dateNightTitle
            lblDaysUntil.text = ""
            lblDaysSoFar.text = ""
            imgDetail.sd_setImage(with: URL(string: dateNightOfferModel?.dateNightOffer.featuredImage ?? ""), placeholderImage: UIImage(named: "defaultUpcoming"))
            lblStartTime.text = dateNightOfferModel?.dateNightOffer.eventStartTime
            lblEndTime.text = dateNightOfferModel?.dateNightOffer.eventEndTime ?? "Until"
            lblLinkdetail.text = dateNightOfferModel?.dateNightOffer.eventWebsite
            lblLocation.text = dateNightOfferModel?.dateNightOffer.location
            lblDescription.text = dateNightOfferModel?.dateNightOffer.dateNightDescription
            lblCreatedBy.text = dateNightOfferModel?.dateNightOffer.createdBy
            viewAccept.isHidden = dateNightOfferModel?.dateNightOffer.isSender == 1 ? true : false

        }else{
            lblTitle.text = offerReschedule?.dateNightEvent.eventTitle
            lblDaysUntil.text = offerReschedule?.dateNightEvent.daysUntil
            lblDaysSoFar.text = offerReschedule?.dateNightEvent.datesSoFar
            imgDetail.sd_setImage(with: URL(string: offerReschedule?.dateNightEvent.featuredImage ?? ""), placeholderImage: UIImage(named: "defaultUpcoming"))
            lblStartTime.text = offerReschedule?.dateNightEvent.eventStartTime
            lblEndTime.text = offerReschedule?.dateNightEvent.eventEndTime
            lblLinkdetail.text = offerReschedule?.dateNightEvent.eventWebsite
            lblLocation.text = offerReschedule?.dateNightEvent.eventAddress
            lblDescription.text = offerReschedule?.dateNightEvent.eventDescription
            lblCreatedBy.text = offerReschedule?.dateNightEvent.createdBy
            viewAccept.isHidden = offerReschedule?.dateNightEvent.isSender == 1 ? true : false
        }
    }

    func backButton(){
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

    func showWebView(url:String){
        let myURL = URL(string:url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        activityIndicatorView.isHidden = false
        webContainerView.isHidden = false
    }

    func closeWebView(){
        webView.load(URLRequest(url: URL(string:"about:blank")!))
        webContainerView.isHidden = true
    }

    //MARK: - IB Actions

    @IBAction func btnHideWebView(_ sender: Any) {
        closeWebView()
    }

    @IBAction func btnShowWebView(_ sender: Any) {
        if isDateNightOffer{
            showWebView(url: dateNightOfferModel?.dateNightOffer.eventWebsite ?? "https://www.google.com/")
        }else{
            showWebView(url: offerReschedule?.dateNightEvent.eventWebsite ?? "https://www.google.com/")
        }
    }
    
    @IBAction func btnActionBack(_ sender: Any) {
        backButton()
    }

    @IBAction func btnActionAccept(_ sender: Any) {
        if isDateNightOffer{
            submitDateNightOfferDecision(decisionId: 1, id: self.bookingId)
        }else{
            acceptRescheduleDateNightEvent()
        }
    }

    @IBAction func btnActionDecline(_ sender: Any) {
        if isDateNightOffer{
            submitDateNightOfferDecision(decisionId: 2, id: self.bookingId)
        }else{
            let vc = UIStoryboard(name: "MasterPlan", bundle: Bundle.main).instantiateViewController(withIdentifier: "CancelEventViewController") as! CancelEventViewController
            vc.eventId = Int(offerReschedule?.dateNightEvent.parentEventID ?? "0") ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func btnActionReschedule(_ sender: Any) {
        let vc = UIStoryboard(name: "MasterPlan", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReschedulePlanViewController") as! ReschedulePlanViewController
        vc.bookingId = bookingId
        vc.dateNightOfferModel = dateNightOfferModel
        vc.isDatingJourneyModule = isDatingJourneyModule
        vc.isComingFromNotificationScreen = isComingFromNotificationScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension DateOfferViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.isHidden = true
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicatorView.isHidden = true
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let message: String = error.localizedDescription
        activityIndicatorView.isHidden = true
        generateAlert(withMsg: message, otherBtnTitle: "OK") { refresh in
            self.closeWebView()
        }
    }
}
