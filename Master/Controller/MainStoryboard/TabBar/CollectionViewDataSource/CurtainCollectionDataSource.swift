//
//  CurtainCollectionDataSource.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 11/2/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol CurtainCollectionDataSourceDelegate {
    func leftOnButtonOn(cell: ButtonMasterCollectionViewCell, onSender: UIButton, offSender: UIButton)
    func leftOffButtonOn(cell: ButtonMasterCollectionViewCell, offSender: UIButton, onSender: UIButton)
    func rightOnButtonOn(cell: ButtonMasterCollectionViewCell, onSender: UIButton, offSender: UIButton)
    func rightOffButtonOn(cell: ButtonMasterCollectionViewCell, offSender: UIButton, onSender: UIButton)
}

class CurtainCollectionDataSource: NSObject, UICollectionViewDataSource, ButtonMasterCollectionViewCellDelegate {
    
    var delegate: CurtainCollectionDataSourceDelegate?
    
    var module: GetModules?

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return module?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.curtainSwitchCell.rawValue, for: indexPath) as! ButtonMasterCollectionViewCell
        cell.delegate = self
        guard let module = module?.data[indexPath.row] else { return cell }
        let check = ReadController.instance.checkTrueActivities(module: module.name , bridge: 2) ? "Open":"Close"
        self.leftColor(check, onButton: cell.leftOnButton, offButton: cell.leftOffButton)
        
        let check1 = ReadController.instance.checkTrueActivities(module: module.name , bridge: 1) ? "Open":"Close"
        self.rightColor(check1, onButton: cell.rightOnButton, offButton: cell.rightOffButton)
        
        let check2 = ReadController.instance.checkServerReaded(moduleName: module.name, bridge: 1)
        cell.secondTickImageView.image = check2 ?  #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
        let check3 = ReadController.instance.checkServerReaded(moduleName: module.name, bridge: 2)
        cell.firstTickImageView.image = check3 ?  #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
        
        cell.configureCell(modulesName: "", roomName: module.name)
        return cell
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
    
    
    
    // *** SEGMENT VALUE CHANED ACTION ***

    
    func leftOnButtonOn(cell: ButtonMasterCollectionViewCell, onSender: UIButton, offSender: UIButton) {
        delegate?.leftOnButtonOn(cell: cell, onSender: onSender, offSender: offSender)
    }
    
    func leftOffButtonOn(cell: ButtonMasterCollectionViewCell, offSender: UIButton, onSender: UIButton) {
        delegate?.leftOffButtonOn(cell: cell, offSender: offSender, onSender: onSender)
    }
    
    func rightOnButtonOn(cell: ButtonMasterCollectionViewCell, onSender: UIButton, offSender: UIButton) {
        delegate?.rightOnButtonOn(cell: cell, onSender: onSender, offSender: offSender)
    }
    
    func rightOffButtonOn(cell: ButtonMasterCollectionViewCell, offSender: UIButton, onSender: UIButton) {
        delegate?.rightOffButtonOn(cell: cell, offSender: offSender, onSender: onSender)
    }
}

