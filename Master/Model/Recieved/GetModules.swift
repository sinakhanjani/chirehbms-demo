//
//  GetModules.swift
//  ChirehBMS
//
//  Created by Teodik Abrami on 1/17/19.
//  Copyright © 2019 Teodik Abrami. All rights reserved.
//

import Foundation

struct GetModules: Codable {
    
    static func archiveURL(module: ModuleTypes, roomID: String = "0") -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("getModules").appendingPathExtension(module.rawValue + roomID)
    }
    
    
    let result: Bool
    let id: Int
    let description: String
    let data: [GetModulesDatum]
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "ID"
        case description = "Description"
        case data = "Data"
    }
    
    
    static func encode(modules: GetModules?, directory dir: URL) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(modules) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> GetModules? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode(GetModules.self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }
}

struct GetModulesDatum: Codable {
    let name, ip, port, room, push, bridge: String
    let On, Off: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case ip = "IP"
        case push = "Push"
        case room = "Room"
        case port = "Port"
        case bridge = "Bridge"
        case On, Off
    }
}
