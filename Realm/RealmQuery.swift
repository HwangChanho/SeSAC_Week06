//
//  RealmQuery.swift
//  SeSAC_Week06
//
//  Created by ChanhoHwang on 2021/11/05.
//

import Foundation
import UIKit
import RealmSwift

extension UIViewController {
    func searchQueryFromUserDiary(text: String) -> Results<UserDiary> {
        let localRealm = try! Realm()
        
        //String -> ' ', AND, OR
        let search = localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] '\(text)' OR content CONTAINS[c] '\(text)'")
        
        return search
    }
    
    func getAllDiaryCountFromUserDiary() -> Int {
        let localRealm = try! Realm()
        
        return localRealm.objects(UserDiary.self).count
    }
}
