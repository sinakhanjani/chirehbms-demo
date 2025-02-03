//
//  CurtainViewController.swift
//  Master
//
//  Created by Sinakhanjani on 11/3/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class CurtainViewController: UIViewController {

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
        if let module = GetModules.decode(directory: GetModules.archiveURL(module: .Curtain)) {
            self.module = module
            self.collectionView.reloadData()
        } else {
            SocketService.instance.modulesOfRoom(moduleType: .Curtain) { (module) in
                DispatchQueue.main.async {
                    guard let module = module else { self.stopIndicatorAnimate() ; self.presentTryLater() ; return }
                    GetModules.encode(modules: module, directory: GetModules.archiveURL(module: .Curtain))
                    self.module = module
                    self.collectionView.reloadData()
                    // leave
                }
            }
        }
        
    }

    static func showModal() -> CurtainViewController {
        let storyboard = UIStoryboard.init(name: "Side", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CurtainViewControllerID") as! CurtainViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }

    
}

extension CurtainViewController: UICollectionViewDataSource, UICollectionViewDelegate, ButtonMasterCollectionViewCellDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return module?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.curtainCell.rawValue, for: indexPath) as! ButtonMasterCollectionViewCell
        cell.delegate = self
        guard let module = module?.data[indexPath.row] else { return cell }
        let check = ReadController.instance.checkTrueActivities(module: module.name , bridge: 2) ? "Open":"Close"
        self.leftColor(check, onButton: cell.leftOnButton, offButton: cell.leftOffButton)
        
        let check1 = ReadController.instance.checkTrueActivities(module: module.name , bridge: 1) ? "Open":"Close"
        self.rightColor(check1, onButton: cell.rightOnButton, offButton: cell.rightOffButton)
        
        let check2 = ReadController.instance.checkServerReaded(moduleName: module.name, bridge: 1)
        cell.firstTickImageView.image = check2 ?  #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
        let check3 = ReadController.instance.checkServerReaded(moduleName: module.name, bridge: 2)
        cell.secondTickImageView.image = check3 ?  #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
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
    
    // *** SEGMENT VALUE CHANED ACTION ***
    
    func leftOnButtonOn(cell: ButtonMasterCollectionViewCell, onSender: UIButton, offSender: UIButton) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = module?.data[index].name else { return }
        cell.secondTickImageView.image = #imageLiteral(resourceName: "tick")
        playSound()
        let onOrOff = "Open"
        self.leftColor(onOrOff, onButton: onSender, offButton: offSender)
        SocketService.instance.createActivity(activityName: .Module, firstParam: activityName, secondParam: onOrOff, bridge: 2) { (activity) in
            DispatchQueue.main.async {
                if activity?.result ?? false {
                    self.presentIOSOkWarning()
                } else {
                    self.leftColor("Close", onButton: onSender, offButton: offSender)
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
    
    func leftOffButtonOn(cell: ButtonMasterCollectionViewCell, offSender: UIButton, onSender: UIButton) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = module?.data[index].name else { return }
        cell.secondTickImageView.image = #imageLiteral(resourceName: "tick")
        playSound()
        let onOrOff = "Close"
        self.leftColor(onOrOff, onButton: onSender, offButton: offSender)
        SocketService.instance.createActivity(activityName: .Module, firstParam: activityName, secondParam: onOrOff, bridge: 2) { (activity) in
            DispatchQueue.main.async {
                if activity?.result ?? false {
                    self.presentIOSOkWarning()
                } else {
                    //  sender.selectedSegmentIndex = sender.selectedSegmentIndex == 0 ? 1:0
                    self.leftColor("Open", onButton: onSender, offButton: offSender)
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
    
    func rightOnButtonOn(cell: ButtonMasterCollectionViewCell, onSender: UIButton, offSender: UIButton) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = module?.data[index].name else { return }
        cell.firstTickImageView.image = #imageLiteral(resourceName: "tick")
        playSound()
        let onOrOff = "Open"
        self.rightColor(onOrOff, onButton: onSender, offButton: offSender)
        SocketService.instance.createActivity(activityName: .Module, firstParam: activityName, secondParam: onOrOff, bridge: 1) { (activity) in
            DispatchQueue.main.async {
                if activity?.result ?? false {
                    self.presentIOSOkWarning()
                } else {
                    self.presentIOSProblemWarning()
                    self.rightColor("Close", onButton: onSender, offButton: offSender)

                }
            }
        }
    }
    
    func rightOffButtonOn(cell: ButtonMasterCollectionViewCell, offSender: UIButton, onSender: UIButton) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = module?.data[index].name else { return }
        cell.firstTickImageView.image = #imageLiteral(resourceName: "tick")
        playSound()
        let onOrOff = "Close"
        self.rightColor(onOrOff, onButton: onSender, offButton: offSender)
        SocketService.instance.createActivity(activityName: .Module, firstParam: activityName, secondParam: onOrOff, bridge: 1) { (activity) in
            DispatchQueue.main.async {
                if activity?.result ?? false {
                    self.presentIOSOkWarning()
                } else {
                    self.presentIOSProblemWarning()
                    self.rightColor("Open", onButton: onSender, offButton: offSender)
                }
            }
        }
    }
    
        
    
    func leftColor(_ status: String, onButton: UIButton, offButton: UIButton) {
        if status == "Open" {
            onButton.backgroundColor = .black
            offButton.backgroundColor = .white
            onButton.setTitleColor(.white, for: .normal)
            offButton.setTitleColor(.black, for: .normal)
        } else {
            onButton.backgroundColor = .white
            offButton.backgroundColor = .black
            onButton.setTitleColor(.black, for: .normal)
            offButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func rightColor(_ status: String, onButton: UIButton, offButton: UIButton) {
        if status == "Open" {
            onButton.backgroundColor = .black
            offButton.backgroundColor = .white
            onButton.setTitleColor(.white, for: .normal)
            offButton.setTitleColor(.black, for: .normal)
        } else {
            onButton.backgroundColor = .white
            offButton.backgroundColor = .black
            onButton.setTitleColor(.black, for: .normal)
            offButton.setTitleColor(.white, for: .normal)
        }
    }
}

