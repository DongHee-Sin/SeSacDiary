//
//  HomeView.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/23.
//

import UIKit

import FSCalendar


final class HomeView: BaseView {
    
    // MARK: - Propertys
    let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    
    lazy var calendar: FSCalendar = {
        let view = FSCalendar()
        view.backgroundColor = .white
        return view
    }()
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [calendar, tableView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraints() {
        calendar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(calendar.snp.bottom).offset(50)
        }
    }
}
