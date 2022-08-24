//
//  DiaryViewController.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/21.
//

import UIKit

import Kingfisher
import RealmSwift   // Realm 1.

class DiaryViewController: BaseViewController {

    var imageURL: String?
    
    let localRealm = try! Realm()  // Realm 2. Realm 테이블에 데이터를 CRUD할 때, Realm 테이블 경로에 접근하기 위한 코드
    
    let diaryView = DiaryView()
    
    override func loadView() {
        self.view = diaryView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    
    
    
    // MARK: - Methdos
    override func configure() {
        diaryView.searchImageButton.addTarget(self, action: #selector(selectImageButtonTapped), for: .touchUpInside)
        
        setDismissKeyboard()
    }
    
    
    override func setNavigationBar() {
        navigationItem.title = "Diary"
        
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        dismissButton.tintColor = .darkGray
        navigationItem.leftBarButtonItem = dismissButton
        
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "pencil.circle"), style: .plain, target: self, action: #selector(saveButtonTapped))
        saveButton.tintColor = .darkGray
        navigationItem.rightBarButtonItem = saveButton
    }
    
    
    @objc func saveButtonTapped() {
        // 1. imageURL 사용
//        guard diaryView.titleTextField.text != "" else {
//            showAlertMessage(title: "제목은 필수 입력입니다.", button: "확인")
//            return
//        }
//        let task = UserDiary(diaryTitle: diaryView.titleTextField.text!, diaryContent: diaryView.contentTextView.text!, diaryDate: Date(), regdate: Date(), photoURL: imageURL)
//
//        try! localRealm.write {
//            localRealm.add(task)  // Create
//            dismiss(animated: true)
//        }
        
        
        // 2. Realm + 이미지는 도큐먼트에 저장
        guard diaryView.titleTextField.text != "" else {
            showAlertMessage(title: "제목은 필수 입력입니다.", button: "확인")
            return
        }
        
        let task = UserDiary(diaryTitle: diaryView.titleTextField.text!, diaryContent: diaryView.contentTextView.text!, diaryDate: Date(), regdate: Date(), photoURL: nil)
        
        do {
            try localRealm.write{
                localRealm.add(task)
            }
        }catch let error {
            print(error)
        }
        
        
        if let image = diaryView.selectedImageView.image {
            saveImageToDocument(fileName: "\(task.objectId).jpg", image: image)
        }
        
        dismiss(animated: true)
    }
    
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    
    @objc func selectImageButtonTapped() {
        let vc = SearchImageViewController()
        vc.delegate = self
        transition(vc, transitionStyle: .presentNavigation)
    }
    
    
    private func setDismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
}




extension DiaryViewController: RegisterImageDelegate {
    func registerImage(urlString: String) {
        imageURL = urlString
        let url = URL(string: urlString)
        diaryView.selectedImageView.kf.setImage(with: url)
    }
    
    func registerImage(image: UIImage) {
        diaryView.selectedImageView.image = image
    }
}
