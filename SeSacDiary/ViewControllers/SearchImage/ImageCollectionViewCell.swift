//
//  ImageCollectionViewCell.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/21.
//

import UIKit

import SnapKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    // MARK: - Property
    let searchResultImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(systemName: "star")
        return view
    }()
    
    let borderView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.red.cgColor
        return view
    }()
    
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    

    
    // MARK: - Methods
    func configureUI() {
        [searchResultImageView, borderView].forEach {
            self.addSubview($0)
        }
    }
    
    
    func setConstraints() {
        searchResultImageView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(0)
        }
        
        borderView.snp.makeConstraints { make in
            make.edges.equalTo(searchResultImageView).inset(0)
        }
    }
    
    
    func updateCell(imageURL: String, isSelectedItem: Bool) {
        let url = URL(string: imageURL)
        searchResultImageView.kf.setImage(with: url)
        
        borderView.isHidden = !isSelectedItem
    }
}
