//
//  SettingModel.swift
//  iosbingo
//
//  Created by Hamza Saeed on 22/07/2022.
//

import Foundation

class SettingModel {
   var settingTitle: String?
   var settingList: [String]?

   init(settingTitle: String, settingList: [String]) {
       self.settingTitle = settingTitle
       self.settingList = settingList
   }
}
