//
//  WeeklyMBTI.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/11/29.
//

import Foundation

struct WeeklyMBTI: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [WeeklyuResult]
}

struct WeeklyuResult: Codable {
    let week: Int
    let userMbtiByWeek: UserMbtiByWeek
}

struct UserMbtiByWeek: Codable, MBTI {
    var istjPercent: String
    
    var istpPercent: String
    
    var infjPercent: String
    
    var intjPercent: String
    
    var isfjPercent: String
    
    var isfpPercent: String
    
    var infpPercent: String
    
    var intpPercent: String
    
    var estjPercent: String
    
    var esfpPercent: String
    
    var enfpPercent: String
    
    var entpPercent: String
    
    var esfjPercent: String
    
    var estpPercent: String
    
    var enfjPercent: String
    
    var entjPercent: String
}


