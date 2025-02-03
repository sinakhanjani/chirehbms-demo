//
//  RoomTemp.swift
//  Master
//
//  Created by Teodik Abrami on 2/25/19.
//  Copyright © 2019 iPersianDeveloper. All rights reserved.
//

import Foundation

struct RoomTemp: Codable {
    let result: Bool
    let id: Int
    let description: String
    let data: [RoomTempDatum]
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "ID"
        case description = "Description"
        case data = "Data"
    }
}

struct RoomTempDatum: Codable {
    let roomID, temp: String
    
    enum CodingKeys: String, CodingKey {
        case roomID = "RoomID"
        case temp = "Temp"
    }
}
