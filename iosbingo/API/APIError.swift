//
//  APIError.swift
//  Sports Friends Hookup
//
//  Created by Saqlain Syed on 19/04/2019.
//  Copyright © 2019 Saqlain Syed. All rights reserved.
//

import Foundation
import UIKit

enum NetworkErrorString {
    
    static let kGeneralServer       = "We are unable to process your request at the moment. Please try again later."
    static let kUnknownServer       = "Connection with the server cannot be established at this time. Please try again or contact your service provider."
    static let kRequestTimeOut      = "This seems to be taking longer than usual. Please try again later."
    static let kServiceUnavailable  = "Service unavailable due to technical difficulties. Please try again or contact service provider."
    static let kNoInternet          = "There is no or poor internet connection. Please connect to stable internet connection and try again."
    static let kConnectionLost      = "The network connection was lost"
    
}

class APIError {
    
    static let shared = APIError()
    
    private init() {}
    
    func handleNetworkErrors(error: Error?) {
//        print("Error code is: \(code)")
        
        var errorMsg = ""
        
        if let err = error as? URLError {
            switch err.code {
            case .notConnectedToInternet:
                errorMsg = NetworkErrorString.kNoInternet
                break
            case .cannotFindHost:
                errorMsg = NetworkErrorString.kUnknownServer
                break
            case .timedOut:
                errorMsg = NetworkErrorString.kRequestTimeOut
                break
            case .networkConnectionLost:
                errorMsg = NetworkErrorString.kConnectionLost
                break
            default:
                errorMsg = NetworkErrorString.kGeneralServer
                break
            }
        } else {
            let message = "\(error?.localizedDescription ?? NetworkErrorString.kGeneralServer)"
            errorMsg = message
        }
        
//        if errorMsg == ""{
//            errorMsg = status
//        }
        
        let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }

    func showErrorAlert(message: String){
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
