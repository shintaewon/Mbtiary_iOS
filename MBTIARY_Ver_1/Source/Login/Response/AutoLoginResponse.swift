//
//  AutoLoginResponse.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/11/17.
//

import Foundation

// MARK: - Welcome
struct AutoLoginResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}
