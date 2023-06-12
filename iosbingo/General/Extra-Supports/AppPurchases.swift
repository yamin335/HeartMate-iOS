//
//  AppPurchases.swift
//  iosbingo
//
//  Created by Hamza Saeed on 04/08/2022.
//  Copyright © 2022 user. All rights reserved.
//

import Foundation
import SwiftyStoreKit

var oneMonthSubscription = "com.tovalueme.app.1MonthSubscription"
var threeMonthSubscription = "com.tovalueme.app.3MonthSubscription"
var sixMonthSubscription = "com.tovalueme.app.6MonthSubscription"
var oneMonthSubscriptionForLevel3 = "com.tovalueme.app.1MonthSubscriptionLevel3"
var threeMonthSubscriptionForLevel3 = "com.tovalue.me.3MonthSubscriptionLevel3"
var sixMonthSubscriptionForLevel3 = "com.tovalue.me.6MonthSubscriptionLevel3"

var shareSecretKey = "648abf842e084b16897005ec8c1c9ffd"

func getInvitationLevel(id:String) -> (String,String){
    switch id {
    case oneMonthSubscription:
        return ("1 month","level_2")
    case threeMonthSubscription:
        return ("3 month","level_2")
    case sixMonthSubscription:
        return ("6 month","level_2")
    case oneMonthSubscriptionForLevel3:
        return ("1 month","level_3")
    case threeMonthSubscriptionForLevel3:
        return ("3 month","level_3")
    case sixMonthSubscriptionForLevel3:
        return ("6 month","level_3")
    default:
        return ("1 month","level_2")
    }
}

class AppPurchasesHandler: NSObject {
    //MARK: InAppPurchase
    
    static let sharedInstance = AppPurchasesHandler()
    
    func purchaseProduct(productId:String, completion: @escaping (_ success:Bool, _ messsage : String) -> Void) {
        SwiftyStoreKit.retrieveProductsInfo([productId]) { result in
            if let product = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let product):
                        let downloads = product.transaction.downloads
                        if !downloads.isEmpty {
                            SwiftyStoreKit.start(downloads)
                        }
                        // fetch content from your server, then:
                        if product.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(product.transaction)
                        }
                        AppUserDefault.shared.set(value: true, for: .premiumUnlocked)
                        isPremiumUnlocked = true
                        print("Purchase Success: \(product.productId)")
                        completion(true, "Purchased Successfully")
                    case .error(let error):
                        switch error.code {
                            case .unknown: print("Unknown error. Please contact support")
                            completion(false, "Unknown error. Please contact support")
                            case .clientInvalid: print("Not allowed to make the payment")
                            completion(false, "Not allowed to make the payment")
                            case .paymentCancelled: print("Payment has been cancelled")
                            completion(false, "Payment has been cancelled")
                            case .paymentInvalid: print("The purchase identifier was invalid")
                            completion(false, "The purchase identifier was invalid")
                            case .paymentNotAllowed: print("The device is not allowed to make the payment")
                            completion(false, "The device is not allowed to make the payment")
                            case .storeProductNotAvailable: print("The product is not available in the current storefront")
                            completion(false, "The product is not available in the current storefront")
                            case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                            completion(false, "Access to cloud service information is not allowed")
                            case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                            completion(false, "Could not connect to the network")
                            case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                            completion(false, "User has revoked permission to use this cloud service")
                            default: print("Default error",(error as NSError).localizedDescription)
                            completion(false, (error as NSError).localizedDescription)
                        }
                        //completion(false, )
                    }
                }
            }else {
                completion(false, "Unknown error. Please contact support")
            }
        }
    }

    func retrieveProductInfo(productId:String, completion: @escaping (_ success:Bool, _ price : String) -> Void){
        SwiftyStoreKit.retrieveProductsInfo([productId]) { result in
            if let product = result.retrievedProducts.first {
                print("product",product)
                completion(true,product.localizedPrice ?? "0$")
            }
        }
    }

    func restorePurchase(completion: @escaping (_ success:Bool, _ message:String) -> Void) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                completion(false,"Restore Failed try again later")
            }
            else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                AppUserDefault.shared.set(value: true, for: .premiumUnlocked)
                isPremiumUnlocked = true
//                print("Restore Success: \(results.restoredPurchases)")
                completion(true,"Purchasing has been restored.")
            }
            else {
                print("Nothing to Restore \(results)")
                completion(false,"There is nothing to restore.")
            }
        }
    }
    
    
    func verifyPurchases(productId:String,sharedKey:String){
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: sharedKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = productId
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    func verifySubsriptionGroup(sharedKey:String, completion: @escaping (_ success:Bool,_ subcribed:Bool,_ message:String?) -> Void){
        var enviornment : AppleReceiptValidator.VerifyReceiptURLType = .sandbox
        #if DEBUG
            enviornment = .sandbox
        #else
            enviornment = .production

        #endif

        let appleValidator = AppleReceiptValidator(service: enviornment, sharedSecret: sharedKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: true) { result in
            switch result {
            case .success(let receipt):
                self.callVerifyReceiptAPI(recieptData: receipt["latest_receipt"] as? String ?? "")
                let productIds = Set([oneMonthSubscription,
                                       sixMonthSubscription,
                                      threeMonthSubscription,
                                       oneMonthSubscriptionForLevel3,threeMonthSubscriptionForLevel3,sixMonthSubscriptionForLevel3])
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productIds) are valid until \(expiryDate)\n\(items)\n")
                    AppUserDefault.shared.set(value: true, for: .premiumUnlocked)
                    isPremiumUnlocked = true
                    completion(true,true, nil)
                case .expired(let expiryDate, let items):
                    print("\(productIds) are expired since \(expiryDate)\n\(items)\n")
                    AppUserDefault.shared.set(value: false, for: .premiumUnlocked)
                    isPremiumUnlocked = false
                    completion(true,false,nil)
                case .notPurchased:
                    print("The user has never purchased \(productIds)")
                    AppUserDefault.shared.set(value: false, for: .premiumUnlocked)
                    isPremiumUnlocked = false
                    completion(true,false,nil)
                }
            case .error(let error):
                print("Receipt verification failed: \(error.localizedDescription)")
                completion(false,false,error.localizedDescription)
            }
        }
    }

    func getReceiptData() -> String? {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                let receiptString = receiptData.base64EncodedString(options: .endLineWithCarriageReturn)
                print("recipiet",receiptString)
                return receiptString
            }
            catch {
                print("Couldn't read receipt data with error: " + error.localizedDescription)
                return nil
            }
        }else{
            return nil
        }
    }

    func callVerifyReceiptAPI(recieptData:String){
        var apiName = ""
        #if DEBUG
            apiName = APIPath.sandBoxAPI
        #else
            apiName = APIPath.productionAPI
        #endif
        let params = ["receipt-data":recieptData,"password":shareSecretKey,"exclude-old-transactions":true] as [String:Any]
        API.shared.callAppleSubscriptionAPIInBackground(url: apiName, requestType: .post, params: params)
    }
    
}
extension UIViewController {
    
    func showAlert(message : String , AlertTitle : String = "Error") {
        let alert = UIAlertController(title: AlertTitle , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }

  
}
