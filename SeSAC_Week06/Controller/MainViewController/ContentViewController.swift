//
//  ContentViewController.swift
//  SeSAC_Week06
//
//  Created by ChanhoHwang on 2021/11/01.
//

import UIKit
import RealmSwift

class ContentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var textField2: UITextView!
    @IBOutlet weak var getImageButton: UIButton!
    
    let localRealm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
        title = "일기 작성"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonCLicked(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonCLicked(_:)))
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    func setUp() {
        let formet = DateFormatter()
        formet.dateFormat = "yyyy년 MM월 dd일"
        let date = formet.string(from: Date())
        
        dateButton.setTitle(date, for: .normal)
        dateButton.tintColor = .black
        dateButton.layer.cornerRadius = 15
        dateButton.backgroundColor = .lightGray
        
        getImageButton.setTitle("불러오기", for: .normal)
        getImageButton.tintColor = .black
        getImageButton.layer.cornerRadius = 15
        getImageButton.backgroundColor = .lightGray
        getImageButton.addTarget(self, action: #selector(uploadPhoto), for: .touchUpInside)
        
        
    }
    
    @objc func cancelButtonCLicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonCLicked(_ sender: Any) {
        
        guard let date = dateButton.currentTitle, let value = DateFormatter().customFormat.date(from: date) else { return }
        
        let task = UserDiary(diaryTitle: textField.text ?? "제목 없음", content: textField2.text ?? "입력 없음", writeDate: value, regDate: Date())
        
        try! localRealm.write {
            localRealm.add(task)
            if let image = imageView.image {
                saveImageToDocumentDirectory(imagename: "\(task._id).png", image: image)
            } else {
                let defaultImage = UIImage(systemName: "person")
                saveImageToDocumentDirectory(imagename: "\(task._id).png", image: defaultImage!)
            }
            
        }
    }
    
    @IBAction func dateButtonPressed(_ sender: UIButton) {
        // datepicker 표시
        let alert = UIAlertController(title: "날짜 선택", message: "날짜를 선택해주세요", preferredStyle: .alert)
        
        // Alert 커스터마이징, 스토리보드와 연관성이 없다.
        // let contentView = DatePickerViewController()
        
        guard let contentView = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as? DatePickerViewController else {
            print("DatePickerViewController에 오류가 있음")
            return
        }
        
        // contentView.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        contentView.preferredContentSize.height = 200
        
        alert.setValue(contentView, forKey: "ContentViewController") // 소문자 대문자?
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            // 확인 버튼을 눌렸을때 title을 변경
            let format = DateFormatter()
            format.dateFormat = "yyyy년 MM월 dd일"
            let value = format.string(from: contentView.datePicker.date)
            
            self.dateButton.setTitle("\(value)", for: .normal)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func saveImageToDocumentDirectory(imagename: String, image: UIImage) {
        // 1. 이미지 저장 경로 설정: 도큐먼트 폴더, FileManager UserDefaults와 비슷 Singleton
        // Desktop/jack/ios/folder
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 2. 이미지 파일 이름
        // Desktop/jack/ios/folder/222.png
        let imageURL = documentDirectory.appendingPathComponent(imagename)
        
        // 3. 이미지 압축
        guard let data = image.pngData() else { return }
        
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
        
        // 5. 이미지를 도큐먼트에 저장
        do {
            try data.write(to: imageURL)
        } catch {
            print("이미지 저장 실패")
        }
    }
    
    @objc func uploadPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self //3
        // imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
}

extension ContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage //4
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
