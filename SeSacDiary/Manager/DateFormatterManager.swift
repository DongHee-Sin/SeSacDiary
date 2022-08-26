//
//  DateFormatterManager.swift
//  SeSacDiary
//
//  Created by 신동희 on 2022/08/26.
//

import Foundation


class DateFormatterManager {
    
    static let shared = DateFormatterManager()
    private init() { setDateFormatter() }
    
    
    private let formatter = DateFormatter()
    
    var currentDateString: String {
        return formatter.string(from: Date())
    }
    
    private func setDateFormatter() {
        formatter.dateFormat = "yy년 MM월 dd일"
    }
    
    
    func dateToString(date: Date) -> String {
        return formatter.string(from: date)
    }
    
    
    func stringToDate(string: String) -> Date? {
        return formatter.date(from: string)
    }
}
