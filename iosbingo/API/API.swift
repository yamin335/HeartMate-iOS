//
//  API.swift
//  Sports Friends Hookup
//
//  Created by Saqlain Syed on 19/04/2019.
//  Copyright © 2019 Saqlain Syed. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

enum RequestType: String {
    case get, post;
}


#if DEBUG
fileprivate let baseURL = "https://team.legrandbeaumarche.com/api/"
#else
fileprivate let baseURL = "https://team.legrandbeaumarche.com/api/"
#endif
class API {
    
    public static let shared = API()
    private init() {}
    
    //MARK: - Headers
    func getHeader(isTokenRequired:Bool) -> HTTPHeaders {
        let accessToken = AppUserDefault.shared.getValue(for: .Token)
        let header : HTTPHeaders!
        if isTokenRequired {
            header = ["Authorization": "Bearer \(accessToken)","key":key,"version":"2"]
        }else{
            header = ["key":key,"version":"2"]
        }
        return header
    }
    
    //MARK: - Network Functions
    func ValidateToken(completion: @escaping (_ isValid:Bool) -> Void){
        let token = AppUserDefault.shared.getValue(for: .Token)
        let params = ["aws":token] as [String:Any]
        sendData(url: APIPath.validateCookie, requestType: .post, params: params, objectType: ValidateTokenModel.self, isTokenRequired: false) { (data,status)  in
            if status {
                guard let validateToken = data else {return}
                if validateToken.is_valid_token {
                    completion(true)
                }else{
                    completion(false)
                }
            }else{
                print("Error found")
                completion(false)
            }
        }
    }
    
    func getExitReasonData(url: String, requestType: RequestType, params: [String: Any]?, isTokenRequired: Bool = true,  completion: @escaping ([ExistReason]?, _ status: Bool) -> Void) {
        
        let myURL = baseURL + url
        print(myURL)

        let header: HTTPHeaders = self.getHeader(isTokenRequired: isTokenRequired)

        let request: HTTPMethod = requestType == RequestType.get ? HTTPMethod.get : HTTPMethod.post

        var encodingType : ParameterEncoding!
        if request == .get {
           encodingType = URLEncoding.queryString
        }else if request == .post{
           encodingType = URLEncoding.queryString
        }

        AF.request(URL(string: myURL)!, method: request, parameters: params, encoding: encodingType, headers: header).responseData { (response) in
            switch response.result {
            case .success(_):
                if(response.response?.statusCode == nil) {
                    completion(nil, false)
                }
                switch response.response!.statusCode {
                case 401...410:
                    do {
                        guard let data = response.data else {return}
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        let message = json["error"] as! String
                        APIError.shared.showErrorAlert(message: message)
                        completion(nil, false)

                    } catch let err {
                        print("Err", err)
                        APIError.shared.handleNetworkErrors(error: err)
                        completion(nil,false)
                    }
                    break
                case 500...510:
                    completion(nil, false)
                    break
                default:
                    guard let data = response.data, let exitData = try? JSONDecoder().decode(ExitDating.self, from: data), exitData.status == "ok", !exitData.existReasons.isEmpty else {
                        completion(nil, false)
                        return
                    }
                    
                    completion(exitData.existReasons, true)
                    break
                }
            case .failure(let error):
                print("Err", error)
                APIError.shared.handleNetworkErrors(error: error)
                completion(nil,false)
                break;
            }
        }
    }
    
    func getDatingjourney(url: String, requestType: RequestType, params: [String: Any]?, isTokenRequired: Bool = true, completion: @escaping ([Journey]?, DatingJourneyTutorial?,_ status:Bool) -> Void) {
        
        let myURL = baseURL + url
        print(myURL)

        let header: HTTPHeaders = self.getHeader(isTokenRequired: isTokenRequired)

        let request: HTTPMethod = requestType == RequestType.get ? HTTPMethod.get : HTTPMethod.post

        var encodingType : ParameterEncoding!
        if request == .get {
           encodingType = URLEncoding.queryString
        }else if request == .post{
           encodingType = URLEncoding.queryString
        }

        AF.request(URL(string: myURL)!, method: request, parameters: params, encoding: encodingType, headers: header).responseData { (response) in
            var tutorial: DatingJourneyTutorial = DatingJourneyTutorial()
            switch response.result {
            case .success(_):
                if(response.response?.statusCode == nil) {
                    completion(nil, tutorial, false)
                }
                switch response.response!.statusCode {
                case 401...410:
                    do {
                        guard let data = response.data else {return}
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        let message = json["error"] as! String
                        APIError.shared.showErrorAlert(message: message)
                        completion(nil, tutorial, false)

                    } catch let err {
                        print("Err", err)
                        APIError.shared.handleNetworkErrors(error: err)
                        completion(nil, tutorial,false)
                    }
                    break
                case 500...510:
                    completion(nil, tutorial, false)
                    break
                default:
                    do {
                        var journeys: [Journey] = []
                        guard let data = response.data else {return}
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        let status = json["status"] as! String
                        if status == "ok"{
                            
                            if let carouselJSON = json["carousel"]  as? [String:Any], let journeysJSONArray = carouselJSON["journeys"] as? [[String: Any]] {
                                
                                var itemID: Int = 0

                                for journeysJSON in journeysJSONArray {
                                    let journey: Journey = Journey()

                                    journey.first_name = journeysJSON["first_name"] as? String
                                    journey.groupId = journeysJSON["group_id"] as? Int
                                    journey.dating_partner_id = journeysJSON["dating_partner_id"] as? Int
                                    journey.dating_journey_id = journeysJSON["dating_journey_id"] as? Int
                                    journey.avatar = journeysJSON["avatar"] as? String
                                    journey.value_me_score = journeysJSON["value_me_score"] as? Int

                                    let ourStatus: OurStatus = OurStatus()
                                    let level2Commitment: Level2_Commitment = Level2_Commitment()
                                    var discovery: Discovery = Discovery()

                                    if let ourStatusJSON = journeysJSON["our_status"]  as? [String:Any] {
                                        ourStatus.level = ourStatusJSON["level"]   as? String
                                        ourStatus.title = ourStatusJSON["title"]   as? String
                                    }

                                    if let level2CommitmentJSON = journeysJSON["level_2_commitment"]  as? [String:Any] {
                                        level2Commitment.header = level2CommitmentJSON["header"] as? String
                                        level2Commitment.level2_InvitationDescription = level2CommitmentJSON["description"] as? String
                                        level2Commitment.comfortableText = level2CommitmentJSON["comfortable_text"] as? String
                                        level2Commitment.balanceText = level2CommitmentJSON["balance_text"] as? String
                                        level2Commitment.safeText = level2CommitmentJSON["safe_text"] as? String

                                    }

                                    if let discoveries = journeysJSON["discoveries"]  as? [String:Any]{

                                        let userData: UserData = UserData()
                                        if let userJson = discoveries["user"]  as? [String:Any] {
                                            userData.level = userJson.keys.first
                                            userData.value = userJson.values.first as? Int
                                        }

                                        let partnerData: Partner = Partner()

                                        if let partnerJson = discoveries["partner"]  as? [String:Any] {
                                            partnerData.level = partnerJson.keys.first
                                            partnerData.value = partnerJson.values.first as? Int
                                        }

                                        discovery.user = userData
                                        discovery.partner = partnerData
                                        journey.discovery = discovery
                                        journey.ourStatus = ourStatus
                                        journey.level2_Commiement = level2Commitment
                                        journey.id = itemID
                                    }
                                    journeys.append(journey)
                                    itemID = itemID + 1
                                }
                                
                                if journeys.isEmpty {
                                    print(tutorial)
                                    completion(nil, tutorial,true)
                                } else {
                                    print(journeysJSONArray)
                                    completion(journeys, nil,true)
                                }
                            } else {
                                guard let tutorialJson = json["dating_journey_tutorial"]  as? [String: Any] else {
                                    completion(nil, tutorial,false)
                                    return
                                }
                                
//                                if let title = tutorialJson["title"] as? String {
//                                    tutorial.title = title
//                                }
//
//                                if let header = tutorialJson["heade"] as? String {
//                                    tutorial.header = header
//                                }
//
//                                if let bullets = tutorialJson["bullets"] as? [String] {
//                                    tutorial.bullets = bullets
//                                }
                                
                                completion(nil, tutorial,false)
                            }
//                            if objectType != EmptyModel.self {
//                                let decoder = JSONDecoder()
//                                let decodedData = try decoder.decode(objectType.self, from: data)
//                                completion(decodedData,true)
//                            }else{
//                                completion(nil,true)
//                            }
                            
                        }else{
                            let message = json["error"] as! String
                            APIError.shared.showErrorAlert(message: message)
                            completion(nil, tutorial,false)
                        }
                    } catch let err {
                        print("Err", err)
                        APIError.shared.handleNetworkErrors(error: err)
                        completion(nil, tutorial,false)
                    }
                    break
                }
            case .failure(let error):
                print("Err", error)
                APIError.shared.handleNetworkErrors(error: error)
                completion(nil, tutorial,false)
                break;
            }
        }
    }
    
    

    func sendData<T: Codable>(url: String, requestType: RequestType, params: [String: Any]?, objectType: T.Type, isTokenRequired: Bool = true, completion: @escaping (T?,_ status:Bool) -> Void) {

        let myURL = baseURL + url
        print(myURL)

        let header: HTTPHeaders = self.getHeader(isTokenRequired: isTokenRequired)

        let request: HTTPMethod = requestType == RequestType.get ? HTTPMethod.get : HTTPMethod.post

        var encodingType : ParameterEncoding!
        if request == .get {
           encodingType = URLEncoding.queryString
        }else if request == .post{
           encodingType = URLEncoding.queryString
        }

        AF.request(URL(string: myURL)!, method: request, parameters: params, encoding: encodingType, headers: header).responseData { (response) in
            switch response.result{
            case .success(_):
                if(response.response?.statusCode == nil) {
                    completion(nil, false)
                }
                switch response.response!.statusCode {
                case 401...410:
                    do {
                        guard let data = response.data else {return}
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        let message = json["error"] as! String
                        APIError.shared.showErrorAlert(message: message)
                        completion(nil, false)

                    } catch let err {
                        print("Err", err)
                        APIError.shared.handleNetworkErrors(error: err)
                        completion(nil,false)
                    }
                    break
                case 500...510:
                    do {
                        guard let data = response.data else {return}
                        let str = String(decoding: data, as: UTF8.self)
                        print("Html error",str)
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        let message = json["error"] as! String
                        APIError.shared.showErrorAlert(message: message)
                        completion(nil, false)

                    } catch let err {
                        print("Err", err)
                        APIError.shared.handleNetworkErrors(error: err)
                        completion(nil,false)
                    }
                    break
                default:
                    do {
                        guard let data = response.data else {return}
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        print(json)
                        let status = json["status"] as! String
                        if status == "ok"{
                            if objectType != EmptyModel.self {
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(objectType.self, from: data)
                                completion(decodedData,true)
                            }else{
                                completion(nil,true)
                            }
                        }else{
                            let message = json["error"] as! String
                            APIError.shared.showErrorAlert(message: message)
                            completion(nil,false)
                        }
                    } catch let err {
                        print("Err", err)
                        //APIError.shared.handleNetworkErrors(error: err)
                        completion(nil,false)
                    }
                    break
                }
            case .failure(let error):
                print("Err", error)
                APIError.shared.handleNetworkErrors(error: error)
                completion(nil,false)
                break;
            }
        }
    }

    func sendMultiPartData<T: Codable>(url: String, requestType: RequestType, params: [String: Any], objectType: T.Type, imageData:Data, imageKey:String? = "avatar", isTokenRequired: Bool = true, completion: @escaping (T?,_ status:Bool) -> Void) {

        let myURL = baseURL + url
        print(myURL)

        let header: HTTPHeaders = self.getHeader(isTokenRequired: isTokenRequired)

        let request: HTTPMethod = requestType == RequestType.get ? HTTPMethod.get : HTTPMethod.post

        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            multipartFormData.append(imageData, withName: imageKey!, fileName: "\(Date.init().timeIntervalSince1970).png", mimeType: "image/png")

        }, to: URL(string: myURL)!, usingThreshold: UInt64.init(), method: request, headers: header).responseData(completionHandler: { (response) in

            switch response.result{
            case .success(_):
                if(response.response?.statusCode == nil) {
                    completion(nil, false)
                }
                switch response.response!.statusCode {
                case 401...410:
                    do {
                        guard let data = response.data else {return}
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        let message = json["error"] as! String
                        APIError.shared.showErrorAlert(message: message)
                        completion(nil, false)

                    } catch let err {
                        print("Err", err)
                        APIError.shared.handleNetworkErrors(error: err)
                        completion(nil,false)
                    }
                    break
                case 500...510:
                    completion(nil, false)
                    break
                default:
                    do {
                        guard let data = response.data else {return}
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(objectType.self, from: data)
                        completion(decodedData,true)
                    } catch let err {
                        print("Err", err)
                        APIError.shared.handleNetworkErrors(error: err)
                        completion(nil,false)
                    }
                    break
                }
            case .failure(let error):
                print("Err", error)
                APIError.shared.handleNetworkErrors(error: error)
                completion(nil,false)
                break;
            }
        })

    }

    func backgroundSendData(url: String, requestType: RequestType, params: [String: Any]?, isTokenRequired: Bool = true) {

        let myURL = baseURL + url
        print(myURL)

        let header: HTTPHeaders = self.getHeader(isTokenRequired: isTokenRequired)

        let request: HTTPMethod = requestType == RequestType.get ? HTTPMethod.get : HTTPMethod.post

        var encodingType : ParameterEncoding!
        if request == .get {
           encodingType = URLEncoding.queryString
        }else if request == .post{
           encodingType = URLEncoding.queryString
        }

        AF.request(URL(string: myURL)!, method: request, parameters: params, encoding: encodingType, headers: header).responseData { (response) in
            switch response.result{
            case .success(_):
                if(response.response?.statusCode == nil) {
                    print("Status code nil")

                }
                switch response.response!.statusCode {
                case 401...410:
                    do {
                        guard let data = response.data else {return}
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        _ = json["error"] as! String
                    } catch let err {
                        print("Err", err)
                    }
                    break
                case 500...510:
                    break
                default:
                    do {
                        guard let data = response.data else {return}
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        let status = json["status"] as! String
                        if status == "ok"{
                            print("Successfully called Api")
                        }else{
                            _ = json["error"] as! String
                        }
                    } catch let err {
                        print("Err", err)
                    }
                    break
                }
            case .failure(let error):
                print("Err", error)
                break;
            }
        }
    }

    func callAppleSubscriptionAPI(url: String, requestType: RequestType, params: [String: Any]?,completion: @escaping (_ data:[String:Any]?,_ status:Bool) -> Void) {

        let myURL = url
        print(myURL)

        let request: HTTPMethod = requestType == RequestType.get ? HTTPMethod.get : HTTPMethod.post

        let encodingType = JSONEncoding.prettyPrinted

        AF.request(URL(string: myURL)!, method: request, parameters: params, encoding: encodingType, headers: nil).responseData { (response) in
            switch response.result{
            case .success(_):
                if(response.response?.statusCode == nil) {
                    print("Status code nil")
                    completion(nil,false)
                }
                switch response.response!.statusCode {
                case 401...410:
                    do {
                        guard let data = response.data else {return}
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        _ = json["error"] as! String
                        completion(nil,false)
                    } catch let err {
                        print("Err", err)
                        completion(nil,false)
                    }
                    break
                case 500...510:
                    break
                default:
                    do {
                        guard let data = response.data else {return}
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        completion(json,true)
                    } catch let err {
                        print("Err", err)
                        completion(nil,false)
                    }
                    break
                }
            case .failure(let error):
                print("Err", error)
                break;
            }
        }
    }

    func callAppleSubscriptionAPIInBackground(url: String, requestType: RequestType, params: [String: Any]?) {

        let myURL = url
        print(myURL)

        let request: HTTPMethod = requestType == RequestType.get ? HTTPMethod.get : HTTPMethod.post

        let encodingType = JSONEncoding.prettyPrinted

        AF.request(URL(string: myURL)!, method: request, parameters: params, encoding: encodingType, headers: nil).responseData { (response) in
            switch response.result{
            case .success(_):
                if(response.response?.statusCode == nil) {
                    print("Status code nil")
                }
                switch response.response!.statusCode {
                case 401...410:
                    do {
                        guard let data = response.data else {return}
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        _ = json["error"] as! String
                    } catch let err {
                        print("Err", err)
                    }
                    break
                case 500...510:
                    break
                default:
                    do {
                        guard let data = response.data else {return}
                        print("reciept api called in the background")
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        let latestReceiptInfo = json["latest_receipt_info"] as? [[String:Any]]
                        if let latestReceiptInfo = latestReceiptInfo, latestReceiptInfo.count > 0 {
                            AppUserDefault.shared.set(value: latestReceiptInfo[0]["expires_date"] as? String ?? "", for: .subscriptionExpirydate)
                            let productId = latestReceiptInfo[0]["product_id"] as? String ?? ""
                            let (duration,type) = getInvitationLevel(id: productId)
                            AppUserDefault.shared.set(value: type, for: .subscriptionLevel)
                            AppUserDefault.shared.set(value: duration, for: .subscriptionDuration)
                            AppPurchasesHandler.sharedInstance.retrieveProductInfo(productId: productId) { success, price in
                                if success{
                                    AppUserDefault.shared.set(value: price, for: .subscriptionPrice)
                                }
                            }
                        }
                    } catch let err {
                        print("Err", err)
                    }
                    break
                }
            case .failure(let error):
                print("Err", error)
                break;
            }
        }
    }


}
