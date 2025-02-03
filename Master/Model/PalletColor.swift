//
//  PalletColor.swift
//  Master
//
//  Created by Sinakhanjani on 12/4/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation
//
//struct PalletColor: Codable {
//
//    static public var archiveURL: URL {
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        return documentsDirectory.appendingPathComponent("colors").appendingPathExtension("cl")
//    }
//
//    var r: CGFloat
//    var g: CGFloat
//    var b: CGFloat
//    var alpha: CGFloat = 1.0
//
//
//    static func encode(colors: [PalletColor], directory dir: URL) {
//        let propertyListEncoder = PropertyListEncoder()
//        if let encodedProduct = try? propertyListEncoder.encode(colors) {
//            try? encodedProduct.write(to: dir, options: .noFileProtection)
//        }
//    }
//
//    static func decode(directory dir: URL) -> [PalletColor]? {
//        let propertyListDecoder = PropertyListDecoder()
//        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode([PalletColor].self, from: retrievedProductData) {
//            return decodedProduct
//        }
//        return nil
//    }
//
//
//}

struct PalletColor: Codable {
    
    static public var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("colors").appendingPathExtension("cl")
    }

    var r : CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, alpha: CGFloat = 1.0
    
    var uiColor : UIColor {
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    init(uiColor : UIColor) {
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &alpha)
    }
    
    static func encode(colors: [PalletColor], directory dir: URL) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(colors) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> [PalletColor]? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode([PalletColor].self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }

}
