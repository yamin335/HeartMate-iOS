//
//  SettingsViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 22/07/2022.
//

import UIKit
import Alamofire
import WebKit

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webContainerView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    var settingModel = [SettingModel]()
    var profileData : ProfileModel?
    var currentLevel = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        emailView.isHidden = true
        webContainerView.isHidden = true
        webView.navigationDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        settingModel.removeAll()
        currentLevel = AppUserDefault.shared.getValue(for: .subscriptionLevel)
        do {
            profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .ProfileData, castTo: ProfileModel.self)
            initializedModel()
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }

    //MARK: - Custom Functions

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

    func initializedModel(){
        var titleForMemberShip = "Upgrade to Preferred Membership"
        if currentLevel != "" && (currentLevel == "level_2" || currentLevel == "level_3"){
            titleForMemberShip = "Manage My Membership"
        }
        settingModel.append(SettingModel.init(settingTitle: "Phone & Email", settingList: ["\(profileData?.phone ?? "N/A")","\(profileData?.email ?? "N/A")"]))
        settingModel.append(SettingModel.init(settingTitle: "Notifications", settingList: ["Push notifications", "Emails"]))
        settingModel.append(SettingModel.init(settingTitle: "Membership", settingList: [titleForMemberShip]))
        settingModel.append(SettingModel.init(settingTitle: "Legal", settingList: ["Privacy Policy", "Term of Service", "Licences"]))
        settingModel.append(SettingModel.init(settingTitle: "Community", settingList: ["Safe Dating Tips", "Member Principles"]))

    }

    func getNonceForDeleteAccount(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = ["json":"get_nonce","controller":"userplus","method":"delete_account"] as [String:Any]
                API.shared.sendData(url: APIPath.nonce, requestType: .post, params: params, objectType: NonceModel.self) { (data,status)  in
                    if status {
                        guard let nonceData = data else {return}
                        print("Nonce method is",nonceData.method ?? "")
                        self.deleteAccount(nonce: nonceData.nonce ?? "")
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

    func deleteAccount(nonce:String){
        let params = ["nonce":nonce] as [String:Any]
        API.shared.sendData(url: APIPath.deleteAccount, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
            if status {
                AppLoader.shared.hideWithHandler { isComplete in
                    if isComplete{
                        removeUserPreference()
                        navigatetoLoginScreen()
                    }
                }
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    func logOff(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = ["aws":"jwt"] as [String:Any]
                API.shared.sendData(url: APIPath.logOff, requestType: .post, params: params, objectType: LogOff.self) { (data,status)  in
                    if status {
                        guard let logOffData = data else {return}
                        if logOffData.newStatus == "token blacklisted" {
                            AppLoader.shared.hideWithHandler { isComplete in
                                if isComplete{
                                    removeUserPreference()
                                    navigatetoLoginScreen()
                                }
                            }
                        }
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

    func updateUserName(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = ["user_email":self.txtFieldEmail.text!] as [String:Any]
                API.shared.sendData(url: APIPath.updateProfile, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
                    if status {
                        AppLoader.shared.hide()
                        self.showAlert(message: "Email updated successfully", AlertTitle: "Alert")
                        self.settingModel[0].settingList![1] = self.txtFieldEmail.text!
                        self.tableView.reloadData()
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

    //MARK: - Button Actions
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActionSignOut(_ sender: Any) {
        logOff()
    }

    @IBAction func btnActionDeleteAccount(_ sender: Any) {
        showAlertWithYesNo(withMsg: "Are you sure to want delete your account?", yesBtnTitle: "Yes", noBtnTitle: "No") { Yes in
            if Yes{
                self.getNonceForDeleteAccount()
            }else{
                print("pressed No")
            }
        }
    }

    @IBAction func btnHideWebView(_ sender: Any) {
        closeWebView()
    }

    @IBAction func btnConfirm(_ sender: Any) {
        emailView.isHidden = true
        updateUserName()
    }

    @IBAction func btnCancel(_ sender: Any) {
        emailView.isHidden = true
    }

    //MARK: - Tableview Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingModel.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingModel[section].settingList!.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingModel[section].settingTitle
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let header = view as? UITableViewHeaderFooterView
        let customFont = UIFont(name: "Inter-Regular", size: 15)
        header?.textLabel?.font = customFont
        header?.textLabel?.textColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell") as! SettingsTableViewCell
        cell.lblSettingName.text = settingModel[indexPath.section].settingList![indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                txtFieldEmail.text = settingModel[indexPath.section].settingList![indexPath.row]
                emailView.isHidden = false
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotifcationController") as! NotifcationController
                vc.profileData = profileData
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EmailsController") as! EmailsController
                vc.profileData = profileData
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 2 {
            let isPurchased = AppUserDefault.shared.getValueBool(for: .premiumUnlocked)
            if currentLevel == "" && !isPurchased{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipController") as! MembershipController
                vc.subscritionType = .level2
                self.navigationController?.pushViewController(vc, animated: true)
            }else if currentLevel != "" && currentLevel == "level_2" && isPurchased{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MangeMemberShipViewController") as! MangeMemberShipViewController
                vc.subscritionType = .level2
                self.navigationController?.pushViewController(vc, animated: true)
            }else if currentLevel != "" && currentLevel == "level_3" && isPurchased{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MangeMemberShipViewController") as! MangeMemberShipViewController
                vc.subscritionType = .level3
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let privacyPolicy = AppUserDefault.shared.getValue(for: .privacyPolicy)
                if privacyPolicy != ""{
                    showWebView(url: privacyPolicy)
                }
            }else if indexPath.row == 1 {
                let termOfService = AppUserDefault.shared.getValue(for: .termsOfService)
                if termOfService != "" {
                    showWebView(url: termOfService)
                }
            }else {
                let license = AppUserDefault.shared.getValue(for: .licenses)
                if license != "" {
                    showWebView(url: license)
                }
            }
        }else if indexPath.section == 4 {
            if indexPath.row == 0 {
                let safeDating = AppUserDefault.shared.getValue(for: .safeDatingTips)
                if safeDating != "" {
                    showWebView(url: safeDating)
                }
            }else {
                let memberPrinciple = AppUserDefault.shared.getValue(for: .memberPrinciples)
                if memberPrinciple != "" {
                    showWebView(url: memberPrinciple)
                }
            }
        }
    }

}


extension SettingsViewController: WKNavigationDelegate {

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
