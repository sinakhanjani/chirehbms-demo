//
//  LightingViewController.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 10/30/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class LightingViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var lights: GetModules?
    var rooms: RoomDatas?
    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicatorAnimate()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Constant.Notify.readActivityUpdated, object: nil)
    }
    
    @objc func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let module = RoomDatas.decode(directory: RoomDatas.archiveURL) {
            self.rooms = module
            self.collectionView.reloadData()
        } else {
            DispatchQueue.main.async {
                SocketService.instance.getRooms { (rooms) in
                    guard let rooms = rooms else { self.presentTryLater() ; return }
                    self.rooms = rooms
                    RoomDatas.encode(userInfo: rooms, directory: RoomDatas.archiveURL)
                }
            }
        }
        if let module = GetModules.decode(directory: GetModules.archiveURL(module: .Switch)) {
            self.lights = module
            self.collectionView.reloadData()
            self.stopIndicatorAnimate()
        } else {
            SocketService.instance.modulesOfRoom(moduleType: .Switch) { (lightModule) in
                guard let lightModule = lightModule else { self.stopIndicatorAnimate() ; self.presentTryLater() ; return }
                self.lights = lightModule
                DispatchQueue.main.async {
                    GetModules.encode(modules: lightModule, directory: GetModules.archiveURL(module: .Switch))
                    self.collectionView.reloadData()
                    self.stopIndicatorAnimate()
                }
            }
        }
    }
    
    // Method
    func updateUI() {
        configureStoryboardTouchViewController(bgView: bgView)
        addChangedLanguagedToViewController()
    }
    
    static func showModal() -> LightingViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LightingViewControllerID") as! LightingViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
    
    
}

extension LightingViewController: UICollectionViewDataSource, UICollectionViewDelegate, SwitchMasterCollectionViewCellDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lights?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.lightingCell.rawValue, for: indexPath) as! SwitchMasterCollectionViewCell
        cell.delegate = self
        guard let module = lights?.data[indexPath.row] else { return cell }
        for i in 0...3 {
           cell.lightSwitches[i].isOn = ReadController.instance.checkTrueActivities(module: module.name , bridge: i + 1)
            let check = ReadController.instance.checkServerReaded(moduleName: module.name, bridge: i + 1)
            cell.seenImageView[i].image = check ? #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
        }
        var roomName = ""
        if let rooms = self.rooms {
            for rooms in rooms.data {
                if rooms.roomID == module.room {
                    roomName = rooms.name
                }
            }
        }
        
        cell.configureCell(numberOfSwitch: Int(module.bridge) ?? 0, modulesName: roomName , roomName: module.name)
        
        return cell
    }
    
    // *** SWITCH VALUE CHANED ACTION ***
    func switch1ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = lights?.data[index].name else { return }
        cell.seenImageView[0].image = #imageLiteral(resourceName: "tick")
        playSound()
        let onOrOff = sender.isOn ? "On":"Off"
        SocketService.instance.createActivity(activityName: .Module, firstParam: activityName, secondParam: onOrOff, bridge: 1) { (activity) in
            DispatchQueue.main.async {
                if activity?.result ?? false {
                    self.presentIOSOkWarning()
                } else {
                    sender.isOn = !sender.isOn
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
    
    func switch2ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = lights?.data[index].name else { return }
        cell.seenImageView[1].image = #imageLiteral(resourceName: "tick")
        playSound()
        let onOrOff = sender.isOn ? "On":"Off"
        SocketService.instance.createActivity(activityName: .Module, firstParam: activityName, secondParam: onOrOff, bridge: 2) { (activity) in
            DispatchQueue.main.async {
                if activity?.result ?? false {
                    self.presentIOSOkWarning()
                } else {
                    sender.isOn = !sender.isOn
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
    
    func switch3ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = lights?.data[index].name else { return }
        cell.seenImageView[2].image = #imageLiteral(resourceName: "tick")
        playSound()
        let onOrOff = sender.isOn ? "On":"Off"
        SocketService.instance.createActivity(activityName: .Module, firstParam: activityName, secondParam: onOrOff, bridge: 3) { (activity) in
            DispatchQueue.main.async {
                if activity?.result ?? false {
                    self.presentIOSOkWarning()
                } else {
                    sender.isOn = !sender.isOn
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
    
    func switch4ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = lights?.data[index].name else { return }
        cell.seenImageView[3].image = #imageLiteral(resourceName: "tick")
        playSound()
        let onOrOff = sender.isOn ? "On":"Off"
        SocketService.instance.createActivity(activityName: .Module, firstParam: activityName, secondParam: onOrOff, bridge: 4) { (activity) in
            DispatchQueue.main.async {
                if activity?.result ?? false {
                    self.presentIOSOkWarning()
                } else {
                    sender.isOn = !sender.isOn
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
    
    
}

