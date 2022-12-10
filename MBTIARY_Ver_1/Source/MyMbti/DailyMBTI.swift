//
//  DailyMBTI.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/11/29.
//

import Foundation

struct DailyMBTI: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: DaliyResult
}

// MARK: - Result
struct DaliyResult: Codable {
    let diaryIdx: Int
    let contents: String
    let enfjPercent, enfpPercent, entjPercent, entpPercent: Int
    let esfpPercent, esfjPercent, estpPercent, estjPercent: Int
    let infjPercent, infpPercent, intjPercent, intpPercent: Int
    let isfjPercent, isfpPercent, istjPercent, istpPercent: Int
    let mbti: String
    let recommendationDiaryIdx: Int
}
