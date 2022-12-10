//
//  GetCalendarContentsResponse.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/11/22.
//

import Foundation

// MARK: - Welcome
struct GetCalendarContentsResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [DiaryContents]
}

// MARK: - Result
struct DiaryContents: Codable {
    let contents: String
    let imgURL: String
    let createdAt, mbti: String
    let diaryIdx: Int

    enum CodingKeys: String, CodingKey {
        case diaryIdx, contents
        case imgURL = "imgUrl"
        case createdAt, mbti
    }
}
