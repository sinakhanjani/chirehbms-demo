//
//  LightingCollectionDataSource.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 11/2/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol LightingCollectionDataSourceDelegate {
    func switch1ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch)
    func switch2ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch)
    func switch3ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch)
    func switch4ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch)
}

class LightingCollectionDataSource: NSObject, UICollectionViewDataSource, SwitchMasterCollectionViewCellDelegate {
    
    var delegate:LightingCollectionDataSourceDelegate?
    
    var module: GetModules? 
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return module?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.lightingSwitchCell.rawValue, for: indexPath) as! SwitchMasterCollectionViewCell
        cell.delegate = self
        guard let module = module?.data[indexPath.row] else { return cell }
        for i in 0...3 {
            cell.lightSwitches[i].isOn = ReadController.instance.checkTrueActivities(module: module.name , bridge: i + 1)
            let check = ReadController.instance.checkServerReaded(moduleName: module.name, bridge: i + 1)
            cell.homeTickImageView[i].image = check ? #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
        }
        
        cell.configureCell(numberOfSwitch: Int(module.bridge) ?? 0, modulesName: module.name, roomName: "")
       
        
        return cell
    }
    
    // *** SWITCH VALUE CHANED ACTION ***
    func switch1ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        delegate?.switch1ValueChanged(cell: cell, sender: sender)
    }
    
    func switch2ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        delegate?.switch2ValueChanged(cell: cell, sender: sender)
    }
    
    func switch3ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        delegate?.switch3ValueChanged(cell: cell, sender: sender)
    }
    
    func switch4ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch) {
        delegate?.switch4ValueChanged(cell: cell, sender: sender)
    }
    
    
}

