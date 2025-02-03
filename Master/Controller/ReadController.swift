//
//  ReadController.swift
//  Master
//
//  Created by Teodik Abrami on 2/2/19.
//  Copyright © 2019 iPersianDeveloper. All rights reserved.
//

import Foundation

class ReadController {
    
    static let instance = ReadController()
    
    var check: CheckActivity? {
        didSet {
            NotificationCenter.default.post(name: Constant.Notify.readActivityUpdated, object: nil)
        }
    }
    
    var lastScenario: LastScenario?
    
    func checkTrueActivities(module name: String, bridge: Int? = nil) -> Bool {
        guard let allData = DataManager.shared.savedData?.savedData  else { return false }
        print(allData)
        let index = allData.lastIndex { (data) -> Bool in
            if data.data1 == name {
                if let bridgeChecked = bridge {
                    if "\(bridgeChecked)" == data.data2 {
                        if data.data3 == "On" || data.data3 == "Open" {
                            return true
                        }
                    }
                } else {
                    if data.data2 == "Active" {
                        return true
                    } else {
                        return false
                    }
                }
            }
            return false
            }
        if let index = index {
            if let _ = bridge {
                if allData[index].data3 == "On" || allData[index].data3 == "Open" {
                    return true
                } else {
                    return false
                }
            } else {
                if allData[index].data2 == "Active" {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    
    
    func checkServerReaded(moduleName: String, bridge: Int? = nil) -> Bool {
        guard let check = check else { return false }
        for every in check.data {
            if every.data1 == moduleName {
                if let bridge = bridge {
                    if every.data2 == "\(bridge)" {
                        return false
                    }
                } else {
                    return false
                }
            }
        }
        return true
    }
    
    
    
    func checkTrueActivitiesThermustat(module name: String) -> Bool {
        guard let allData = DataManager.shared.savedData?.savedData  else { return false }
        print(allData)
        let index = allData.lastIndex { (data) -> Bool in
            if data.data1 == name {
                if data.data2 == "Medium" || data.data2 == "Low" || data.data2 == "High" || data.data2 == "Heat" || data.data2 == "Cool" {
                    return true
                } else {
                    return false
                }
            }
            return false
        }
        if index != nil {
            return true
        }
        return false
    }
    
    func checkServerReadedThermustatSpeed() -> String? {
        guard let check = DataManager.shared.savedData else { return nil }
        let test = check.savedData.last { (data) -> Bool in
            if data.data1 == "High" || data.data1 == "Low" || data.data1 == "Medium"  {
                return true
            } else {
                return false
            }
        }
        if let data = test {
            return data.data1
        } else {
            return nil
        }
    }
    
    func checkServerReadedThermustatType() -> String? {
        guard let check = DataManager.shared.savedData else { return nil }
        let test = check.savedData.last { (data) -> Bool in
            if data.data1 == "Cool" || data.data1 == "Heat" {
                return true
            } else {
                return false
            }
        }
        if let data = test {
            return data.data1
        } else {
            return nil
        }
    }
    
    
}

