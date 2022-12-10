//
//  DiaryListResponse.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/11/25.
//

import Foundation

// MARK: - Welcome
struct DiaryListResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [DiaryListContents]
}

// MARK: - Result
struct DiaryListContents: Codable {
    let contents: String
    let imgURL: String
    let createdAt: String
    let diaryIdx: Int
    let mbti: String?
    
    enum CodingKeys: String, CodingKey {
        case contents
        case imgURL = "imgUrl"
        case createdAt, diaryIdx, mbti
    }
}
