//
//  CalendarDateResponse.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/11/09.
//

import Foundation

// MARK: - Welcome
struct CalendarDateResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [DataResult]
}

// MARK: - Result
struct DataResult: Codable {
    let diaryIdx: Int
    let createdAt: String
}

