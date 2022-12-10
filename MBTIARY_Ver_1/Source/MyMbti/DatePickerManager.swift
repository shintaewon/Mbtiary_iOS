//
//  DatePickerManager.swift
//  chartt
//
//  Created by 정혜윤 on 2022/11/26.
//

import Foundation

protocol DatePickerManager {
    
}

extension DatePickerManager {
    func convertDate(in date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
