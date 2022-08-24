//
//  BackUpViewController.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/24.
//

import UIKit

class BackUpViewController: BaseViewController {

    // MARK: - Propertys
    var backUpFiles: [String] = ["", ""]
    
    
    
    
    
    // MARK: - Life Cylce
    let backUpView = BackUpView()
    override func loadView() {
        self.view = backUpView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    
    // MARK: - Methods
    override func configure() {
        backUpView.backUpListTableView.delegate = self
        backUpView.backUpListTableView.dataSource = self
        backUpView.backUpListTableView.register(BackUpTableViewCell.self, forCellReuseIdentifier: BackUpTableViewCell.identifier)
        
        backUpView.coverView.isHidden = !backUpFiles.isEmpty
        
        backUpView.backUpButton.addTarget(self, action: #selector(addBackUpButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func addBackUpButtonTapped() {
        print("백업 탭")
    }
    
}




// MARK: - TableView Protocol
extension BackUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackUpTableViewCell.identifier, for: indexPath) as? BackUpTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
