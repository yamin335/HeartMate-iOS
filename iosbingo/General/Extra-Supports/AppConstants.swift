//
//  Constants.swift
//  iosbingo
//
//  Created by Hamza Saeed on 08/08/2022.
//

import UIKit

let key = "611ba88a47b7a"
let SECRET_KEY = ")(JTQAS(JASM#saasf31()@#Nfa0"

func removeUserPreference(){
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
}

func navigatetoLoginScreen(){
    let nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginNavController") as! UINavigationController
    UIApplication.shared.windows.first?.rootViewController = nav
    UIApplication.shared.windows.first?.makeKeyAndVisible()
}

func decode(jwtToken jwt: String) throws -> [String: Any] {

    enum DecodeErrors: Error {
        case badToken
        case other
    }

    func base64Decode(_ base64: String) throws -> Data {
        let base64 = base64
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
        guard let decoded = Data(base64Encoded: padded) else {
            throw DecodeErrors.badToken
        }
        return decoded
    }

    func decodeJWTPart(_ value: String) throws -> [String: Any] {
        let bodyData = try base64Decode(value)
        let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
        guard let payload = json as? [String: Any] else {
            throw DecodeErrors.other
        }
        return payload
    }

    let segments = jwt.components(separatedBy: ".")
    return try decodeJWTPart(segments[1])
}


func countryFlag(countryCode: String) -> String {

    return String(String.UnicodeScalarView(countryCode.unicodeScalars.compactMap({ UnicodeScalar(127397 + $0.value) })))
}
