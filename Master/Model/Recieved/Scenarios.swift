//
//  Scenarios.swift
//  ChirehBMS
//
//  Created by Teodik Abrami on 1/19/19.
//  Copyright © 2019 Teodik Abrami. All rights reserved.
//

import Foundation

struct Scenarios: Codable {
    
    static public var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("Scenario").appendingPathExtension("Scenario")
    }
    
    let result: Bool
    let id: Int
    let description: String
    let data: [ScenariosDatum]
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "ID"
        case description = "Description"
        case data = "Data"
    }
    
    static func encode(userInfo: Scenarios, directory dir: URL) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(userInfo) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> Scenarios? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode(Scenarios.self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }
}

struct ScenariosDatum: Codable {
    let name, type: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
    }
}
