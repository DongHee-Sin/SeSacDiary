//
//  HomeView.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/23.
//

import UIKit

class HomeView: BaseView {
    
    // MARK: - Propertys
    let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [tableView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(0)
        }
    }
}
