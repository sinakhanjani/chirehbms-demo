//
//  DefaultResponse.swift
//  Master
//
//  Created by Teodik Abrami on 2/3/19.
//  Copyright © 2019 iPersianDeveloper. All rights reserved.
//

import Foundation

struct DefaultResponse: Codable {
    let result: Bool
    let id: Int
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "ID"
        case description = "Description"
    }
}
