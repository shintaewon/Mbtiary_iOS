//
//  NickNameResponse.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/11/14.
//

import Foundation

// MARK: - Welcome
struct NickNameResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}
