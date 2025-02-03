//
//  HomeViewController.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 10/30/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import CDAlertView

class HomeTableViewController: UITableViewController, UICollectionViewDelegateFlowLayout {
    
    
    // COLLECTIONVIEW OUTLET
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lightCollectionView: UICollectionView!
    @IBOutlet weak var socketCollectionView: UICollectionView!
    @IBOutlet weak var tempCollectionView: UICollectionView!
    @IBOutlet weak var curtainCollectionView: UICollectionView!
    @IBOutlet weak var irrigationCollectionView: UICollectionView!
    
    fileprivate let dispathGroup = DispatchGroup()
    
    fileprivate let collectionMasterDelegate = SwitchMasterCollectionViewController() // Master switch Delegate
    fileprivate let lightingCollectionViewController = LightingCollectionDataSource() // lighting collection data source
    fileprivate let socketCollectionViewController = SocketCollectionDataSource() // socket collection data source
    fileprivate let tempCollectionViewController = TempCollectionDataSource() // temp collection data source
    fileprivate let irrigationCollectionViewController = IrrigationCollectionDataSource() // curtain collection data source
    fileprivate let curtainCollectionViewController = CurtainCollectionDataSource() // curtain collection data source

    let cell1 = IndexPath(row: 3, section: 0)
    let cell2 = IndexPath(row: 5, section: 0)
    let cell3 = IndexPath(row: 7, section: 0)
    let cell4 = IndexPath(row: 9, section: 0)
    let cell5 = IndexPath(row: 11, section: 0)
    
    var isCell1Shown = false
    var isCell2Shown = false
    var isCell3Shown = false
    var isCell4Shown = false
    var isCell5Shown = false

    var rooms: RoomDatas?
    var curtailModule: GetModules?
    var irrigationModule: GetModules?
    var motionModule: GetModules?
    var socketModule: GetModules?
    var switchModule: GetModules?
    var thermostatModule: GetModules?
    let imagePicker = UIImagePickerController()
    var roomId = "" {
        didSet {
            print( "RoomId = " + roomId)
            guard let rooms = rooms else { return }
            for room in rooms.data {
                if room.roomID == roomId {
                    title = room.name
                    break
                }
            }
        }
    }
    var roomsTemp: RoomTemp?
    
    override func viewDidDisappear(_ animated: Bool) {
        lightCollectionView.delegate = nil
        lightCollectionView.dataSource = nil
        lightingCollectionViewController.delegate = nil
        socketCollectionView.delegate = nil
        socketCollectionView.dataSource = nil
        socketCollectionViewController.delegate = nil
        tempCollectionView.delegate = nil
        tempCollectionView.dataSource = nil
        tempCollectionViewController.delegate = nil
        irrigationCollectionView.delegate = nil
        irrigationCollectionView.dataSource = nil
        irrigationCollectionViewController.delegate = nil
        curtainCollectionView.delegate = nil
        curtainCollectionView.dataSource = nil
        curtainCollectionViewController.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        startIndicatorAnimate()
        updateUI()
        // teo coding
        DispatchQueue.main.async {
            if let module = RoomDatas.decode(directory: RoomDatas.archiveURL) {
                self.rooms = module
            } else {
                DispatchQueue.main.async {
                    SocketService.instance.getRooms { (rooms) in
                        guard let rooms = rooms else { self.presentTryLater() ; return }
                        self.rooms = rooms
                        RoomDatas.encode(userInfo: rooms, directory: RoomDatas.archiveURL)
                        self.collectionView.reloadData()
                    }
                    
                }
            }
            SocketService.instance.getRoomsTemp(completion: { (roomsTemp) in
                guard let roomsTemp = roomsTemp else { self.presentTryLater() ; return }
                self.roomsTemp = roomsTemp
                self.collectionView.reloadData()
            })
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Constant.Notify.readActivityUpdated, object: nil)
    }
    
    @objc func reloadData() {
        DispatchQueue.main.async {
            self.lightCollectionView.reloadData()
            self.socketCollectionView.reloadData()
            self.tempCollectionView.reloadData()
            self.curtainCollectionView.reloadData()
            self.irrigationCollectionView.reloadData()
        }
    }
    
    func getRoomModules(roomId: String) {
        print(roomId)
        // enter
        dispathGroup.enter()
        dispathGroup.enter()
        dispathGroup.enter()
        dispathGroup.enter()
        dispathGroup.enter()
        DispatchQueue.main.async {
            if let module = GetModules.decode(directory: GetModules.archiveURL(module: .Curtain, roomID: roomId)) {
                self.curtailModule = module
                self.curtainCollectionViewController.module = module
                self.curtainCollectionView.reloadData()
                self.dispathGroup.leave()
            } else {
                SocketService.instance.modulesOfRoom(roomID: roomId, moduleType: .Curtain) { (module) in
                    self.curtailModule = module
                    DispatchQueue.main.async {
                        print("1")
                        guard let module = module else { self.stopIndicatorAnimate() ; self.presentTryLater() ; return }
                        GetModules.encode(modules: module, directory: GetModules.archiveURL(module: .Curtain, roomID: roomId))
                        self.curtainCollectionViewController.module = module
                        self.curtainCollectionView.reloadData()
                        self.dispathGroup.leave()
                        // leave
                    }
                }
            }
            
            if let module = GetModules.decode(directory: GetModules.archiveURL(module: .Irrigation, roomID: roomId)) {
                self.irrigationModule = module
                self.irrigationCollectionViewController.module = module
                self.irrigationCollectionView.reloadData()
                self.dispathGroup.leave()
            } else {
                SocketService.instance.modulesOfRoom(roomID: roomId, moduleType: .Irrigation) { (module) in
                    self.irrigationModule = module
                    DispatchQueue.main.async {
                        print("2")
                        guard let module = module else { self.stopIndicatorAnimate() ; self.presentTryLater() ; return }
                        GetModules.encode(modules: module, directory: GetModules.archiveURL(module: .Irrigation, roomID: roomId))
                        self.irrigationCollectionViewController.module = module
                        self.irrigationCollectionView.reloadData()
                        self.dispathGroup.leave()
                        // leave
                    }
                }
            }
            
            if let module = GetModules.decode(directory: GetModules.archiveURL(module: .Socket, roomID: roomId)) {
                self.socketModule = module
                self.socketCollectionViewController.module = module
                self.socketCollectionView.reloadData()
                self.dispathGroup.leave()
            } else {
                SocketService.instance.modulesOfRoom(roomID: roomId, moduleType: .Socket) { (module) in
                    self.socketModule = module
                    DispatchQueue.main.async {
                        print("3")
                        guard let module = module else { self.stopIndicatorAnimate() ; self.presentTryLater() ; return }
                        GetModules.encode(modules: module, directory: GetModules.archiveURL(module: .Socket, roomID: roomId))
                        self.socketCollectionViewController.module = module
                        self.socketCollectionView.reloadData()
                        self.dispathGroup.leave()
                        // leave
                    }
                }
            }
            
            if let module = GetModules.decode(directory: GetModules.archiveURL(module: .Switch, roomID: roomId)) {
                self.switchModule = module
                self.lightingCollectionViewController.module = module
                self.lightCollectionView.reloadData()
                self.dispathGroup.leave()
            } else {
                SocketService.instance.modulesOfRoom(roomID: roomId, moduleType: .Switch) { (module) in
                    self.switchModule = module
                    DispatchQueue.main.async {
                        print("4")
                        guard let module = module else { self.stopIndicatorAnimate() ; self.presentTryLater() ; return }
                        GetModules.encode(modules: module, directory: GetModules.archiveURL(module: .Switch, roomID: roomId))
                        self.lightingCollectionViewController.module = module
                        self.lightCollectionView.reloadData()
                        self.dispathGroup.leave()
                        // leave
                    }
                }
            }
            
            if let module = GetModules.decode(directory: GetModules.archiveURL(module: .Thermostat, roomID: roomId)) {
                self.thermostatModule = module
                self.tempCollectionViewController.module = module
                self.tempCollectionView.reloadData()
                self.dispathGroup.leave()
            } else {
                SocketService.instance.modulesOfRoom(roomID: roomId, moduleType: .Thermostat) { (module) in
                    self.thermostatModule = module
                    DispatchQueue.main.async {
                        print("5")
                        guard let module = module else { self.stopIndicatorAnimate() ; self.presentTryLater() ; return }
                        GetModules.encode(modules: module, directory: GetModules.archiveURL(module: .Thermostat, roomID: roomId))
                        self.tempCollectionViewController.module = module
                        self.tempCollectionView.reloadData()
                        self.dispathGroup.leave()
                        // leave
                    }
                }
            }
            
            self.dispathGroup.notify(queue: .main) {
                self.tableView.reloadData()
                self.stopIndicatorAnimate()
            }
        }
        
    }
    
    // Method
    func updateUI() {
        addChangedLanguagedToViewController()
//        if DataManager.shared.applicationLanguage == .fa {
//            title = "لوازم خـانـه"
//        } else {
//            title = "Home Accessories"
//        }
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        lightCollectionView.delegate = collectionMasterDelegate
        lightCollectionView.dataSource = lightingCollectionViewController
        lightingCollectionViewController.delegate = self
        socketCollectionView.delegate = collectionMasterDelegate
        socketCollectionView.dataSource = socketCollectionViewController
        socketCollectionViewController.delegate = self
        tempCollectionView.delegate = collectionMasterDelegate
        tempCollectionView.dataSource = tempCollectionViewController
        tempCollectionViewController.delegate = self
        irrigationCollectionView.delegate = collectionMasterDelegate
        irrigationCollectionView.dataSource = irrigationCollectionViewController
        irrigationCollectionViewController.delegate = self
        curtainCollectionView.delegate = collectionMasterDelegate
        curtainCollectionView.dataSource = curtainCollectionViewController
        curtainCollectionViewController.delegate = self
    }
    
    func reloadHeightForTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 160.0 // room collectionView cell
        case 1:
            return 30.0 // empty cell
        case 3:
            if isCell1Shown {
                return lightCollectionView.collectionViewLayout.collectionViewContentSize.height + 8.0 // Light cell
            } else {
                return 0.0
            }
        case 5:
            if isCell2Shown {
                return socketCollectionView.collectionViewLayout.collectionViewContentSize.height + 8.0 // Socket cell
            } else {
                return 0.0
            }
        case 7:
            if isCell3Shown {
                return tempCollectionView.collectionViewLayout.collectionViewContentSize.height + 16.0 // Temp cell
            } else {
                return 0.0
            }
        case 9:
            if isCell4Shown {
                return curtainCollectionView.collectionViewLayout.collectionViewContentSize.height + 8.0// Curtain cell
            } else {
                return 0.0
            }
        case 11:
            if isCell5Shown {
                return irrigationCollectionView.collectionViewLayout.collectionViewContentSize.height + 8.0 // Irrigation
            } else {
                return 0.0
            }
        case 12:
            return 100.0 // empty cell
        default:
            return 44 // header cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playSound()
        switch (indexPath.section,indexPath.row) {
        case (cell1.section,cell1.row - 1):
            if isCell1Shown {
                isCell1Shown = false
            } else {
                isCell1Shown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        case (cell2.section,cell2.row - 1):
            if isCell2Shown {
                isCell2Shown = false
            } else {
                isCell2Shown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        case (cell3.section,cell3.row - 1):
            if isCell3Shown {
                isCell3Shown = false
            } else {
                isCell3Shown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        case (cell4.section,cell4.row - 1):
            if isCell4Shown {
                isCell4Shown = false
            } else {
                isCell4Shown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        case (cell5.section,cell5.row - 1):
            if isCell5Shown {
                isCell5Shown = false
            } else {
                isCell5Shown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    
}

extension HomeTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.homeCollectionCell.rawValue, for: indexPath) as! HomeCollectionViewCell
        guard let room = rooms?.data[indexPath.row] else { return cell }
        guard let roomsTemp = self.roomsTemp?.data else { return cell }
        for temp in roomsTemp {
            if temp.roomID == room.roomID {
                cell.configureCell(title: temp.temp + " ºC")
            }
        }
        if let imageData = DataManager.shared.pictures[room.image] {
            guard let image = UIImage.init(data: imageData) else { return cell }
            cell.configureCellImage(image: image)
        } else {
            guard room.image != "" else { return cell }
            SocketService.instance.getRoomsPicture(picName: room.image) { (image) in
                DispatchQueue.main.async {
                    guard let image = image else { return }
                    DataManager.shared.pictures[room.image] = image.pngData()
                    cell.configureCellImage(image: image)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        playSound()
        self.startIndicatorAnimate()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            guard let roomId = self.rooms?.data[indexPath.row].roomID else { return }
            self.getRoomModules(roomId: roomId)
            self.roomId = roomId
            
        })
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playSound()
        self.answserButton(title1: "انتخاب دوربین", title2: "انتخاب از گالری")
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        self.startIndicatorAnimate()
        DispatchQueue.main.async {
            if let image = info[.originalImage] as? UIImage {
                if let imageData = image.jpegData(compressionQuality: 0.1) {
                    SocketService.instance.uploadPics(picData: imageData, roomId: self.roomId) { (status) in
                        DispatchQueue.main.async {
                            if status {
                                self.presentIOSOkWarning()
                                self.stopIndicatorAnimate()
                            } else {
                                self.presentIOSProblemWarning()
                                self.stopIndicatorAnimate()
                                print("false")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    private func answserButton(title1: String, title2: String) {
        let alert = CDAlertView(title: "توجه !", message: "لطفا تصویر خود را انتخاب کنید", type: CDAlertViewType.notification)
        alert.titleFont = UIFont(name: Constant.Fonts.fontOne, size: 14)!
        alert.messageFont = UIFont(name: Constant.Fonts.fontOne, size: 14)!
        let done1 = CDAlertViewAction(title: title2, font: UIFont(name: Constant.Fonts.fontOne, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white) { (action) -> Bool in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            return true
        }
        let done2 = CDAlertViewAction(title: title1, font: UIFont(name: Constant.Fonts.fontOne, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white) { (action) -> Bool in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
            return true
        }
        let cancel = CDAlertViewAction(title: "هیچکدام", font: UIFont(name: Constant.Fonts.fontOne, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white, handler: nil)
        alert.add(action: done1)
      //  alert.add(action: done2)
        alert.add(action: cancel)
        alert.show()
    }
    

    
}
// button actions

extension HomeTableViewController: LightingCollectionDataSourceDelegate, SocketCollectionDataSourceDelegate {
    
    func socket1ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        let indexPath = socketCollectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = socketModule?.data[index].name else { return }
        playSound()
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
    
    func switch1ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        let indexPath = lightCollectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = switchModule?.data[index].name else { return }
        cell.homeTickImageView[0].image = #imageLiteral(resourceName: "tick")
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
        let indexPath = lightCollectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = switchModule?.data[index].name else { return }
        cell.homeTickImageView[1].image = #imageLiteral(resourceName: "tick")
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
        let indexPath = lightCollectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = switchModule?.data[index].name else { return }
        cell.homeTickImageView[2].image = #imageLiteral(resourceName: "tick")
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
        let indexPath = lightCollectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = switchModule?.data[index].name else { return }
        cell.homeTickImageView[3].image = #imageLiteral(resourceName: "tick")
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

extension HomeTableViewController: TempCollectionDataSourceDelegate {
    
    func tempOnOffValueChanged(cell: TempCollectionViewCell, sender: UISegmentedControl) {
        let indexPath = tempCollectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = thermostatModule?.data[index].name else { return }
        playSound()
        let onOrOff = sender.selectedSegmentIndex == 0 ? "Active":"Deactive"
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
        // NO Api Yet
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

extension HomeTableViewController: IrrigationCollectionDataSourceDelegate {
    
    func irrigationValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        let indexPath = irrigationCollectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = irrigationModule?.data[index].name else { return }
        playSound()
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
    
    
}


extension HomeTableViewController: CurtainCollectionDataSourceDelegate {
    
    func leftOnButtonOn(cell: ButtonMasterCollectionViewCell, onSender: UIButton, offSender: UIButton) {
        let indexPath = curtainCollectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = curtailModule?.data[index].name else { return }
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
        let indexPath = curtainCollectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = curtailModule?.data[index].name else { return }
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
        let indexPath = curtainCollectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = curtailModule?.data[index].name else { return }
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
        let indexPath = curtainCollectionView.indexPath(for: cell)
        guard let index = indexPath?.row else { return }
        guard let activityName = curtailModule?.data[index].name else { return }
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
