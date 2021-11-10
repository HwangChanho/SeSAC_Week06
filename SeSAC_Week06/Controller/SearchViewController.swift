//
//  SearchViewController.swift
//  SeSAC_Week06
//
//  Created by ChanhoHwang on 2021/11/01.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let localRealm = try! Realm()
    var tasks: Results<UserDiary>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "검색"
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        tasks = localRealm.objects(UserDiary.self)
        print(tasks)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // 경로폴더 -> 이미지찾기
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
            return UIImage(contentsOfFile: imageURL.path)!
        }
        
        return nil
    }
    
    func deleteImageToDocumentDirectory(imagename: String) {
        // 1. 이미지 저장 경로 설정: 도큐먼트 폴더, FileManager UserDefaults와 비슷 Singleton
        // Desktop/jack/ios/folder
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 2. 이미지 파일 이름
        // Desktop/jack/ios/folder/222.png
        let imageURL = documentDirectory.appendingPathComponent(imagename)
        
        // 3. 이미지 압축
        // guard let data = image.pngData() else { return }
        
        // 4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        // 4-1. 이미지 경로 여부 확인
        if FileManager.default.fileExists(atPath: imageURL.path) {
            // 4-2. 기존 경로에 있는 이미지 삭제
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지를 삭제하지 못 했습니다.")
            }
        }
    }
    
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        let row = tasks[indexPath.row]
        cell.configureCell(row: row)
        
        cell.imageViewS.image = loadImageFromDocumentDirectory(imageName: "\(row._id).png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 화면 전환 + 값 전달 후 새로운 화면에서 수정이 적합
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskToUpdate = tasks[indexPath.row]
        
        // 1. 스토리보드 특정
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        
        // 2. 스토리보드 내 많은 뷰 컨트롤러 중 전환하고자 하는 뷰컨트롤러 가저오기
        let vc = storyBoard.instantiateViewController(withIdentifier: "SearchDetailViewController") as! SearchDetailViewController// 강제해제 연산자를 통해 매칭
        
        vc.userDiary = taskToUpdate
        
        // 2-1. 네비게이션 컨트롤러 임베드
        let nav = UINavigationController(rootViewController: vc)
        
        // 옵션
        // vc.modalTransitionStyle = .partialCurl
        nav.modalPresentationStyle = .fullScreen
        
        // 3. present
        present(nav, animated: true, completion: nil)
        
        // 1. 수정 = 레코드에 대한 값 수정
//        try! localRealm.write {
//            taskToUpdate.diaryTitle = "수정"
//            taskToUpdate.content = ""
//            tableView.reloadData()
//        }
        
        // 2. 일괄 수정
//        try! localRealm.write{
//            tasks.setValue(Date(), forKey: "writeDate")
//            tasks.setValue("새롭게 일기 쓰기", forKey: "diaryTitle")
//            tableView.reloadData()
//        }
        
        // 3. 수정: pk기준으로 수정할 떄 사용 (권장X)
//        try! localRealm.write{
//            let update = UserDiary(value: ["_id": taskToUpdate._id, "diaryTitle": "얘만 바꾸고 싶어"])
//            localRealm.add(update, update: .modified)
//            tableView.reloadData()
//        }
        
        // 4.
//        try! localRealm.write({
//            localRealm.create(UserDiary.self, value: ["_id": taskToUpdate._id, "diaryTitle": "얘만 바꾸고 싶어"], update: .modified)
//        })
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let row = tasks[indexPath.row]
        
        try! localRealm.write {
            deleteImageToDocumentDirectory(imagename: "\(tasks[indexPath.row]._id).jpg")
            localRealm.delete(row)
            tableView.reloadData()
        }
    }
}
