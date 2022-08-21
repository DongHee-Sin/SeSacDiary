//
//  DiaryViewController.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/21.
//

import UIKit

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
    }
    
    
    override func setNavigationBar() {
        navigationItem.title = "Diary"
    }
    
    
    @objc func selectImageButtonTapped() {
        let vc = SearchImageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
