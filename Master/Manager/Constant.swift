//
//  Constant.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class Constant {
    
    struct Notify {
        static let dismissIndicatorViewControllerNotify = Notification.Name("dismissIndicatorViewController")
        static let LanguageChangedNotify = Notification.Name("languageChangedNotify")
        static let localOrWifiNotify = Notification.Name("localOrWifi")
        static let readActivityUpdated = Notification.Name("readActivityUpdated")
        static let mainViewAppeare = Notification.Name("MainViewAppear")
    }
    
    struct Fonts {
        static let fontOne = "IRANSansMobile(FaNum)"
        static let fontTwo = "IRANSansMobileFaNum-Bold"
    }
    
    struct Google {
        static let api = "GOOGLE MAP API KEY"
    }
    
    enum Alert {
        case none, failed, success, json
    }
    
    enum Language: Int {
        case fa, en
    }
    
    enum Cell: String {
        case sideTableCell, homeCollectionCell, lightingSwitchCell, socketSwitchCell, curtainSwitchCell, irrigationSwitchCell, lightingCell, scenarioCell,musicFileCell, socketCell, irrigrationCell, tempSwitchCell, tempCell, doorCell, curtainCell
    }
    
    enum Segue: String {
        case toMusicFileSegue, toRemoteSegue
    }
    
}

