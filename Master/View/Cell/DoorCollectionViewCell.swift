//
//  DoorCollectionViewCell.swift
//  Master
//
//  Created by Sinakhanjani on 11/6/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol DoorCollectionViewCellDelegate {
    func doorButtonTapped(cell: DoorCollectionViewCell, sender: RoundedButton)
}

class DoorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var moduleNameLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var doorButton: RoundedButton!
    @IBOutlet weak var tickImageView: UIImageView!
    
    var delegate: DoorCollectionViewCellDelegate?
    
    @IBAction func doorButtonTapped(_ sender: RoundedButton) {
        delegate?.doorButtonTapped(cell: self, sender: sender)
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
