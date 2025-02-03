//
//  Login.swift
//  ChirehBMS
//
//  Created by Teodik Abrami on 1/17/19.
//  Copyright © 2019 Teodik Abrami. All rights reserved.
//

import Foundation

struct Login: Codable {
    
    static public var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("userInfo").appendingPathExtension("inf")
    }
    
    let result: Bool
    let id: Int
    let description: String
    let data: DataClass
    let building: String
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "ID"
        case description = "Description"
        case data = "Data"
        case building = "Building"
    }
    
    static func encode(userInfo: Login, directory dir: URL) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(userInfo) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> Login? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode(Login.self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }
}

struct DataClass: Codable {
    let token, bid, uid, ssid: String
    let password, eip, wip: String
    
    enum CodingKeys: String, CodingKey {
        case token = "Token"
        case bid = "BID"
        case uid = "UID"
        case ssid = "SSID"
        case password = "Password"
        case eip = "EIP"
        case wip = "WIP"
    }
}
