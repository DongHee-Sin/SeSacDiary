//
//  DiaryViewController.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/21.
//

import UIKit

import Kingfisher

class DiaryViewController: BaseViewController {

    let diaryView = DiaryView()
    
    override func loadView() {
        self.view = diaryView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methdos
    override func configure() {
        diaryView.searchImageButton.addTarget(self, action: #selector(selectImageButtonTapped), for: .touchUpInside)
        
        setDismissKeyboard()
    }
    
    
    override func setNavigationBar() {
        navigationItem.title = "Diary"
    }
    
    
    @objc func selectImageButtonTapped() {
        let vc = SearchImageViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
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
        let url = URL(string: urlString)
        diaryView.selectedImageView.kf.setImage(with: url)
    }
}
