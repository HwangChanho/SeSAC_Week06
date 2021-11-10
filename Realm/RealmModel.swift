//
//  RealmModel.swift
//  SeSAC_Week06
//
//  Created by ChanhoHwang on 2021/11/02.
//

import Foundation
import RealmSwift

// table
class UserDiary: Object {

    @Persisted var diaryTitle: String // column
    @Persisted var content: String?
    @Persisted var writeDate = Date()
    @Persisted var regDate = Date()
    
    //@Persisted var favourite: Bool
    
    // PK
    // @Persisted var objectId: ObjectId
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(diaryTitle: String, content: String?, writeDate: Date, regDate: Date) {
        self.init()
        self.diaryTitle = diaryTitle
        self.content = content
        self.writeDate = writeDate
        self.regDate = regDate
        //self.favourite = false
    }
}
