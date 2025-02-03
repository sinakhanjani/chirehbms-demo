//
//  CheckActivity.swift
//  Master
//
//  Created by Teodik Abrami on 2/1/19.
//  Copyright © 2019 iPersianDeveloper. All rights reserved.
//

import Foundation

struct CheckActivity: Codable {
    
    let result: Bool
    let id: Int
    let description: String
    var data: [CheckActivityDatum]
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "ID"
        case description = "Description"
        case data = "Data"
    }
}

struct CheckActivityDatum: Codable {
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

struct SaveSwitchStatus: Codable {
    
    static public var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("switchStatus").appendingPathExtension("inf")
    }
    
    var savedData: [CheckActivityDatum]
    
    enum CodingKeys: String, CodingKey {
        case savedData = "Data"
    }
    
    static func encode(userInfo: SaveSwitchStatus, directory dir: URL) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(userInfo) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> SaveSwitchStatus? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode(SaveSwitchStatus.self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }
    
}
