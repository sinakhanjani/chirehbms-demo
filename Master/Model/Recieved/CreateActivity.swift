//
//  CreateActivity.swift
//  ChirehBMS
//
//  Created by Teodik Abrami on 1/19/19.
//  Copyright © 2019 Teodik Abrami. All rights reserved.
//

import Foundation

struct CreateActivity: Codable {
    let result: Bool
    let id: Int
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "ID"
        case description = "Description"
    }
}
