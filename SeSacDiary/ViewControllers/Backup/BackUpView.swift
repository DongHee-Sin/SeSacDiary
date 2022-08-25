//
//  BackUpView.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/24.
//

import UIKit
import SnapKit


class BackUpView: BaseView {
    
    // MARK: - Propertys
    let backUpTitle: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 20)
        view.text = "백업하기"
        return view
    }()
    
    let backUpDescription: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.text = "생성된 백업 파일은 앱 내에 저장되기 때문에 앱 삭제 시 백업 파일도 함께 삭제됩니다.\n메신저, 이메일, 클라우드 스토리지 등으로 백업 파일을 보내주세요."
        view.numberOfLines = 0
        view.lineBreakMode = .byCharWrapping
        return view
    }()
    
    lazy var buttomStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        view.axis = .horizontal
        view.distribution = .fillEqually
        [backUpButton, restoreButton].forEach {
            view.addArrangedSubview($0)
        }
        return view
    }()
    
    let backUpButton: UIButton = {
        let view = UIButton()
        view.setTitle("백업하기", for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 17)
        view.titleLabel?.textColor = .white
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let restoreButton: UIButton = {
        let view = UIButton()
        view.setTitle("복구하기", for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 17)
        view.titleLabel?.textColor = .white
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let backUpListTableView = UITableView(frame: CGRect.zero, style: .plain)
    
    let coverView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "noBackUp")
        return view
    }()
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [backUpTitle, backUpDescription, buttomStackView, backUpListTableView, coverView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraints() {
        backUpTitle.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
        }
        
        backUpDescription.snp.makeConstraints { make in
            make.top.equalTo(backUpTitle.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
        }
        
        buttomStackView.snp.makeConstraints { make in
            make.top.equalTo(backUpDescription.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(50)
        }
        
        backUpListTableView.snp.makeConstraints { make in
            make.top.equalTo(backUpButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(self)
        }
        
        coverView.snp.makeConstraints { make in
            make.edges.equalTo(backUpListTableView)
        }
    }
}
