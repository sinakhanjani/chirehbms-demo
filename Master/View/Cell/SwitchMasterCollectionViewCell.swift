//
//  HomeSwitchCollectionViewCell.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 11/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol SwitchMasterCollectionViewCellDelegate {
    func switch1ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch)
    func switch2ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch)
    func switch3ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch)
    func switch4ValueChanged(cell: SwitchMasterCollectionViewCell, sender: UISwitch)
}

class SwitchMasterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var lightSwitches: [UISwitch]!
    @IBOutlet weak var moduleNameLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet var seenImageView: [UIImageView]!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet var homeTickImageView: [UIImageView]!
    
    
    var delegate: SwitchMasterCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func switch1ValueChanged(_ sender: UISwitch) {
        delegate?.switch1ValueChanged(cell: self, sender: sender)
    }
    
    @IBAction func switch2ValueChanged(_ sender: UISwitch) {
        delegate?.switch2ValueChanged(cell: self, sender: sender)

    }
    
    @IBAction func switch3ValueChanged(_ sender: UISwitch) {
        delegate?.switch3ValueChanged(cell: self, sender: sender)

    }
    
    @IBAction func switch4ValueChanged(_ sender: UISwitch) {
        delegate?.switch4ValueChanged(cell: self, sender: sender)
    }
    
    func configureCell(numberOfSwitch: Int, modulesName: String, roomName: String) {
        for lighSwitch in lightSwitches {
            lighSwitch.isHidden = true
        }
        if numberOfSwitch < 5 && numberOfSwitch > 0 {
            for i in 0..<numberOfSwitch {
                lightSwitches[i].isHidden = false
            }
        }
        self.moduleNameLabel.text = modulesName
        self.roomNameLabel.text = roomName
        if roomName == "" {
            lineView.isHidden = true
        } else {
            lineView.isHidden = false
        }
    }
    
//    func configureSeen(first: Bool, second: Bool, third: Bool, forth: Bool) {
//        for (index,image) in seenImageView.enumerated() {
//            switch index {
//            case 0:
//                if first {
//                    image.image = #imageLiteral(resourceName: "doubleTick")
//                } else {
//                    image.image = #imageLiteral(resourceName: "tick")
//                }
//            case 1:
//                if second {
//                    image.image = #imageLiteral(resourceName: "doubleTick")
//                } else {
//                    image.image = #imageLiteral(resourceName: "tick")
//                }
//            case 2:
//                if third {
//                    image.image = #imageLiteral(resourceName: "doubleTick")
//                } else {
//                    image.image = #imageLiteral(resourceName: "tick")
//                }
//            case 3:
//                if forth {
//                    image.image = #imageLiteral(resourceName: "doubleTick")
//                } else {
//                    image.image = #imageLiteral(resourceName: "tick")
//                }
//            default:
//                break
//            }
//        }
//    }
    
}
