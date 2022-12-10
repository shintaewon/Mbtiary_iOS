//
//  NewDiaryPostMlResponse.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/11/09.

import Foundation

// MARK: - Welcome
struct NewDiaryPostMlResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: NewDiaryMbtiResult
}

// MARK: - Result
struct NewDiaryMbtiResult: Codable {
    let enfj, enfp, entj, entp: Int
    let esfj, esfp, estj, estp: Int
    let infj, infp, intj, intp: Int
    let isfj, isfp, istj, istp: Int
    let mbti: String
}

