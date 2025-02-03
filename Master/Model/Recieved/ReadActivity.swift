//
//  ReadActivity.swift
//  ChirehBMS
//
//  Created by Teodik Abrami on 1/19/19.
//  Copyright © 2019 Teodik Abrami. All rights reserved.
//

import Foundation

struct ReadActivity: Codable {
    let result: Bool
    let id: Int
    let description: String
    let data: [CheckActivityDatum]
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "ID"
        case description = "Description"
        case data = "Data"
    }
}

struct ReadActivityDatum: Codable {
    let datumOperator, data1, data2, data3: String
    let dateTime: String
    
    enum CodingKeys: String, CodingKey {
        case datumOperator = "Operator"
        case data1 = "Data1"
        case data2 = "Data2"
        case data3 = "Data3"
        case dateTime = "DateTime"
    }
}
