//
//  TempCollectionDataSource.swift
//  Master
//
//  Created by Sinakhanjani on 11/6/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol TempCollectionDataSourceDelegate {
    func tempOnOffValueChanged(cell: TempCollectionViewCell,sender: UISegmentedControl)
    func measureValueChanged(cell: TempCollectionViewCell, sender: UIStepper)
    func fanSpeedValueChanged(cell: TempCollectionViewCell, sender: UISegmentedControl)
    func fanTypeValueChanged(cell: TempCollectionViewCell,sender: UISegmentedControl)
}

class TempCollectionDataSource: NSObject, UICollectionViewDataSource, TempCollectionViewCellDelegate {
    
    var delegate: TempCollectionDataSourceDelegate?
    
    var module: GetModules?

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return module?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.tempSwitchCell.rawValue, for: indexPath) as! TempCollectionViewCell
        cell.delegate = self
        guard let module = module?.data[indexPath.row] else { return cell }
        let check = ReadController.instance.checkTrueActivities(module: module.name , bridge: indexPath.row + 1)
        let check2 = ReadController.instance.checkServerReaded(moduleName: module.name, bridge: indexPath.row + 1)
        let check4 = ReadController.instance.checkServerReadedThermustatSpeed()
        if check4 != nil {
            setThermustat(status: check4!, cell: cell)
        }
        
        let check3 = ReadController.instance.checkServerReadedThermustatType()
        if check3 != nil {
            setThermustatType(status: check3!, cell: cell)
        }
        cell.tickImageView.image = check2 ? #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
        cell.onOffSegmentControl.selectedSegmentIndex = check ? 0 : 1
        cell.configureCell(modulesName: module.name, roomName: "")
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
        delegate?.tempOnOffValueChanged(cell: cell, sender: sender)
    }
    
    func measureValueChanged(cell: TempCollectionViewCell, sender: UIStepper) {
        delegate?.measureValueChanged(cell: cell, sender: sender)
    }
    
    func fanSpeedValueChanged(cell: TempCollectionViewCell, sender: UISegmentedControl) {
        delegate?.fanSpeedValueChanged(cell: cell, sender: sender)
    }
    
    func fanTypeValueChanged(cell: TempCollectionViewCell, sender: UISegmentedControl) {
        delegate?.fanTypeValueChanged(cell: cell, sender: sender)
    }
    
    
}

