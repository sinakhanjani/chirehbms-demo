//
//  DoorViewController.swift
//  Master
//
//  Created by Sinakhanjani on 11/3/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class DoorViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bgView: UIView!

    var module: GetModules?
    var count = [GetModulesDatum]()
    var rooms: RoomDatas?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicatorAnimate()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Constant.Notify.readActivityUpdated, object: nil)
        print(module)
        print(rooms)
    }

    @objc func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // Method
    func updateUI() {
        addChangedLanguagedToViewController()
        configureStoryboardTouchViewController(bgView: bgView)
        if let module = RoomDatas.decode(directory: RoomDatas.archiveURL) {
            self.rooms = module
        } else {
            DispatchQueue.main.async {
                SocketService.instance.getRooms { (rooms) in
                    guard let rooms = rooms else { self.presentTryLater() ; return }
                    self.rooms = rooms
                    RoomDatas.encode(userInfo: rooms, directory: RoomDatas.archiveURL)
                }
                
            }
        }
        if let module = GetModules.decode(directory: GetModules.archiveURL(module: .Door)) {
            self.module = module
            var check = [GetModulesDatum]()
            for data in module.data {
                let test = data.push.components(separatedBy: ",")
                for h in test {
                    let add = GetModulesDatum(name: data.name, ip: data.ip, port: data.port, room: data.room, push: h, bridge: data.bridge, On: data.On, Off: data.Off)
                    check.append(add)
                }
            }
            self.count = check
            self.collectionView.reloadData()
            self.stopIndicatorAnimate()
        } else {
            SocketService.instance.modulesOfRoom(moduleType: .Server) { (module) in
                DispatchQueue.main.async {
                    guard let module = module else { self.stopIndicatorAnimate() ; self.presentTryLater() ; return }
                    GetModules.encode(modules: module, directory: GetModules.archiveURL(module: .Door))
                    self.module = module
                    var check = [GetModulesDatum]()
                    for data in module.data {
                        let test = data.push.components(separatedBy: ",")
                        for h in test {
                            let add = GetModulesDatum(name: data.name, ip: data.ip, port: data.port, room: data.room, push: h, bridge: data.bridge, On: data.On, Off: data.Off)
                            check.append(add)
                        }
                    }
                    self.count = check
                    self.collectionView.reloadData()
                    self.stopIndicatorAnimate()
                }
            }
        }
    }
    
    static func showModal() -> DoorViewController {
        let storyboard = UIStoryboard.init(name: "Side", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DoorViewControllerID") as! DoorViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
    
}

extension DoorViewController: UICollectionViewDataSource, UICollectionViewDelegate, DoorCollectionViewCellDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.doorCell.rawValue, for: indexPath) as! DoorCollectionViewCell
        cell.delegate = self
        let module = count[indexPath.row]
        let check = ReadController.instance.checkServerReaded(moduleName: module.name, bridge: Int(module.push) ?? 0)
        cell.tickImageView.image = check ? #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
        cell.configureCell(modulesName: module.name + "-" + count[indexPath.row].push, roomName: "")
        return cell
    }
    
    // *** BUTTON ACTION ***
    func doorButtonTapped(cell: DoorCollectionViewCell, sender: RoundedButton) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        let bridge = count[index]
        guard let bridgeNumber = Int(bridge.push) else { return }
        cell.tickImageView.image = #imageLiteral(resourceName: "tick")
        playSound()
        SocketService.instance.createActivity(activityName: .Module, firstParam: bridge.name, secondParam: "On", bridge: bridgeNumber) { (activity) in
            DispatchQueue.main.async {
                if activity?.result ?? false {
                    self.presentIOSOkWarning()
                } else {
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
}

