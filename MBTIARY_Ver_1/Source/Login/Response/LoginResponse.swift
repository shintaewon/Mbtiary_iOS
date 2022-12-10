//
//  LoginResponse.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/10/30.
//

import Foundation

// MARK: - Welcome
struct LoginResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: LoginResult
}

// MARK: - Result
struct LoginResult: Codable {
    let userIdx: Int
    let jwt: String
    let nickname: String
}
