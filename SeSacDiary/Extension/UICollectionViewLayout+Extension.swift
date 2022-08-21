//
//  UICollectionView+Extension.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/21.
//

import UIKit

extension UICollectionViewLayout {
    
    static var imageCollectionViewLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width: CGFloat = UIScreen.main.bounds.width
        let itemWidth: CGFloat = width / 3
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        
        return layout
    }
    
}
