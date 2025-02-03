//
//  DataManager.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class DataManager {
    
    static let shared = DataManager()
    
    public var activities: CheckActivity?
    
    public var userInformation: UserInformation? {
        get {
            return UserInformation.decode(directory: UserInformation.archiveURL)
        }
        set {
            if let encode = newValue {
                UserInformation.encode(userInfo: encode, directory: UserInformation.archiveURL)
            }
        }
    }
    
    public var applicationLanguage: Constant.Language = .fa {
        didSet {
            NotificationCenter.default.post(name: Constant.Notify.LanguageChangedNotify, object: nil)
        }
        willSet {
            UserDefaults.standard.set(newValue.rawValue, forKey: "LANGUAGE")
        }
    }
    
    public var isMultiLanguage: Bool = true
    public var local = true
    
    public var isLoggedInWithPassowrd: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "AUTHENTICATION_PASSWORD")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AUTHENTICATION_PASSWORD")
        }
    }
    
    
    public var sound: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "sound") 
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "sound")
        }
    }
    
    public var pictures: [String:Data] {
        get {
            
            return UserDefaults.standard.dictionary(forKey: "ImageOfRooms") as? [String : Data] ?? [:]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ImageOfRooms")
        }
    }
    
    public var savedData: SaveSwitchStatus? {
        get {
            return SaveSwitchStatus.decode(directory: SaveSwitchStatus.archiveURL)
        }
        set {
            if let encode = newValue {
                SaveSwitchStatus.encode(userInfo: encode, directory: SaveSwitchStatus.archiveURL)
            }
        }
    }
    
    public var applicationPassword: String {
        get {
            return  UserDefaults.standard.value(forKey: "PASSWORD_LOGIN") as? String ?? ""
        }
        set {
             UserDefaults.standard.set(newValue, forKey: "PASSWORD_LOGIN")
            if newValue == "" {
                self.isLoggedInWithPassowrd = false
            } else {
                self.isLoggedInWithPassowrd = true
            }
        }
    }
    
    
    
}
