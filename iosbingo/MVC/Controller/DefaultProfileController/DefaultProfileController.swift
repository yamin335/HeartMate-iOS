//
//  DefaultProfileController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 28/08/2022.
//

import UIKit
import WebKit
import SwiftUI

class DefaultProfileController: UIViewController,UpdateProfileImg,WhatWorks {

    //MARK: - IBOutlets

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webContainerView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblToValue: UILabel!
    @IBOutlet weak var lblToValueTitle: UILabel!
    @IBOutlet weak var lblJourneyValue: UILabel!
    @IBOutlet weak var lblJourneyTitle: UILabel!
    @IBOutlet weak var lblObservaitionValue: UILabel!
    @IBOutlet weak var lblObservationTitle: UILabel!
    @IBOutlet weak var lblDailyStatus: UILabel!
    @IBOutlet weak var imgRythmOfLife: UIImageView!
    @IBOutlet weak var lblRythmInventory: UILabel!
    @IBOutlet weak var lblRythmLastUpdate: UILabel!
    @IBOutlet weak var imgIceBerg: UIImageView!
    @IBOutlet weak var lblIceBurgInventory: UILabel!
    @IBOutlet weak var lblIceBurgLastUpdate: UILabel!
    @IBOutlet weak var relationshipPlanImageView: UIImageView!
    
    var isCalled = false
    var timer = Timer()
    var userID = 0
    var counter = 0
    var currentImage : UIImage?
    var profileData:ProfileModel?
    var currentLevel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        setUnderLineForSelectedTabBarItem()
        if isPremium {
        }
        AppPurchasesHandler.sharedInstance.restorePurchase { (success, message) in
            if success {
                print("Purchase restored")
            }else{
                print("Purchase restored failed")
            }
        }
        webContainerView.isHidden = true
        webView.navigationDelegate = self
        self.imgUserProfile.layer.masksToBounds = true
        self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.width/2
        //getNotificationsData()
        //AppPurchasesHandler.sharedInstance.verifyPurchases(productId: oneMonthSubscription, sharedKey: shareSecretKey)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.goToRelatioonshipPlans(_:)))
        relationshipPlanImageView.addGestureRecognizer(tap)

    }

    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }

    override func viewWillAppear(_ animated: Bool) {
        currentLevel = AppUserDefault.shared.getValue(for: .subscriptionLevel)
        getProfileData()
//        if isCalled {
//            DispatchQueue.main.async {
//                guard let profileData = self.profileData else {return}
//                self.collectionView.reloadData()
//                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(profileData.profileBanner.timer/1000), target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
//            }
//        }
    }
    
    @IBAction func goToMyRelationshipGoals(_ sender: UIButton) {
        pushController(controllerName: "MyRelationshipPlanHostVC", storyboardName: "Main")
    }
    
    //MARK: - Custom Fuctions
    @objc func changeImage() {
//        if counter < profileData?.inventoryCategories.count ?? 0 {
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
//        }
//        else {
//            counter = 0
//            let index = IndexPath.init(item: counter, section: 0)
//            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//            counter = 1
//        }
    }
    
    @objc func goToRelatioonshipPlans(_ sender: UITapGestureRecognizer? = nil) {
        pushController(controllerName: "RelationshipPlansHostVC", storyboardName: "Main")
    }

    func setUnderLineForSelectedTabBarItem(){
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: .black, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:  tabBar.frame.height), lineWidth: 2.0)
        let count = AppUserDefault.shared.getValueInt(for: .unreadCount)
        tabBar.showBadgOn(index:1, count: String(count))
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

    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func getProfileData(){
        AppLoader.shared.show(currentView: self.view)
        userID = AppUserDefault.shared.getValueInt(for: .UserID)
        let cache = randomString(length: 32)
        let params = ["user_id":userID,"cache":cache] as [String:Any]
        API.shared.sendData(url: APIPath.profile, requestType: .get, params: params, objectType: ProfileModel.self, isTokenRequired: false) { (data,status)  in
            if status {
                guard let profileData = data else {return}
                self.profileData = profileData
                self.isCalled = true
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(profileData.profileBanner.timer/1000), target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                }
                self.updateUI()
                do {
                    try AppUserDefault.shared.sharedObj.setObject(profileData, forKey: .ProfileData)
                } catch {
                    print(error.localizedDescription)
                }
                AppLoader.shared.hide()
            }else{
                self.updateUI()
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }

    func getNotificationsData(){
        AppLoader.shared.show(currentView: self.view)
        API.shared.ValidateToken { isValid in
            if isValid{
                API.shared.sendData(url: APIPath.getNotificationsAndEmails, requestType: .post, params: nil, objectType: GetEmailNotificationDataModel.self) { (data,status)  in
                    if status {
                        guard let notificationData = data else {return}
                        do {
                            try AppUserDefault.shared.sharedObj.setObject(notificationData, forKey: .notifications)
                        } catch {
                            print(error.localizedDescription)
                        }
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

    func updateUI(){
        lblUserName.text = profileData?.firstname ?? ""
        lblToValue.text = String(profileData?.toValueMe.value ?? 0)
        lblToValueTitle.text = profileData?.toValueMe.title ?? ""
        lblJourneyValue.text = String(profileData?.activeDatingJourneys.value ?? 0)
        lblObservaitionValue.text = String(profileData?.activeDatingJourneys.value ?? 0)
        lblObservationTitle.text = profileData?.receivedObservations.title ?? ""
        lblDailyStatus.text = profileData?.dailyStatus.title ?? ""
        lblRythmInventory.text = profileData?.rhythmOfLife.title ?? ""
        lblRythmLastUpdate.text = profileData?.rhythmOfLife.lastUpdated ?? "Last Updated Oct 2"
        lblIceBurgInventory.text = profileData?.icebreakers.title ?? ""
        lblIceBurgLastUpdate.text = profileData?.icebreakers.subHeading ?? ""

        imgUserProfile.sd_setImage(with: URL(string: (profileData?.avatar) ?? ""), placeholderImage: UIImage(named: "defaultProfile"))
        imgRythmOfLife.sd_setImage(with: URL(string: (profileData?.rhythmOfLife.backgroundImage) ?? ""), placeholderImage: UIImage(named: "defaultProfile"))
        imgIceBerg.sd_setImage(with: URL(string: (profileData?.icebreakers.backgroundImage) ?? ""), placeholderImage: UIImage(named: "defaultProfile"))

    }

    //MARK: - Button Actions

    @IBAction func btnEditProfileAction(_ sender: Any) {
        // Need to remove
//        AppUserDefault.shared.set(value: true, for: .isUserRegistering)
//        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ToValueMeReportViewController") as! ToValueMeReportViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        // Need to reactive
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        vc.profileData = profileData
        vc.delegate = self
        vc.currentImage = currentImage
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnHideWebView(_ sender: Any) {
        closeWebView()
    }

    @IBAction func btnActionVision(_ sender: UIButton) {
        let vc = UIStoryboard(name: "VisionBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "VisionBoardHomeVC") as! VisionBoardHomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActionDatingPreference(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DatingPreferenceController") as! DatingPreferenceController
        vc.profileData = profileData
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnActionSetting(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.profileData = profileData
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func btnActionDateNight(_ sender: UIButton) {
        let isPurchased = AppUserDefault.shared.getValueBool(for: .premiumUnlocked)
        if currentLevel == "" && !isPurchased{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DateNightCatalogVCForFreeUser") as! DateNightCatalogVCForFreeUser
            vc.dateNumber = profileData?.dateNumber ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }else if currentLevel != "" && (currentLevel == "level_2" || currentLevel == "level_3") && isPurchased{
            pushController(controllerName: "DateNightCatalogVC", storyboardName: "Main")
        }else if currentLevel == "" && isPurchased{
            pushController(controllerName: "DateNightCatalogVC", storyboardName: "Main")
        }else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DateNightCatalogVCForFreeUser") as! DateNightCatalogVCForFreeUser
            vc.dateNumber = profileData?.dateNumber ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func btnActionDailyStatus(_ sender: UIButton) {
        pushController(controllerName: "MoodRingViewController", storyboardName: "Main")

    }

    @IBAction func btnActionRythmOfLife(_ sender: UIButton) {
        getLifeInventoryCategories()
    }
    func getLifeInventoryCategories() {
        
        AppLoader.shared.show(currentView: self.view)

       let userID = AppUserDefault.shared.getValueInt(for: .UserID)
        
        var params : [String:Any] = [:]
   
            params["user_id"] = userID
        
        
        API.shared.sendData(url: APIPath.getLifeInventory, requestType: .post, params: params, objectType: LifeInventoryCategoryResponse.self) { (data, status)  in
            
            //isLoaderShown = false
            
            guard let lifeInventoryCategories = data else {
                return
            }
            
            AppUserDefault.shared.lifeInventoryCategories = lifeInventoryCategories.categories

            if AppUserDefault.shared.lifeInventoryCategories.count > 0 {
                
                self.profileData?.spectrum.lastUpdated =  Unity.shared.profileData?.spectrum.lastUpdated ?? self.profileData?.spectrum.lastUpdated ?? ""

                Unity.shared.profileData = self.profileData
                Unity.shared.loadUnityFromProfile(fromVC: self)
            }
        }
    }

    @IBAction func btnActionHelpCenter(_ sender: UIButton) {
        let helpCenter = AppUserDefault.shared.getValue(for: .helpCenter)
        if helpCenter != "" {
            showWebView(url: helpCenter)
        }
    }



    //MARK: - Update profile image protocol
    func updateUserProfileImage(img: UIImage) {
        self.currentImage = img
        self.imgUserProfile.image = img
    }

    func updateUserProfileModel(profile: ProfileModel) {
        self.profileData = profile
    }

    func onPress() {
        let vc = UIStoryboard(name: "WhatWorks", bundle: Bundle.main).instantiateViewController(withIdentifier: "WhatWorksViewController") as! WhatWorksViewController
        vc.profileModel = profileData
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension DefaultProfileController: WKNavigationDelegate {

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

extension DefaultProfileController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultProfileCollectionViewCell", for: indexPath) as! DefaultProfileCollectionViewCell
        
        let correctIndex = indexPath.row >= (profileData?.profileBanner.slider.panels.count ?? 0) ? indexPath.row % (profileData?.profileBanner.slider.panels.count ?? 0) : indexPath.row

        cell.lblTitle.text = profileData?.profileBanner.slider.panels[correctIndex].title
        cell.lblDescription.text = profileData?.profileBanner.slider.panels[correctIndex].panelDescription
        cell.imgIcon.sd_setImage(with: URL(string: (profileData?.profileBanner.slider.panels[correctIndex].icon) ?? ""), placeholderImage: UIImage(named: "greenCircleArrow"))
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCalled {
            return Int(Int16.max)
        }else{
            return 0
        }
       // return profileData?.inventoryCategories.count ?? 0//Int(Int16.max)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let correctIndex = indexPath.row >= (profileData?.profileBanner.slider.panels.count ?? 0) ? indexPath.row % (profileData?.profileBanner.slider.panels.count ?? 0) : indexPath.row
        let item = profileData?.profileBanner.slider.panels[correctIndex].title
        print("item name is \(item ?? "")")
    }

}


extension DefaultProfileController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
