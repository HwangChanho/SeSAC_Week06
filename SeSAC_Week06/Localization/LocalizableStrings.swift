//
//  LocalizableStrings.swift
//  SeSAC_Week06
//
//  Created by ChanhoHwang on 2021/11/01.
//

import Foundation

enum LocalizableStrings: String {
    case home_text = "HOME"
    case data_backup
   
    var localized: String {
        return self.rawValue.localized()
    }
    
    var localizedSetting: String {
        return self.rawValue.localized(tableName: "Setting")
    }
}
