//
//  CalenderViewController.swift
//  SeSAC_Week06
//
//  Created by ChanhoHwang on 2021/11/01.
//

import UIKit
import FSCalendar
import RealmSwift

class CalenderViewController: UIViewController {

    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var allContentLabel: UILabel!
    
    let localRealm = try! Realm()
    
    var tasks: Results<UserDiary>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calenderView.delegate = self
        calenderView.dataSource = self
        
        tasks = localRealm.objects(UserDiary.self)
        print(tasks)
        
        let allCount = getAllDiaryCountFromUserDiary()
        allContentLabel.text = "총 \(allCount)"
        
//        let recent = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false).first?.diaryTitle
//        print("recent: \(recent)")
//        let photo = localRealm.objects(UserDiary.self).filter("content != nil").count
//        print("photo: \(photo)")
//        let favourite = localRealm.objects(UserDiary.self).filter("favourite = false")
//        print("favourite: \(favourite)")
//        //String -> ' ', AND, OR
//        let search = localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] '일기' OR content CONTAINS[c] '살아와'")
//        print("search: \(search)")
    }
}

extension CalenderViewController: FSCalendarDelegate, FSCalendarDataSource {
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "title"
//    }
//
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        return "subtitle"
//    }
    
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star")
//    }
    
    // Date: 시분초까지 모두 동일 해야함.
    // 1. 영국 표준시 기준으로 표기
    // 2. 데이트 포맷터
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // 11/2 3개의 일기라면 3개를. 없다면 x. 1개는 1개
        
        var count = 0
        
        for i in tasks {
            if i.writeDate == date {
                count += 1
            }
        }
        
        return tasks.filter("writeDate = %@", date).count
    }
}
