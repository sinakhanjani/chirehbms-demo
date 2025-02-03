//
//  ButtonMasterCollectionViewCell.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 11/2/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol ButtonMasterCollectionViewCellDelegate {
    func leftOnButtonOn(cell: ButtonMasterCollectionViewCell, onSender: UIButton, offSender: UIButton)
    func leftOffButtonOn(cell: ButtonMasterCollectionViewCell, offSender: UIButton, onSender: UIButton)
    func rightOnButtonOn(cell: ButtonMasterCollectionViewCell, onSender: UIButton, offSender: UIButton)
    func rightOffButtonOn(cell: ButtonMasterCollectionViewCell, offSender: UIButton, onSender: UIButton)

}

class ButtonMasterCollectionViewCell: UICollectionViewCell {
    
    var delegate: ButtonMasterCollectionViewCellDelegate?
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var moduleNameLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var firstTickImageView: UIImageView!
    @IBOutlet weak var secondTickImageView: UIImageView!
    
    @IBOutlet weak var leftOnButton: RoundedButton!
    @IBOutlet weak var leftOffButton: RoundedButton!
    @IBOutlet weak var rightOnButton: RoundedButton!
    @IBOutlet weak var rightOffButton: RoundedButton!
    
    func configureCell(modulesName: String, roomName: String) {
        self.moduleNameLabel.text = modulesName
        self.roomNameLabel.text = roomName
        if roomName == "" {
            lineView.isHidden = true
        } else {
            lineView.isHidden = false
        }
    }
    
    @IBAction func leftOnButtonPressed(_ sender: UIButton) {
        delegate?.leftOnButtonOn(cell: self, onSender: leftOnButton, offSender: leftOffButton)
    }
    
    @IBAction func leftOffButtonPressed(_ sender: UIButton) {
        delegate?.leftOffButtonOn(cell: self, offSender: leftOffButton, onSender: leftOnButton)

    }
    
    @IBAction func rightOnButtonPressed(_ sender: UIButton) {
        delegate?.rightOnButtonOn(cell: self, onSender: rightOnButton, offSender: rightOffButton)
    }
    
    @IBAction func rightOffButtonPressed(_ sender: UIButton) {
        delegate?.rightOffButtonOn(cell: self, offSender: rightOffButton, onSender: rightOnButton)

    }
    
}
