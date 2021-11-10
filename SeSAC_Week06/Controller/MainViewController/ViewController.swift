//
//  ViewController.swift
//  SeSAC_Week06
//
//  Created by ChanhoHwang on 2021/11/01.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let array = [
        Array(repeating: "a", count: 10),
        Array(repeating: "b", count: 10),
        Array(repeating: "c", count: 10),
        Array(repeating: "d", count: 10),
        Array(repeating: "e", count: 10),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = LocalizableStrings.home_text.localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked(_:)))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func plusButtonClicked(_ sender: Any) {
        // 1. 스토리보드 특정
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // 2. 스토리보드 내 많은 뷰 컨트롤러 중 전환하고자 하는 뷰컨트롤러 가저오기
        let vc = storyBoard.instantiateViewController(withIdentifier: "Content") as! ContentViewController// 강제해제 연산자를 통해 매칭
        
        // 2-1. 네비게이션 컨트롤러 임베드
        let nav = UINavigationController(rootViewController: vc)
        
        // 옵션
        // vc.modalTransitionStyle = .partialCurl
        nav.modalPresentationStyle = .fullScreen
        
        // 3. present
        present(nav, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.data = array[indexPath.row]
        
        cell.categoryLabel.backgroundColor = .red
        cell.collectionView.backgroundColor = .yellow
        
        cell.collectionView.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 1 ? 300 : 170
    }
}
