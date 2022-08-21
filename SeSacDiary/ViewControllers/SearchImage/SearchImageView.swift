//
//  SearchImage.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/21.
//

import UIKit

class SearchImageView: BaseView {
    
    // MARK: - Propertys
    let imageCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .imageCollectionViewLayout)
        return view
    }()
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(imageCollectionView)
    }
    
    override func setConstraints() {
        imageCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(0)
        }
    }
}
