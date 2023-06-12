//
//  DemoViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 23/07/2022.
//

import UIKit
import SDWebImage

class NotificatonsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewSideMenu: UITableView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var lblNoNotification: UILabel!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var sideMenuViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuViewConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var segmentButton: UISegmentedControl!

    var isFilterApplied = false
    var cookie = ""
    var notificationModel : NotificationHomeModel?
    var componentTitle = ["Date Night","Commitment","Upcoming Plans","Journal Entries","Mood Rings","Couple Plans","Promotions","General Information"]
    var componentValue = ["date_night_offer","level_2_commitment","upcoming_plans","dating_journals","daily_status","thirty_day_goals","promotion","fyi"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 134
        cookie = AppUserDefault.shared.getValue(for: .Cookie)
        lblNoNotification.isHidden = true
        searchView.isHidden = true
        btnClear.isHidden = true
        self.sideMenuViewConstraint.constant = -self.view.frame.width
        self.sideMenuViewConstraintRight.constant = self.view.frame.width
        let defaultSegmentTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let selectedSegmentTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentButton.setTitleTextAttributes(defaultSegmentTextAttributes, for: .normal)
        segmentButton.setTitleTextAttributes(selectedSegmentTextAttributes, for: .selected)
    }

    override func viewWillAppear(_ animated: Bool) {
        segmentButton.selectedSegmentIndex = 2
        let params = ["is_new":"both"] as [String:Any]
        getNotificationDate(params: params)
    }

    //MARK: - Custom Functions
    func getNotificationDate(params:[String:Any]){
        if isFilterApplied{
            btnClear.isHidden = false
        }else{
            btnClear.isHidden = true
        }
        self.notificationModel?.notifications?.removeAll()
        AppLoader.shared.show(currentView: self.view)
        let cache = randomString(length: 32)
        var params = params
        params["cache"] = cache
        API.shared.ValidateToken { isValid in
            if isValid{
//                self.getUnreadCount()
                API.shared.sendData(url: APIPath.notification, requestType: .post, params: params, objectType: NotificationHomeModel.self) { (data,status)  in
                    if status {
                        guard let notificationDate = data else {
                            self.lblNoNotification.isHidden = false
                            AppLoader.shared.hide()
                            return}
                        self.notificationModel = notificationDate
                        if notificationDate.notifications != nil{
                            self.lblNoNotification.isHidden = true
                        }else{
                            self.lblNoNotification.isHidden = false
                        }
                        AppLoader.shared.hide()
                        self.tableView.reloadData()
                    }else{
                        self.lblNoNotification.isHidden = false
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

    func getUnreadCount(){
        API.shared.sendData(url: APIPath.unreadCount, requestType: .post, params: nil, objectType: UnreadModel.self) { (data,status)  in
            if status {
                guard let unreadData = data else {return}
                AppUserDefault.shared.set(value: unreadData.count, for: .unreadCount)
                self.tabBarController!.tabBar.hideBadg(on: 1)
                let count = AppUserDefault.shared.getValueInt(for: .unreadCount)
                self.tabBarController!.tabBar.showBadgOn(index:1, count: String(count))
            }else{
                print("Error found")
            }
        }
    }

    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func closeSideMenu() {
        UIView.animate(withDuration: 0.25, delay: 0 , options: .curveEaseOut, animations: {
            self.sideMenuViewConstraint.constant = -self.view.frame.width
            self.sideMenuViewConstraintRight.constant = self.view.frame.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    //MARK: - IB Actions

    @IBAction func btnActionSideMenu(_ sender: UIButton) {

        UIView.animate(withDuration: 0.25, delay: 0 , options: .curveEaseOut, animations: {
            self.sideMenuViewConstraint.constant = 0
            self.sideMenuViewConstraintRight.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)

    }

    @IBAction func btnActionCloseSideMenu(_ sender: UIButton) {
        closeSideMenu()
    }

    @IBAction func btnActionStartSearch(_ sender: UIButton) {
        searchView.isHidden = true
        isFilterApplied = true
        self.view.endEditing(true)
        segmentButton.selectedSegmentIndex = 2
        let params = ["is_new":"both","search_terms":txtFieldSearch.text!] as [String:Any]
        getNotificationDate(params: params)
    }

    @IBAction func btnActionSearchBox(_ sender: UIButton) {
        searchView.isHidden = false
    }

    @IBAction func btnActionDefaultNotification(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotifcationController") as! NotifcationController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActionClear(_ sender: UIButton) {
        isFilterApplied = false
        segmentButton.selectedSegmentIndex = 2
        let params = ["is_new":"both"] as [String:Any]
        getNotificationDate(params: params)
    }

    @IBAction func btnActionSegment(_ sender: UISegmentedControl) {
        var filterType = ""
        switch segmentButton.selectedSegmentIndex {
            case 0:
            filterType = "true"
            isFilterApplied = true
            case 1:
            filterType = "false"
            isFilterApplied = true
            case 2:
            filterType = "both"
            isFilterApplied = false
            default:
                break
        }

        let params = ["is_new":filterType] as [String:Any]
        getNotificationDate(params: params)
    }

    //MARK: - TableView Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewSideMenu {
            return componentTitle.count
        }else{
            return notificationModel?.notifications?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewSideMenu {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationDefaultSideMenuTableViewCell") as! NotificationDefaultSideMenuTableViewCell
            cell.lblSideMenu.text = componentTitle[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
            cell.lblName.text = notificationModel?.notifications?[indexPath.row].senderName
            cell.lblNotificationType.text = notificationModel?.notifications?[indexPath.row].componentAction
            cell.lblTimeSince.text = notificationModel?.notifications?[indexPath.row].timeSince
            cell.imgProfile.sd_setImage(with: URL(string: notificationModel?.notifications?[indexPath.row].senderAvatar ?? ""), placeholderImage: UIImage(named: "notificationdummy"))
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewSideMenu{
            return 40
        }else{
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == tableViewSideMenu {
            closeSideMenu()
            isFilterApplied = true
            segmentButton.selectedSegmentIndex = 2
            let params = ["is_new":"both","component":componentValue[indexPath.row]] as [String:Any]
            getNotificationDate(params: params)
        }else{
            if notificationModel?.notifications![indexPath.row].componentName == "level_2_commitment" {

                let vc = UIStoryboard(name: "Notifications", bundle: Bundle.main).instantiateViewController(withIdentifier: "Level2InvitationViewController") as! Level2InvitationViewController
                vc.notification = notificationModel?.notifications![indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)

            }else if notificationModel?.notifications![indexPath.row].componentName.lowercased() == "fyi_couple"{
                self.tabBarController?.selectedIndex = 0

            }else if notificationModel?.notifications![indexPath.row].componentName.lowercased() == "mood_rings"{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MoodRingViewController") as! MoodRingViewController
                vc.isCameFromNotification = true
                vc.id = notificationModel?.notifications![indexPath.row].itemID ?? 0
                self.navigationController?.pushViewController(vc, animated: true)

            }else if notificationModel?.notifications![indexPath.row].componentName.lowercased() == "date_night_offer"{
                let vc = UIStoryboard(name: "MasterPlan", bundle: Bundle.main).instantiateViewController(withIdentifier: "DateOfferViewController") as! DateOfferViewController
                vc.type = "date_night_offer"
                vc.bookingId = notificationModel?.notifications![indexPath.row].itemID ?? 0
                vc.isComingFromNotificationScreen = true
                self.navigationController?.pushViewController(vc, animated: true)

            }else if notificationModel?.notifications![indexPath.row].componentName.lowercased() == "fyi_offer_reschedule_request"{
                let vc = UIStoryboard(name: "MasterPlan", bundle: Bundle.main).instantiateViewController(withIdentifier: "DateOfferViewController") as! DateOfferViewController
                vc.bookingId = notificationModel?.notifications![indexPath.row].itemID ?? 0
                vc.isComingFromNotificationScreen = true
                self.navigationController?.pushViewController(vc, animated: true)


            }else if notificationModel?.notifications![indexPath.row].componentName.lowercased() == "fyi_event_confirmed"{
                let vc = UIStoryboard(name: "MasterPlan", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpcomingPlanViewController") as! UpcomingPlanViewController
                vc.bookingId = notificationModel?.notifications![indexPath.row].itemID ?? 0
                vc.type = "event"
                vc.isComingFromNotificationScreen = true
                self.navigationController?.pushViewController(vc, animated: true)

            }else if notificationModel?.notifications![indexPath.row].componentName.lowercased() == "fyi_event_reschedule_request"{
                let vc = UIStoryboard(name: "MasterPlan", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReschedulePlanViewController") as! ReschedulePlanViewController
                vc.bookingId = notificationModel?.notifications![indexPath.row].itemID ?? 0
                vc.type = "event"
                vc.isComingFromNotificationScreen = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
