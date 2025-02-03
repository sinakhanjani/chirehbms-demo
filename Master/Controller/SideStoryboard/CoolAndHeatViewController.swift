//
//  CoolAndHeatViewController.swift
//  Master
//
//  Created by Sinakhanjani on 11/6/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class CoolAndHeatViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bgView: UIView!

    var thermostatModule: GetModules?
    var rooms: RoomDatas?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Constant.Notify.readActivityUpdated, object: nil)
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
        if let module = GetModules.decode(directory: GetModules.archiveURL(module: .Thermostat)) {
            self.thermostatModule = module
            self.collectionView.reloadData()
        } else {
            SocketService.instance.modulesOfRoom(moduleType: .Thermostat) { (module) in
                self.thermostatModule = module
                DispatchQueue.main.async {
                    guard let module = module else { self.stopIndicatorAnimate() ; self.presentTryLater() ; return }
                    self.thermostatModule = module
                    GetModules.encode(modules: module, directory: GetModules.archiveURL(module: .Thermostat))
                    self.collectionView.reloadData()
                    // leave
                }
            }
        }
        
    }

    static func showModal() -> CoolAndHeatViewController {
        let storyboard = UIStoryboard.init(name: "Side", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CoolAndHeatViewControllerID") as! CoolAndHeatViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }

    
}

extension CoolAndHeatViewController: UICollectionViewDataSource, UICollectionViewDelegate , TempCollectionViewCellDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thermostatModule?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.tempCell.rawValue, for: indexPath) as! TempCollectionViewCell
        cell.delegate = self
        guard let module = thermostatModule?.data[indexPath.row] else { return cell }
        let check = ReadController.instance.checkTrueActivities(module: module.name , bridge: indexPath.row + 1)
        cell.onOffSegmentControl.selectedSegmentIndex = check ? 0 : 1
        let check1 = ReadController.instance.checkServerReaded(moduleName: module.name, bridge: indexPath.row + 1)
        cell.tickImageView.image = check1 ? #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
        let check2 = ReadController.instance.checkServerReadedThermustatSpeed()
        if check2 != nil {
            setThermustat(status: check2!, cell: cell)
        }
        
        let check3 = ReadController.instance.checkServerReadedThermustatType()
        if check3 != nil {
            setThermustatType(status: check3!, cell: cell)
        }
        var roomName = ""
        if let rooms = self.rooms {
            for rooms in rooms.data {
                if rooms.roomID == module.room {
                    roomName = rooms.name
                }
            }
        }
        cell.configureCell(modulesName: roomName, roomName: module.name)
        return cell
    }
    
    func setThermustat(status: String, cell: TempCollectionViewCell) {
        if status == "High" {
            cell.fanSpeedSegmentControl.selectedSegmentIndex = 0
        }
        if status == "Medium" {
            cell.fanSpeedSegmentControl.selectedSegmentIndex = 1
        }
        if status == "Low" {
            cell.fanSpeedSegmentControl.selectedSegmentIndex = 2
        }
    }
    
    
    func setThermustatType(status: String, cell: TempCollectionViewCell) {
        if status == "Heat" {
            cell.fanTypeSegmentControl.selectedSegmentIndex = 1
        }
        if status == "Cool" {
            cell.fanTypeSegmentControl.selectedSegmentIndex = 0
        }
    }
    
    
    // *** ACTION ***
    func tempOnOffValueChanged(cell: TempCollectionViewCell, sender: UISegmentedControl) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        cell.tickImageView.image = #imageLiteral(resourceName: "tick")
        playSound()
        let onOrOff = sender.selectedSegmentIndex == 0 ? "On":"Off"
        SocketService.instance.createActivity(activityName: .Thermostat, firstParam: onOrOff, secondParam: "") { (activity) in
            DispatchQueue.main.async {
                if activity?.result ?? false {
                    self.presentIOSOkWarning()
                } else {
                    sender.selectedSegmentIndex = sender.selectedSegmentIndex == 0 ? 1:0
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
    
    func measureValueChanged(cell: TempCollectionViewCell, sender: UIStepper) {
        // No Api
    }
    
    func fanSpeedValueChanged(cell: TempCollectionViewCell, sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //high
            SocketService.instance.createActivity(activityName: .Thermostat, firstParam: "High", secondParam: "") { (create) in
                if create?.result ?? false {
                    
                } else {
                    self.presentIOSProblemWarning()
                }
            }
        }
        if sender.selectedSegmentIndex == 1 {
            //medium
            SocketService.instance.createActivity(activityName: .Thermostat, firstParam: "Medium", secondParam: "") { (create) in
                if create?.result ?? false {
                    
                } else {
                    self.presentIOSProblemWarning()
                }
            }
        }
        if sender.selectedSegmentIndex == 2 {
            //low
            SocketService.instance.createActivity(activityName: .Thermostat, firstParam: "Low", secondParam: "") { (create) in
                if create?.result ?? false {
                    
                } else {
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
    
    func fanTypeValueChanged(cell: TempCollectionViewCell, sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //cool
            SocketService.instance.createActivity(activityName: .Thermostat, firstParam: "Cool", secondParam: "") { (create) in
                if create?.result ?? false {
                    
                } else {
                    self.presentIOSProblemWarning()
                }
            }
        }
        if sender.selectedSegmentIndex == 1 {
            //heat
            SocketService.instance.createActivity(activityName: .Thermostat, firstParam: "Heat", secondParam: "") { (create) in
                if create?.result ?? false {
                    
                } else {
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
}

