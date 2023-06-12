//
//  ForgotModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 30/07/2022.
//

import Foundation
//MARK:- ForgotModel
class FogotModel: Codable {
    let msg: String

    init(msg: String) {
        self.msg = msg
    }
}
