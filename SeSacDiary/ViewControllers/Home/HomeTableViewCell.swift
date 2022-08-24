//
//  HomeTableViewCell.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/23.
//

import UIKit
import SnapKit
import Kingfisher


class HomeTableViewCell: BaseTableViewCell {

    // MARK: - Propertys
    let labelStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 20)
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    let diaryImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .lightGray
        return view
    }()
    

    
    
    
    // MARK: - Methods
    override func configureUI() {
        [labelStackView, diaryImageView].forEach {
            self.addSubview($0)
        }
        
        [titleLabel, dateLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
    }
    
    
    override func setConstraints() {
        diaryImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(12)
            make.bottom.equalTo(self).offset(-12)
            make.trailing.equalTo(self).offset(-12)
            make.width.equalTo(diaryImageView.snp.height)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(12)
            make.trailing.equalTo(self).offset(-12)
        }
    }
    
    
    func updateCell(data: UserDiary) {
        titleLabel.text = data.diaryTitle
        dateLabel.text = data.diaryDate.formatted()
        
//        if let imageURL = data.photoURL {
//            let url = URL(string: imageURL)
//            diaryImageView.kf.setImage(with: url)
//        }
    }
    
    
    override func prepareForReuse() {
        diaryImageView.image = nil
    }
}
