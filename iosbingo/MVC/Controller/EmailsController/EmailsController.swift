//
//  EmailsController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 03/08/2022.
//

import UIKit

class EmailsController: UIViewController, NotificationCellToggle,UITableViewDelegate,UITableViewDataSource {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMainToggle: UISwitch!

    var notificationModel = [NotificationModel]()
    var isMainNotificationsToggleOn = true
    var profileData : ProfileModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        btnMainToggle.setOn(profileData?.emailAllNotifications == "1" ? true : false, animated: true)
        isMainNotificationsToggleOn = profileData?.emailAllNotifications == "1" ? true : false
        initializedModel()
        tableView.reloadData()

    }

    //MARK: - Custom Functions

    func initializedModel(){
        notificationModel.append(NotificationModel.init(id: 0, name: "New Discoveries", secondaryName: "" , isToggled: profileData?.emailNewDiscoveries == "1" ? true : false))
        notificationModel.append(NotificationModel.init(id: 1, name: "New Invitations", secondaryName: "" , isToggled: profileData?.emailNewInvitations == "1" ? true : false))
        notificationModel.append(NotificationModel.init(id: 2, name: "Daily Mood Ring", secondaryName: "" , isToggled: profileData?.emailMoodRings == "1" ? true : false))
        notificationModel.append(NotificationModel.init(id: 3, name: "Promotions", secondaryName: "Exclusive Offers and News" , isToggled: profileData?.emailPromotions == "1" ? true : false))
        notificationModel.append(NotificationModel.init(id: 4, name: "Annoucements", secondaryName: "What's new with See Me Hear Me Bingo" , isToggled: profileData?.emailAnnouncements == "1" ? true : false))
    }

    func onToggle(index: IndexPath, sender: UISwitch) {
        print("index at \(index.row) and toggle state is \(sender.isOn)")
        notificationModel[index.row].isToggled = sender.isOn
        sender.thumbTintColor = sender.isOn ? #colorLiteral(red: 0.08235294118, green: 0.5882352941, blue: 0.631372549, alpha: 1) : #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }

    func sendNotificationData(){
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = ["email_mood_rings":self.notificationModel[2].isToggled! ? "1" : "0", "email_all_notifications":self.btnMainToggle.isOn ? "1" : "0", "email_new_discoveries":self.notificationModel[0].isToggled! ? "1" : "0", "email_new_invitations":self.notificationModel[1].isToggled! ? "1" : "0", "email_promotions":self.notificationModel[3].isToggled! ? "1" : "0", "email_announcements":self.notificationModel[4].isToggled! ? "1" : "0"] as [String:Any]
                API.shared.backgroundSendData(url: APIPath.updateUserMetaVar, requestType: .post, params: params)
            }else{
                self.generateAlert(withMsg: "Session expired", otherBtnTitle: "Ok") { refresh in
                    removeUserPreference()
                    navigatetoLoginScreen()
                }
            }
        }

    }

    //MARK: - Button Actions

    @IBAction func btnActionBack(_ sender: Any) {
        profileData?.emailAllNotifications = btnMainToggle.isOn ? "1" : ""
        profileData?.emailMoodRings = notificationModel[2].isToggled! ? "1" : ""
        profileData?.emailNewDiscoveries = notificationModel[0].isToggled! ? "1" : ""
        profileData?.emailPromotions = notificationModel[3].isToggled! ? "1" : ""
        profileData?.emailNewInvitations = notificationModel[1].isToggled! ? "1" : ""
        profileData?.emailAnnouncements = notificationModel[4].isToggled! ? "1" : ""

        sendNotificationData()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActionMainNotification(_ sender: UISwitch) {
        if sender.isOn {
            isMainNotificationsToggleOn = true
            notificationModel = notificationModel.map{
                let currentObject = $0
                currentObject.isToggled = true
                return currentObject
            }
            tableView.reloadData()
        }else{
            isMainNotificationsToggleOn = false
            notificationModel = notificationModel.map{
                let currentObject = $0
                currentObject.isToggled = false
                return currentObject
            }
            tableView.reloadData()
        }
    }

    //MARK: - Tableview Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationModel.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 || indexPath.row == 4 {
            return 92
        }else{
            return 72
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmailsTableViewCell") as! EmailsTableViewCell
        cell.lblNotificationName.text = notificationModel[indexPath.row].name
        cell.lblNotificationSecondaryName.text = notificationModel[indexPath.row].secondaryName
        cell.delegate = self
        cell.btnToggle.setOn(notificationModel[indexPath.row].isToggled ?? false, animated: true)
        cell.btnToggle.thumbTintColor = notificationModel[indexPath.row].isToggled ?? false ? #colorLiteral(red: 0.08235294118, green: 0.5882352941, blue: 0.631372549, alpha: 1) : #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        cell.btnToggle.isEnabled = isMainNotificationsToggleOn
        cell.index = indexPath
        if indexPath.row == 3 || indexPath.row == 4 {
            cell.constraintSecondaryLbl.constant = 20
        }else{
            cell.constraintSecondaryLbl.constant = 0
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
