//
//  DATE+Extension.swift
//  SeSAC_Week06
//
//  Created by ChanhoHwang on 2021/11/05.
//

import Foundation

extension DateFormatter {
    var customFormat: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "yyyy년 MM월 dd일"
        return date
    }
}
