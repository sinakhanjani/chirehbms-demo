//
//  UserInformation.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct UserInformation: Codable {
    
    static public var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("userInfo").appendingPathExtension("inf")
    }
    
    let result: Bool
    let id: Int
    let description: String
    let data: UserDataClass
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "ID"
        case description = "Description"
        case data = "Data"
    }
    
    
    
    
    static func encode(userInfo: UserInformation, directory dir: URL) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(userInfo) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> UserInformation? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode(UserInformation.self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }
    
    
}

struct UserDataClass: Codable {
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
