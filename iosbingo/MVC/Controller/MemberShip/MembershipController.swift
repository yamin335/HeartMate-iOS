//
//  MembershipController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 03/08/2022.
//

import UIKit
import SwiftyStoreKit

enum MemberShipLevel {
    case onDemand
    case level2
    case level3
}

extension MemberShipLevel : rowValue {
    var value: String {
        switch self {
        case .onDemand: return "ondemand"
        case .level2: return "level_2"
        case .level3: return "level_3"
        }
    }
}

class MembershipController: UIViewController {

    @IBOutlet weak var imgHeaderForLevel2: UIImageView!
    @IBOutlet weak var imgHeaderForLevel3: UIImageView!
    @IBOutlet weak var imgHeaderForLevel3_1: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOneMonth: UILabel!
    @IBOutlet weak var lblThreeMonth: UILabel!
    @IBOutlet weak var lblSixMonth: UILabel!

    var expiryDate = ""
    var subscritionType : MemberShipLevel = .onDemand
    var subscriptionDuration = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        imgHeaderForLevel3.isHidden = true
        imgHeaderForLevel3_1.isHidden = true
        if subscritionType == .level2{
            lblTitle.text = "Access to the tools to explore guided dating journeys."
            lblOneMonth.text = "$34.99"
            lblThreeMonth.text = "$64.99 @ $21.66/mo"
            lblSixMonth.text = "$99.99 @ $16.66/mo"
        }else if subscritionType == .level3{
            lblTitle.text = "Access to  the tools for guided dating journeys and going to the next level - marrying two lives into one."
            lblOneMonth.text = "$65.99"
            lblThreeMonth.text = "$134.97 @ $44.99/mo"
            lblSixMonth.text = "$215 @ $35.99/mo"
            imgHeaderForLevel3.isHidden = false
            imgHeaderForLevel3_1.isHidden = false
            imgHeaderForLevel2.isHidden = true
        }
    }

    //MARK: - Custom Functions
    func sendDatingValues(recieptData:[String:Any],subscriptionDuration:String){
        API.shared.ValidateToken { isValid in
            if isValid{
                let params = ["subscription_status":"active", "susbcription_token":recieptData, "subscription_type":self.subscritionType.value,"subscription_expiry_date":self.expiryDate,"device_type":"ios"] as [String:Any]
                API.shared.backgroundSendData(url: APIPath.updateSubscriptionStatus, requestType: .post, params: params)
            }else{
                self.generateAlert(withMsg: "Session expired", otherBtnTitle: "Ok") { refresh in
                    removeUserPreference()
                    navigatetoLoginScreen()
                }
            }
        }
    }

    func verifyReceipt(recieptData:String,subscriptionDuration:String){
        var apiName = ""
        #if DEBUG
            apiName = APIPath.sandBoxAPI
        #else
            apiName = APIPath.productionAPI
        #endif
        let params = ["receipt-data":recieptData,"password":shareSecretKey,"exclude-old-transactions":true] as [String:Any]
        API.shared.callAppleSubscriptionAPI(url: apiName, requestType: .post, params: params) { data, status in
            if status{
                guard let data = data else {
                    AppLoader.shared.hide()
                    return}
                print("Receipt data",data["latest_receipt_info"] ?? "")
                
                let latestReceiptInfo = data["latest_receipt_info"] as? [[String:Any]]
                
                if let latestReceiptInfo = latestReceiptInfo, latestReceiptInfo.count > 0 {
                    AppUserDefault.shared.set(value: latestReceiptInfo[0]["expires_date"] as? String ?? "", for: .subscriptionExpirydate)
                    self.sendDatingValues(recieptData: latestReceiptInfo[0], subscriptionDuration: subscriptionDuration)
                }
                AppLoader.shared.hide()
            }else{
                AppLoader.shared.hide()
            }
        }
    }

    func ShowPurchaseAlert(productID: String,message : String , AlertTitle : String = "Alert!", duration: String, level:MemberShipLevel) {
        let alert = UIAlertController(title: AlertTitle , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Purchase", style: .default) { action in
            AppLoader.shared.show(currentView: self.view)
            AppPurchasesHandler.sharedInstance.purchaseProduct(productId: productID) { (success, message)  in
                if success {
                    self.expiryDate = self.setDuration(duration: duration)
                    AppUserDefault.shared.set(value: true, for: key)
                    AppPurchasesHandler.sharedInstance.retrieveProductInfo(productId: productID) { success, price in
                        if success{
                            AppUserDefault.shared.set(value: price, for: .subscriptionPrice)
                        }
                    }
                    let receipt = AppPurchasesHandler.sharedInstance.getReceiptData()
                    AppUserDefault.shared.set(value: level.value, for: .subscriptionLevel)
                    AppUserDefault.shared.set(value: duration, for: .subscriptionDuration)
                    self.verifyReceipt(recieptData: receipt ?? "", subscriptionDuration: duration)
                    self.showAlert(message: message, titled: "Success")
                }else{
                    self.showAlert(message: message, titled: "Error")
                    AppLoader.shared.hide()
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Restore", style: .default) { action in
            AppLoader.shared.show(currentView: self.view)
            AppPurchasesHandler.sharedInstance.restorePurchase { (success, message) in
                if success {
                    self.showAlert(message: message, AlertTitle: "Alert")
                }else{
                    self.showAlert(message: message)
                }
                AppLoader.shared.hide()

            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
           alert.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }

    func setDuration(duration:String) -> String{
        if duration == "1 month"{
            subscriptionDuration = 1
        }else if duration == "3 months"{
            subscriptionDuration = 3
        }else if duration == "6 months"{
            subscriptionDuration = 6
        }

        let monthsToAdd = subscriptionDuration
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = monthsToAdd
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        let futureDateInString = stringFromDate(date: futureDate, format: .long)
        return futureDateInString
    }

    @IBAction func btnOneMonthAction(_ sender: UIButton) {
        if subscritionType == .level2 {
            ShowPurchaseAlert(productID: oneMonthSubscription, message: "Do you want buy 1 month subscription plan?", duration: "1 month", level: subscritionType)
        }else if subscritionType == .level3{
            ShowPurchaseAlert(productID: oneMonthSubscriptionForLevel3, message: "Do you want buy 1 month subscription plan?", duration: "1 month", level: subscritionType)
        }
    }

    @IBAction func btn3MonthAction(_ sender: UIButton) {
        if subscritionType == .level2 {
            ShowPurchaseAlert(productID: threeMonthSubscription, message: "Do you want 3 three month subscription plan?", duration: "3 months", level: subscritionType)
        }else if subscritionType == .level3{

            ShowPurchaseAlert(productID: threeMonthSubscriptionForLevel3, message: "Do you want 3 three month subscription plan?", duration: "3 months", level: subscritionType)
        }

    }

    @IBAction func btn6MonthAction(_ sender: UIButton) {
        if subscritionType == .level2 {
            ShowPurchaseAlert(productID: sixMonthSubscription, message: "Do you want buy 6 month subscription plan?", duration: "6 months", level: subscritionType)
        }else if subscritionType == .level3 {
            ShowPurchaseAlert(productID: sixMonthSubscriptionForLevel3, message: "Do you want buy 6 month subscription plan?", duration: "6 months", level: subscritionType)
        }

    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
