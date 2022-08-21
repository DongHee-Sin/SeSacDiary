//
//  MainTextField.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/21.
//

import UIKit
import TextFieldEffects


class MainTextField: HoshiTextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func setupUI() {
        textColor = .black
        placeholderColor = .darkGray
        borderInactiveColor = .lightGray
        borderActiveColor = .blue
    }
}
