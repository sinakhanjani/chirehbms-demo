//
//  TempCollectionViewCell.swift
//  Master
//
//  Created by Sinakhanjani on 11/6/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol TempCollectionViewCellDelegate {
    func tempOnOffValueChanged(cell: TempCollectionViewCell,sender: UISegmentedControl)
    func measureValueChanged(cell: TempCollectionViewCell, sender: UIStepper)
    func fanSpeedValueChanged(cell: TempCollectionViewCell, sender: UISegmentedControl)
    func fanTypeValueChanged(cell: TempCollectionViewCell,sender: UISegmentedControl)
}

class TempCollectionViewCell: UICollectionViewCell {
    
    var delegate: TempCollectionViewCellDelegate?
    
    @IBOutlet weak var tickImageView: UIImageView!
    // TEMP OUTLET
    @IBOutlet weak var measureStepper: UIStepper!
    @IBOutlet weak var onOffSegmentControl: UISegmentedControl!
    @IBOutlet weak var fanSpeedSegmentControl: UISegmentedControl!
    @IBOutlet weak var fanTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var moduleNameLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!

    
    // ** TEMP ACTION **
    @IBAction func tempOnOffValueChanged(_ sender: UISegmentedControl) {
        delegate?.tempOnOffValueChanged(cell: self, sender: sender)
    }
    
    @IBAction func measureValueChanged(_ sender: UIStepper) {
        delegate?.measureValueChanged(cell: self, sender: sender)
    }
    
    @IBAction func fanSpeedValueChanged(_ sender: UISegmentedControl) {
        delegate?.fanSpeedValueChanged(cell: self, sender: sender)
    }
    
    @IBAction func fanTypeValueChanged(_ sender: UISegmentedControl) {
        delegate?.fanTypeValueChanged(cell: self, sender: sender)
    }
    
    func configureCell(modulesName: String, roomName: String) {
        self.moduleNameLabel.text = modulesName
        self.roomNameLabel.text = roomName
        if roomName == "" {
            lineView.isHidden = true
        } else {
            lineView.isHidden = false
        }
    }
    
}
