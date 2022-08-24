//
//  ReusableViewProtocol.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/24.
//

import UIKit

protocol ReusableViewProtocol {
    static var identifier: String { get }
}


extension UIViewController: ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}


extension UITableViewCell: ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
