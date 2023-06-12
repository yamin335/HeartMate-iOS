//
//  ErrorModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 20/07/2022.
//

import Foundation
// MARK: - Error Model
class ErrorModel: Codable {
    let status, error: String?

    init(status: String?, error: String?) {
        self.status = status
        self.error = error
    }
}
