//
//  CurtainCollectionDataSource.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 11/2/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol IrrigationCollectionDataSourceDelegate {
    func irrigationValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch)
}

class IrrigationCollectionDataSource: NSObject, UICollectionViewDataSource, SwitchMasterCollectionViewCellDelegate {
    
    var delegate:IrrigationCollectionDataSourceDelegate?
    
    var module: GetModules?

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return module?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.irrigationSwitchCell.rawValue, for: indexPath) as! SwitchMasterCollectionViewCell
        cell.delegate = self
        guard let module = module?.data[indexPath.row] else { return cell }
        cell.configureCell(numberOfSwitch: 1, modulesName: module.name, roomName: "")
        cell.lightSwitches[indexPath.row].isOn = ReadController.instance.checkTrueActivities(module: module.name)
        let check1 = ReadController.instance.checkServerReaded(moduleName: module.name)
        cell.tickImageView.image = check1 ? #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
        return cell
    }
    
    // *** SWITCH VALUE CHANED ACTION ***
    func switch1ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        delegate?.irrigationValueChanged(cell: cell, sender: sender)
    }
    
    func switch2ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        // NOT USE**
    }
    
    func switch3ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        // NOT USE**
    }
    
    func switch4ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        // NOT USE**
    }
    
    
}

