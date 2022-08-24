//
//  BackUpViewController.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/24.
//

import UIKit

class BackUpViewController: BaseViewController {

    
    // MARK: - Life Cylce
    let backUpView = BackUpView()
    override func loadView() {
        self.view = backUpView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
    }
    
}
