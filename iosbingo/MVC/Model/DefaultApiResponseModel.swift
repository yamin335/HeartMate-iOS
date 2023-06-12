//
//  DefaultApiResponseModel.swift
//  iosbingo
//
//  Created by Md. Yamin on 12/17/22.
//

import Foundation

struct DefaultApiResponse: Codable {
    let data: [DefaultApiResponseData]
    let status: String?
}

struct DefaultApiResponseData: Codable {
    let response: String?
}
