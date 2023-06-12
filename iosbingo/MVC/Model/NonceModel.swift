//
//  NonceModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 20/07/2022.
//

import Foundation
// MARK: Nonce Modle

class NonceModel: Codable {
    let status, controller, method, nonce: String?

    init(status: String?, controller: String?, method: String?, nonce: String?) {
        self.status = status
        self.controller = controller
        self.method = method
        self.nonce = nonce
    }
}
