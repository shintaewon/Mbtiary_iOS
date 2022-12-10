//
//  DeleteDiaryResponse.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/12/07.
//

import Foundation

// MARK: - Welcome
struct DeleteDiaryResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}
