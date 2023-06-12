//
//  UpcomingPlanViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 25/09/2022.
//

import UIKit
import WebKit

class UpcomingPlanViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblLinkdetail: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var lblDaysUntil: UILabel!
    @IBOutlet weak var lblDaysSoFar: UILabel!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var webContainerView: UIView!


    var upcomingModel : UpcomingEventModel?
    var type = ""
    var bookingId = 0
    var isDatingJourneyModule = false
    var isComingFromNotificationScreen = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        webContainerView.isHidden = true
        webView.navigationDelegate = self
        getOfferDetail()
    }

    //MARK: - Custom Functions

    func getOfferDetail(){
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

    func cancelMeTime(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let param = ["event_id":self.bookingId,] as [String:Any]

                API.shared.sendData(url: APIPath.cacelMeTime, requestType: .post, params: param, objectType:
                        EmptyModel.self) { (data,status)  in
                    if status {
                        self.generateAlert(withMsg: "Me-time Cancelled", otherBtnTitle: "Ok") { isPressed in
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

    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func updateUI(){
        lblTitle.text = upcomingModel?.dateNightEvent.eventTitle
        lblStartTime.text = upcomingModel?.dateNightEvent.eventStartTime
        lblEndTime.text = upcomingModel?.dateNightEvent.eventEndTime ?? "Until"
        lblLinkdetail.text = upcomingModel?.dateNightEvent.eventWebsite
        lblLocation.text = upcomingModel?.dateNightEvent.eventAddress
        lblDescription.text = upcomingModel?.dateNightEvent.eventDescription
        lblDaysUntil.text = upcomingModel?.dateNightEvent.daysUntil
        lblDaysSoFar.text = upcomingModel?.dateNightEvent.datesSoFar
        imgDetail.sd_setImage(with: URL(string: upcomingModel?.dateNightEvent.featuredImage ?? ""), placeholderImage: UIImage(named: "defaultUpcoming"))
        lblCreatedBy.text = upcomingModel?.dateNightEvent.createdBy

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
        showWebView(url: upcomingModel?.dateNightEvent.eventWebsite ?? "https://www.google.com/")
    }

    @IBAction func btnActionBack(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func btnActionCancel(_ sender: Any) {
        if type == "me_time" {
            cancelMeTime()
        }else{
            let vc = UIStoryboard(name: "MasterPlan", bundle: Bundle.main).instantiateViewController(withIdentifier: "CancelEventViewController") as! CancelEventViewController
            vc.eventId = bookingId
            vc.isDatingJourneyModule = isDatingJourneyModule
            vc.isComingFromNotificationScreen = isComingFromNotificationScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @IBAction func btnActionReschedule(_ sender: Any) {
        let vc = UIStoryboard(name: "MasterPlan", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReschedulePlanViewController") as! ReschedulePlanViewController
        vc.upcomingModel = upcomingModel
        vc.type = type
        vc.isDatingJourneyModule = isDatingJourneyModule
        vc.isComingFromNotificationScreen = isComingFromNotificationScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension UpcomingPlanViewController: WKNavigationDelegate {

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
