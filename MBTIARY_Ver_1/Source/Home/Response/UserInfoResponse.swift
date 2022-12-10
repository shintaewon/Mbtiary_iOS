//
//  UserInfoResponse.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/12/08.
//

import Foundation

// MARK: - Welcome
struct UserInfoResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: UserInfoResult
}

// MARK: - Result
struct UserInfoResult: Codable {
    let userIdx: Int
    let email, nickname, profileImgURL: String

    enum CodingKeys: String, CodingKey {
        case userIdx, email, nickname
        case profileImgURL = "profileImgUrl"
    }
}
