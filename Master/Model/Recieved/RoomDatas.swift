//
//  RoomDatas.swift
//  ChirehBMS
//
//  Created by Teodik Abrami on 1/17/19.
//  Copyright © 2019 Teodik Abrami. All rights reserved.
//

import Foundation

struct RoomDatas: Codable {
    let result: Bool
    let id: Int
    let description: String
    let data: [RoomDatasDatum]
    
    static public var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("RoomIds").appendingPathExtension("RoomIds")
    }
    
    static func encode(userInfo: RoomDatas, directory dir: URL) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(userInfo) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> RoomDatas? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode(RoomDatas.self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "ID"
        case description = "Description"
        case data = "Data"
    }
}

struct RoomDatasDatum: Codable {
    let roomID, name, image: String
    
    enum CodingKeys: String, CodingKey {
        case roomID = "RoomID"
        case name = "Name"
        case image = "Image"
    }
}


