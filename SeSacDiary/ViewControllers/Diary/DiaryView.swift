//
//  DiaryView.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/21.
//

import UIKit
import SnapKit
import TextFieldEffects

class DiaryView: BaseView {
    
    // MARK: - Propertys
    let selectedImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .lightGray
        return view
    }()
    
    let titleTextField: MainTextField = {
        let view = MainTextField()
        view.placeholder = "Title"
        return view
    }()
    
    let dateTextField: MainTextField = {
        let view = MainTextField()
        view.placeholder = "Date"
        return view
    }()
    
    let contentTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 14)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
    
    let searchImageButton: UIButton = {
        let view = UIButton()
        view.setTitle("선택", for: .normal)
        view.setTitleColor(UIColor.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 15)
        
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 25
        return view
    }()
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [selectedImageView, titleTextField, dateTextField, contentTextView, searchImageButton].forEach {
            self.addSubview($0)
        }
    }
    
    
    
    override func setConstraints() {
        selectedImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(self.snp.width).multipliedBy(0.75)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(selectedImageView.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(55)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(55)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-12)
        }
        
        searchImageButton.snp.makeConstraints { make in
            make.trailing.equalTo(selectedImageView.snp.trailing).offset(-12)
            make.bottom.equalTo(selectedImageView.snp.bottom).offset(-12)
            make.width.height.equalTo(50)
        }
    }
}
