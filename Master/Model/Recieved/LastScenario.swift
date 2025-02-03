//
//  LastScenario.swift
//  Master
//
//  Created by Teodik Abrami on 3/6/19.
//  Copyright © 2019 iPersianDeveloper. All rights reserved.
//

import Foundation

struct LastScenario: Codable {
    let result: Bool
    let id: Int
    let description, name: String
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "ID"
        case description = "Description"
        case name = "Name"
    }
}
