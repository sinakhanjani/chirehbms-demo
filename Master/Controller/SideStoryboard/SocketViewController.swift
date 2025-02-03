//
//  SocketViewController.swift
//  Master
//
//  Created by Sinakhanjani on 11/3/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class SocketViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var module: GetModules?
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
        startIndicatorAnimate()
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
        if let module = GetModules.decode(directory: GetModules.archiveURL(module: .Socket)) {
            self.module = module
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.stopIndicatorAnimate()
            }
        } else {
            SocketService.instance.modulesOfRoom(moduleType: .Socket) { (module) in
                guard let module = module else { self.stopIndicatorAnimate() ; self.presentTryLater() ; return }
                GetModules.encode(modules: module, directory: GetModules.archiveURL(module: .Socket))
                self.module = module
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.stopIndicatorAnimate()
                }
            }
        }
    }
    
    static func showModal() -> SocketViewController {
        let storyboard = UIStoryboard.init(name: "Side", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SocketViewControllerID") as! SocketViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }

}

extension SocketViewController:UICollectionViewDataSource, UICollectionViewDelegate, SwitchMasterCollectionViewCellDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return module?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.socketCell.rawValue, for: indexPath) as! SwitchMasterCollectionViewCell
        cell.delegate = self
        guard let module = module?.data[indexPath.row] else { return cell }
        print("                  thouhhjkhkjhjkjhkhkjhjkhjk",ReadController.instance.checkTrueActivities(module: module.name))
        cell.lightSwitches[0].isOn = ReadController.instance.checkTrueActivities(module: module.name)
        let check1 = ReadController.instance.checkServerReaded(moduleName: module.name)
        cell.seenImageView[0].image = check1 ?  #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
        var roomName = ""
        if let rooms = self.rooms {
            for rooms in rooms.data {
                if rooms.roomID == module.room {
                    roomName = rooms.name
                }
            }
        }
        cell.configureCell(numberOfSwitch: 1, modulesName: roomName, roomName: module.name)
        return cell
    }
    
    // *** SWITCH VALUE CHANED ACTION ***
    func switch1ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = module?.data[index].name else { return }
        playSound()
        cell.seenImageView[0].image = #imageLiteral(resourceName: "tick")
        let onOrOff = sender.isOn ? "Active":"Deactive"
        SocketService.instance.createActivity(activityName: .Module, firstParam: activityName, secondParam: onOrOff) { (activity) in
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
        // NOT USER **
    }
    
    func switch3ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        // NOT USER **
    }
    
    func switch4ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        // NOT USE **
    }
    
    
}

