//
//  UploadProfileModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 30/07/2022.
//

import Foundation
// MARK: - UploadProfileModel
class UploadProfileModel: Codable {
    let full, thumb: String

    init(full: String, thumb: String) {
        self.full = full
        self.thumb = thumb
    }
}

