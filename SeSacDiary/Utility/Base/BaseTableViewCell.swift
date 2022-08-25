//
//  BaseTableViewCell.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/24.
//

import UIKit


class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configureUI() {}
    
    func setConstraints() {}
}
