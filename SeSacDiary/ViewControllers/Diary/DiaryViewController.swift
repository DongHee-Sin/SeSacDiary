//
//  DiaryViewController.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/21.
//

import UIKit

import Kingfisher


final class DiaryViewController: BaseViewController {

    // MARK: - Propertys
    var imageURL: String?
    
    let repository = UserDiaryRepository()
    
    let dateFormatterManager = DateFormatterManager.shared
    
    let dateArray: [Date] = {
        var arr: [Date] = []
        
        [Int](0...10).forEach {
            let time = TimeInterval($0 * 86400)
            let date = Date(timeIntervalSinceNow: -time)
            arr.append(date)
        }
        
        return arr
    }()
    
    
    
    
    // MARK: - Life Cycle
    let diaryView = DiaryView()
    
    override func loadView() {
        self.view = diaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    
    
    
    // MARK: - Methdos
    override func configure() {
        diaryView.dateTextField.delegate = self
        diaryView.datePickerView.delegate = self
        diaryView.datePickerView.dataSource = self
        
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
    
    
    // BarButton Action
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
            showAlertMessage(title: "제목은 필수 입력입니다.")
            return
        }
        
        let diaryDate = dateFormatterManager.stringToDate(string: diaryView.dateTextField.text!) ?? Date()
        let task = UserDiary(diaryTitle: diaryView.titleTextField.text!, diaryContent: diaryView.contentTextView.text!, diaryDate: diaryDate, regdate: Date(), photoURL: nil)
        let image = diaryView.selectedImageView.image
        
        repository.addItem(item: task, image: image)
        
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
    
    
    // 빈공간 탭하면 키보드 dismiss
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




// MARK: - TextField Protocol
extension DiaryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}



// MARK: - PickerView Protocol
extension DiaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        diaryView.dateTextField.text = dateFormatterManager.dateToString(date: dateArray[row])
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dateFormatterManager.dateToString(date: dateArray[row])
    }
}
