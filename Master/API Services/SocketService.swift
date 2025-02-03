//
//  SocketService.swift
//  ChirehBMS
//
//  Created by Teodik Abrami on 1/17/19.
//  Copyright © 2019 Teodik Abrami. All rights reserved.
//

import Foundation
import Socket
import NetworkExtension
import SystemConfiguration.CaptiveNetwork
import SwiftSocket

class SocketService {
    
    static let instance = SocketService()
    
    func checkStatus() -> Bool {
        do {
            guard let login = DataManager.shared.userInformation else { return false }
            let socket = try Socket.create()
            socket.readBufferSize = 1024
            if getWiFiName2() {
                try? socket.connect(to: login.data.wip, port: 3030)
                 print("         test",socket.isConnected)
                if socket.isConnected {
                     print("         check",socket.isConnected)
                    socket.close()
                    return true
                } else {
                     print("         check",socket.isConnected)
                    socket.close()
                    return false
                }
            } else {
                try? socket.connect(to: "95.216.21.234", port: 3030)
                print("         test",socket.isConnected)
                if socket.isConnected {
                    print("         check",socket.isConnected)
                    socket.close()
                    return true
                } else {
                    print("         check",socket.isConnected)
                    socket.close()
                    return false
                }
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
//    func login(username: String, password: String,completion: @escaping (_ connected: Bool) -> Void) {
//        do {
//            let socket = try Socket.create()
//            socket.readBufferSize = 1024
//           // try socket.setReadTimeout(value: 30)
//            try socket.connect(to: "95.216.21.234", port: 3030)
//            print("socket Connected to \(socket.remoteHostname)")
//            let seg1 = "\nguest|" //token
//            let seg2 = "AppLogin|" //ApiName
//            let seg3 = "\(username)" + "@" + "\(password)" // username@password
//            let seg4 = "#end" // end
//            let socketwrite = seg1 + seg2 + seg3 + seg4
//            for character in socketwrite {
//                try socket.write(from: "\(character)")
//            }
//            print("data sent")
//            var testData = Data()
//            let _ = try socket.read(into: &testData)
//            socket.close()
//            print(String(data: testData, encoding: .utf8)!)
//            let decoder = JSONDecoder()
//            let decodedJson = try decoder.decode(Login.self, from: testData)
//            Login.encode(userInfo: decodedJson, directory: Login.archiveURL)
//            Authentication.auth.authenticationUser(token: decodedJson.data.token, isLoggedIn: true)
//            completion(true)
//            print("Done")
//            print(decodedJson)
//        } catch {
//            completion(false)
//            print("error " + error.localizedDescription)
//        }
//    }
    
    func login(username: String, password: String,completion: @escaping (_ connected: Bool) -> Void) {
        do {
            
            //            let socket = try Socket.create()
            //            socket.readBufferSize = 1024
            //           // try socket.setReadTimeout(value: 30)
            //            try socket.connect(to: "95.216.21.234", port: 3030)
            //     print("socket Connected to \(socket.remoteHostname)")
            let seg1 = "\nguest|" //token
            let seg2 = "AppLogin|" //ApiName
            let seg3 = "\(username)" + "@" + "\(password)" // username@password
            let seg4 = "#end" // end
            let socketwrite = seg1 + seg2 + seg3 + seg4
            //            for character in socketwrite {
            //                try socket.write(from: "\(character)")
            //            }
            //            print("data sent")
            //            var testData = Data()
            //            let _ = try socket.read(into: &testData)
            //            socket.close()
            //            print(String(data: testData, encoding: .utf8)!)
            let client = TCPClient(address: "95.216.21.234", port: 3030)
            switch client.connect(timeout: 10) {
            case .success:
                // Connection successful 🎉
                //                var byteArray = [Byte]()
                //                for char in socketwrite.utf8{
                //                    byteArray += [char]
                //                }
                let dispatchGroup = DispatchGroup()
                for (index,item) in socketwrite.enumerated() {
                    dispatchGroup.enter()
                    let send = client.send(string: "\(item)")
                    if send.isSuccess {
                        if index < 3 {
                            sleep(1)
                        }
                        dispatchGroup.leave()
                    } else {
                        completion(false)
                        return
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2, execute: {
                        guard let data = client.read(1024, timeout: 10),
                            let dataString = String(bytes: data, encoding: .utf8),
                            let cleanData = dataString.data(using: .utf8) else { return }
                        
                        let decoder = JSONDecoder()
                        if let decodedJson = try? decoder.decode(Login.self, from: cleanData) {
                            Login.encode(userInfo: decodedJson, directory: Login.archiveURL)
                            Authentication.auth.authenticationUser(token: decodedJson.data.token, isLoggedIn: true)
                            print("Done")
                            print(decodedJson)
                            print("success *****************")
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                }
            case .failure(let error):
                print("error occured \(error.localizedDescription)")
            }
        } catch {
            completion(false)
            print("error " + error.localizedDescription)
        }
    }
    
    func getRooms(completion: @escaping (_ roomDatas: RoomDatas?) -> Void) {
        do {
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
           // try socket.setReadTimeout(value: 30)
            socket.readBufferSize = 1024
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                try socket.connect(to: "95.216.21.234", port: 3030)
            }
            print("socket Connected to \(socket.remoteHostname)")
            let token = login.data.token
            let unitID = login.data.uid
            let socketwrite = "\n" + token + "|" + "GetRooms|" + unitID + "#end"
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            
            var roomsData = Data()
            let _ = try socket.read(into: &roomsData)
            socket.close()
            let decoder = JSONDecoder()
            let decodedJson = try decoder.decode(RoomDatas.self, from: roomsData)
           
            completion(decodedJson)
            print("Done")
            print(decodedJson)
        } catch {
            completion(nil)
            print("error " + error.localizedDescription)
        }
    }
    
    func getScenarios(completion: @escaping (_ scenarios: Scenarios?) -> Void) {
        do {
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
         //   try socket.setReadTimeout(value: 30)
            socket.readBufferSize = 1024
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                try socket.connect(to: "95.216.21.234", port: 3030)
            }
            print("socket Connected to \(socket.remoteHostname)")
            let token = login.data.token
            let unitID = login.data.uid
            //Token|GetScenario|UID
            let socketwrite = "\n" + token + "|" + "GetScenario|" + unitID + "#end"
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            //try socket.write(from: socketwrite)
            var roomsData = Data()
            let _ = try socket.read(into: &roomsData)
            socket.close()
            let decoder = JSONDecoder()
            let decodedJson = try decoder.decode(Scenarios.self, from: roomsData)
            
            completion(decodedJson)
            print("Done")
            print(decodedJson)
        } catch {
            completion(nil)
            print("error " + error.localizedDescription)
        }
    }
    
    
  
    
    // age roomID vared nashe hameye module haro miare va age id morede nazar bezani module e uno miare
    func modulesOfRoom(roomID: String = "0", moduleType: ModuleTypes, completion: @escaping (_ modules: GetModules?) -> Void) {
        do {
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
          //  try socket.setReadTimeout(value: 30)
            socket.readBufferSize = 1024
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                try socket.connect(to: "95.216.21.234", port: 3030)
            }
            
            print("socket Connected to \(socket.remoteHostname)")
            //Token|API|UnitID|RoomID#end
            let token = login.data.token
            let unitID = login.data.uid
            let socketwrite = "\n" + token + "|" + "GetModules|" + unitID + "|" + roomID + "|" + moduleType.rawValue + "#end"
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            var getModules = Data()
            let _ = try socket.read(into: &getModules)
            socket.close()
            print(String(data: getModules, encoding: .utf8)!)
            let decoder = JSONDecoder()
            let decodedJson = try decoder.decode(GetModules.self, from: getModules)
            completion(decodedJson)
            print("Done")
            print(decodedJson)
        } catch {
            completion(nil)
            print("error " + error.localizedDescription)
        }
    }
    
    // khamush ya roshan kardan (module) ya run kardane (scenario)
    func createActivity(activityName: ActivityNames, firstParam: String, secondParam: String = "", bridge: Int? = nil, completion: @escaping (_ create: CreateActivity?) -> Void) {
        do {
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
         //   try socket.setReadTimeout(value: 30)
            socket.readBufferSize = 1024
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                try socket.connect(to: "95.216.21.234", port: 3030)
            }
            print("socket Connected to \(socket.remoteHostname)")
            //Token|CreateActivity|UID|operator|data1|data2#end
            
            //Token|CreateActivity|UID|module|moduleName|Button2on#end
            //Token|CreateActivity|UID|scenaro|scenario name|active or deactive|#end
            let token = login.data.token
            let unitID = login.data.uid
            var socketwrite = ""
            if let bridge = bridge {
                socketwrite = "\n" + token + "|" + "CreateActivity|" + unitID + "|" + activityName.rawValue + "|" + firstParam + "|" + "\(bridge)|" + secondParam + "|" + "#end"
            } else {
                socketwrite = "\n" + token + "|" + "CreateActivity|" + unitID + "|" + activityName.rawValue + "|" + firstParam + "|" + secondParam + "||" + "#end"
            }
            
            print(socketwrite)
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            var roomsData = Data()
            let _ = try socket.read(into: &roomsData)
            print(String(data: roomsData, encoding: .utf8)!)
            socket.close()
            let decoder = JSONDecoder()
            let decodedJson = try decoder.decode(CreateActivity.self, from: roomsData)
            if let bridge = bridge {
                let save = CheckActivityDatum.init(datumOperator: "", data1: firstParam, data2: "\(bridge)", data3: secondParam, dateTime: "")
                if let appendedData = DataManager.shared.savedData {
                    var check = appendedData
                    let index = appendedData.savedData.lastIndex { (act) -> Bool in
                        if act.data1 == firstParam {
                            if act.data2 == "\(bridge)" {
                                return true
                            }
                        }
                        return false
                    }
                    if let index = index {
                        check.savedData.remove(at: index)
                    }
                    
                    check.savedData.append(save)
                    DataManager.shared.savedData = check
                } else {
                    let checked = SaveSwitchStatus.init(savedData: [save])
                    DataManager.shared.savedData = checked
                }
            } else {
                let save = CheckActivityDatum.init(datumOperator: "", data1: firstParam, data2: secondParam, data3: "", dateTime: "")
                if let appendedData = DataManager.shared.savedData {
                    var check = appendedData
                    let index = appendedData.savedData.lastIndex { (act) -> Bool in
                        if act.data1 == firstParam {
                            return true
                        }
                        return false
                    }
                    if let index = index {
                        check.savedData.remove(at: index)
                    }
                    check.savedData.append(save)
                    DataManager.shared.savedData = check
                } else {
                    let checked = SaveSwitchStatus.init(savedData: [save])
                    DataManager.shared.savedData = checked
                }
            }
            completion(decodedJson)
           // NotificationCenter.default.post(name: Constant.Notify.mainViewAppeare, object: nil)
            print("Done")
            print(decodedJson)
        } catch {
            completion(nil)
            print("error " + error.localizedDescription)
        }
    }
    
    
    func checkActivity() {
        do {
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
         //   try socket.setReadTimeout(value: 30)
            socket.readBufferSize = 1024
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                try socket.connect(to: "95.216.21.234", port: 3030)
            }
            print("socket Connected to \(socket.remoteHostname)")
            //Token|CheckActivity|UID#end
            let token = login.data.token
            let unitID = login.data.uid
            let socketwrite = "\n" + token + "|" + "CheckActivity|" + unitID + "#end"
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            var roomsData = Data()
            while String.init(data: roomsData, encoding: .utf8)?.suffix(2) != "}\r\n" {
                let _ = try socket.read(into: &roomsData)
            }
            let cutted =  String.init(data: roomsData, encoding: .utf8)?.replacingOccurrences(of: "\r\n", with: "")
            roomsData = (cutted?.data(using: .utf8))!
            print(String(data: roomsData, encoding: .utf8)!)
            socket.close()
            let decoder = JSONDecoder()
            let decodedJson = try decoder.decode(CheckActivity.self, from: roomsData)
            ReadController.instance.check = decodedJson
            print("Done")
            print(decodedJson)
            
        } catch {
            print("error " + error.localizedDescription)
        }
    }
    
    
    // state akharin taghiro az tu server beman mide
    func readActivity(completion: @escaping (_ readed: ReadActivity?) -> Void) {
        do {
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
         //   try socket.setReadTimeout(value: 30)
            socket.readBufferSize = 32768
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                try socket.connect(to: "95.216.21.234", port: 3030)
            }
            print("socket Connected to \(socket.remoteHostname)")
            //Token|API|UID#end
            let token = login.data.token
            let unitID = login.data.uid
            let socketwrite = "\n" + token + "|" + "ReadActivity|" + unitID + "|" + "#end"
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            // data dare tu chand ghesmate 1kb i miad bayad sabr konim kole data biad bad decod konim
            
            var roomsData = Data()
            var test = String(data: roomsData, encoding: .utf8)?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: " ", with: "")
            while test?.last != "}" {
                let _ = try socket.read(into: &roomsData)
                test = String(data: roomsData, encoding: .utf8)?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: " ", with: "")
            }
            
            print( "data1" + String(data: roomsData, encoding: .utf8)!)

            var string = String(data: roomsData, encoding: .utf8)
            guard string != nil else { completion(nil) ; return }
            string! = string!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: " ", with: "")
            
            roomsData = string!.data(using: .utf8)!
            
            print(string!)
            socket.close()
            let decoder = JSONDecoder()
            let decodedJson = try decoder.decode(ReadActivity.self, from: roomsData)
            
            completion(decodedJson)
            print("Done")
         //   print(decodedJson)
        } catch {
            completion(nil)
            print("error " + error.localizedDescription)
        }
    }
    
    
    
    func getMusic(completion: @escaping (_ musics: Music?) -> Void) {
        do {
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
        //    try socket.setReadTimeout(value: 30)
            socket.readBufferSize = 1024
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                try socket.connect(to: "95.216.21.234", port: 3030)
            }
            print("socket Connected to \(socket.remoteHostname)")
            //Token|GetMusic
            let token = login.data.token
            //let unitID = login.data.uid
            let socketwrite = "\n" + token + "|" + "GetMusic" + "#end"
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            var music = Data()
            var test = String(data: music, encoding: .utf8)?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: " ", with: "")
            let _ = try socket.read(into: &music)
            while test?.last != "}" {
                let _ = try socket.read(into: &music)
                test = String(data: music, encoding: .utf8)?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: " ", with: "")
            }
            let cutted =  String.init(data: music, encoding: .utf8)?.replacingOccurrences(of: "\r\n", with: "").replacingOccurrences(of: "\n", with: "")
            music = (cutted?.data(using: .utf8))!
            print(String(data: music, encoding: .utf8)!)
            socket.close()
            let decoder = JSONDecoder()
            let decodedJson = try decoder.decode(Music.self, from: music)
            print("Done")
            completion(decodedJson)
        } catch {
            completion(nil)
            print("error " + error.localizedDescription)
        }
    }
    
    
    func getLastScenario() {
        do {
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
            //    try socket.setReadTimeout(value: 30)
            socket.readBufferSize = 1024
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                try socket.connect(to: "95.216.21.234", port: 3030)
            }
            print("socket Connected to \(socket.remoteHostname)")
            //Token|GetMusic
            let token = login.data.token
            let unitID = login.data.uid
            let socketwrite = "\n" + token + "|" + "GetLast|" + unitID + "#end"
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            var music = Data()
            let _ = try socket.read(into: &music)
            print(String(data: music, encoding: .utf8)!)
            socket.close()
            let decoder = JSONDecoder()
            let decodedJson = try decoder.decode(LastScenario.self, from: music)
            ReadController.instance.lastScenario = decodedJson
        } catch {
         //   completion(nil)
            print("error " + error.localizedDescription)
        }
    }
    
    
    func playMusic(musicName: String,completion: @escaping (_ played: Bool) -> Void) {
        do {
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
        //    try socket.setReadTimeout(value: 30)
            socket.readBufferSize = 1024
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                completion(false)
                return
            }
            print("socket Connected to \(socket.remoteHostname)")
            //Token|PlayMusic|MusicName
            let token = login.data.token
            //let unitID = login.data.uid
            let socketwrite = "\n" + token + "|" + "PlayMusic|" + musicName  + "#end"
            print(socketwrite)
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            var music = Data()
            let _ = try socket.read(into: &music)
            print(String(data: music, encoding: .utf8)!)
            socket.close()
            let decoder = JSONDecoder()
            let decodedJson = try decoder.decode(DefaultResponse.self, from: music)
            if decodedJson.result {
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            completion(false)
            print("error " + error.localizedDescription)
        }
    }
    
    
    func musicActions(action: MusicActions, completion: @escaping (_ done: Bool) -> Void) {
        do {
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
       //     try socket.setReadTimeout(value: 30)
            socket.readBufferSize = 1024
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                completion(false)
                return
            }
            print("socket Connected to \(socket.remoteHostname)")
            //Token|PlayMusic|MusicName
            let token = login.data.token
            //let unitID = login.data.uid
            let socketwrite = "\n" + token + "|" + action.rawValue + "#end"
            print(socketwrite)
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            var music = Data()
            let _ = try socket.read(into: &music)
            print(String(data: music, encoding: .utf8)!)
            socket.close()
            let decoder = JSONDecoder()
            let decodedJson = try decoder.decode(DefaultResponse.self, from: music)
            if decodedJson.result {
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            completion(false)
            print("error " + error.localizedDescription)
        }
    }
    
    
    func uploadPics(picData: Data, roomId: String, completion: @escaping (_ sent: Bool) -> Void) {
        do {
            let imageDataString = picData.base64EncodedString()
            print(imageDataString.count)
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
        //    try socket.setReadTimeout(value: 30)
            socket.readBufferSize = 1024
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                try socket.connect(to: "95.216.21.234", port: 3030)
            }
            print("socket Connected to \(socket.remoteHostname)")
            //Token|PlayMusic|MusicName
            let token = login.data.token
            //let unitID = login.data.uid
            let socketwrite = "\n" + token + "|" + "UploadRoomPic|" + "jpg|" + roomId
            print(socketwrite)
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            sleep(1)
            try socket.write(from: "#SD")
            sleep(1)
            for char in imageDataString {
                try socket.write(from: "\(char)")
            }
            sleep(2)
            try socket.write(from: "#ED")
            var music = Data()
            let _ = try socket.read(into: &music)
            print(String(data: music, encoding: .utf8)!)
            socket.close()
            let decoder = JSONDecoder()
            let decodedJson = try decoder.decode(DefaultResponse.self, from: music)
            if decodedJson.result {
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            completion(false)
            print("error " + error.localizedDescription)
        }
    }
    
    
    func getRoomsTemp(completion: @escaping (_ roomsTemp: RoomTemp?) -> Void) {
        do {
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
            try socket.setReadTimeout(value: 5)
            socket.readBufferSize = 1024
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                try socket.connect(to: "95.216.21.234", port: 3030)
            }
            print("socket Connected to \(socket.remoteHostname)")
            //Token|PlayMusic|MusicName
            let token = login.data.token
            //let unitID = login.data.uid
            let socketwrite = "\n" + token + "|" + "GetRoomsTemp" + "#end"
            print(socketwrite)
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            var temp = Data()
            while String.init(data: temp, encoding: .utf8)?.last != "}" {
                let _ = try socket.read(into: &temp)
            }
            print(String(data: temp, encoding: .utf8)!)
            socket.close()
            let decoder = JSONDecoder()
            let decodedJson = try decoder.decode(RoomTemp.self, from: temp)
            completion(decodedJson)
        } catch {
            completion(nil)
            print("error " + error.localizedDescription)
        }
    }
    
    
    func getRoomsPicture(picName: String, completion: @escaping (_ image: UIImage?) -> Void) {
        do {
            guard let login = DataManager.shared.userInformation else { return }
            let socket = try Socket.create()
          //  try socket.setReadTimeout(value: 30)
            socket.readBufferSize = 1024
            if getWiFiName() {
                try socket.connect(to: login.data.wip, port: 3030)
            } else {
                try socket.connect(to: "95.216.21.234", port: 3030)
            }
            print("socket Connected to \(socket.remoteHostname)")
            //Token|PlayMusic|MusicName
            let token = login.data.token
            //let unitID = login.data.uid
            let socketwrite = "\n" + token + "|" + "DownloadRoomPic|" + picName + "#end"
            print(socketwrite)
            for character in socketwrite {
                try socket.write(from: "\(character)")
            }
            var pic = Data()
            let _ = try socket.read(into: &pic)
            
            let check = String.init(data: pic, encoding: .utf8) ?? "{"
            guard check.first != "{" else { completion(nil) ; return }
            while String.init(data: pic, encoding: .utf8)?.suffix(3) != "#ED" {
                let _ = try socket.read(into: &pic)
            }
            let cutted = String.init(data: pic, encoding: .utf8) ?? ""
            let endIndex = cutted.index(cutted.endIndex, offsetBy: -3)
            let truncated = String(cutted[..<endIndex])
            if let cuttedData = Data.init(base64Encoded: truncated) {
                let image = UIImage.init(data: cuttedData)
                completion(image)
            }
            socket.close()
            
        } catch {
            completion(nil)
            print("error " + error.localizedDescription)
        }
    }
    
    // sina
    func getWiFiName() -> Bool {
        guard let login = DataManager.shared.userInformation else { return false }
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    if ssid == login.data.ssid {
                        DataManager.shared.local = true
                        NotificationCenter.default.post(name: Constant.Notify.localOrWifiNotify, object: nil)
                        return true
                    } else {
                        NotificationCenter.default.post(name: Constant.Notify.localOrWifiNotify, object: nil)
                        DataManager.shared.local = false
                        return false
                    }
                }
            }
        }
        NotificationCenter.default.post(name: Constant.Notify.localOrWifiNotify, object: nil)
        DataManager.shared.local = false
        return false
    }
    
    // sina
    func getWiFiName2() -> Bool {
        guard let login = DataManager.shared.userInformation else { return false }
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    if ssid == login.data.ssid {
                        DataManager.shared.local = true
                        return true
                        } else {
                        DataManager.shared.local = false
                        return false
                    }
                }
            }
        }
        return false
    }
}

public enum ModuleTypes: String {
    case Switch = "Switch"
    case Irrigation = "Irrigation"
    case Curtain = "Curtain"
    case Door = "Door"
    case Socket = "Socket"
    case Thermostat = "Thermostat"
    case Server = "Server"
}

public enum ActivityNames: String {
    case Module, Scenario, Opertator, Thermostat
}


public enum MusicActions: String {
    case NextMusic
    case PrevMusic
    case MusicVolUp
    case MusicVolDown
    case StopMusic
    case UploadMusic
}
