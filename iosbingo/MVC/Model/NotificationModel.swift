//
//  NotificationModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 02/08/2022.
//

import Foundation
class NotificationModel {
    var id: Int?
    var name, secondaryName: String?
    var isToggled: Bool?

    init(id: Int, name: String, secondaryName: String, isToggled: Bool) {
        self.id = id
        self.name = name
        self.secondaryName = secondaryName
        self.isToggled = isToggled
   }
}
