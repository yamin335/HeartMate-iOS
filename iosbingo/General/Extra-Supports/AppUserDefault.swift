//
//  AppUserDefault.swift
//  iosbingo
//
//  Created by Hamza Saeed on 22/07/2022.
//

import Foundation

let isPremium = AppUserDefault.shared.getValueBool(for: .premiumUnlocked)
protocol rowValue {
    var value : String { get }
}

enum DefaultKey {
    case UserID
    case ProfileData
    case Token
    case IsLoggedIn
    case premiumUnlocked
    case notifications
    case mobileNumber
    case unreadCount
    case userData
    case corporateInfo
    case helpCenter
    case privacyPolicy
    case termsOfService
    case licenses
    case safeDatingTips
    case memberPrinciples
    case numberChanges
    case nonExclusiveDatingPartners
    case onBoardingVideo
    case Cookie
    case slideCount
    case inventoryLastUpdated
    case aspectsOfMyLife
    case lifeInventoryAudioURL
    case subscriptionLevel
    case subscriptionDuration
    case subscriptionPrice
    case subscriptionExpirydate
    case isUserRegistering
}

extension DefaultKey : rowValue {
    var value: String {
        switch self {
        case .UserID: return "UserID"
        case .ProfileData: return "ProfileData"
        case .Token: return "Token"
        case .IsLoggedIn: return "IsLoggedIn"
        case .premiumUnlocked: return "premiumUnlocked"
        case .notifications: return "notifications"
        case .subscriptionLevel: return "subscriptionLevel"
        case .subscriptionDuration: return "subscriptionDuration"
        case .subscriptionPrice: return "subscriptionPrice"
        case .subscriptionExpirydate: return "subscriptionExpirydate"
        case .mobileNumber: return "mobileNumber"
        case .unreadCount: return "unreadCount"
        case .userData: return "userData"
        case .corporateInfo: return "corporateInfo"
        case .helpCenter: return "helpCenter"
        case .privacyPolicy: return "privacyPolicy"
        case .licenses: return "licenses"
        case .safeDatingTips: return "safeDatingTips"
        case .memberPrinciples: return "memberPrinciples"
        case .numberChanges: return "numberChanges"
        case .nonExclusiveDatingPartners: return "nonExclusiveDatingPartners"
        case .onBoardingVideo: return "onBoardingVideo"
        case .termsOfService: return "termsOfService"
        case .Cookie: return "Cookie"
        case .slideCount: return "SlideCount"
        case .inventoryLastUpdated: return "inventory_last_updated"
        case .aspectsOfMyLife: return "aspectsOfMyLife"
        case .lifeInventoryAudioURL: return "lifeInventoryAudioURL"
        case .isUserRegistering: return "isUserRegistering"

        }
    }
}

var isPremiumUnlocked = false

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"

    var errorDescription: String? {
        rawValue
    }
}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: DefaultKey) throws where Object: Encodable
    func getObject<Object>(forKey: DefaultKey, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: DefaultKey) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey.value)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }

    func getObject<Object>(forKey: DefaultKey, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey.value) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

class AppUserDefault {

    static var shared = AppUserDefault()
    var sharedObj = UserDefaults.standard

    var lifeInventoryCategories: [LifeInventoryCategory] = []
    var selectedCategoryIndex: Int =  0
    
    var slideCount: Int =  0

    func set(value:Any,for key:DefaultKey)  {
        sharedObj.set(value, forKey: key.value)
        sharedObj.synchronize()
    }
    
    func set(value:Any,for key:String)  {
        sharedObj.set(value, forKey: key)
        sharedObj.synchronize()
    }

    func getValue(for key:DefaultKey) -> String  {
        guard let value = sharedObj.string(forKey: key.value)
            else {
                return ""
        }
        return value
    }
    
    func getValue(for key:String) -> String  {
        guard let value = sharedObj.string(forKey: key)
            else {
                return ""
        }
        return value
    }
    

    func getValueBool(for key:String) -> Bool  {
        return sharedObj.bool(forKey: key)
    }
    func getValueBool(for key:DefaultKey) -> Bool  {
        return sharedObj.bool(forKey: key.value)
    }


    func getValueInt(for key:DefaultKey) -> Int  {
        return sharedObj.integer(forKey: key.value)
    }
    
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
