//
//  MusicFileCollectionViewCell.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 11/2/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit


protocol MusicFileCollectionViewCellDelegate {
    func musicFileButtonTapped(cell: MusicFileCollectionViewCell, sender: RoundedButton)
}

class MusicFileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var musicFileButton: RoundedButton!
    
    var delegate:MusicFileCollectionViewCellDelegate?

    func configureCell(musicName: String) {
        self.musicFileButton.setTitle(musicName, for: .normal)
    }
    
    @IBAction func musicFileButtonTapped(_ sender: RoundedButton) {
        delegate?.musicFileButtonTapped(cell: self, sender: sender)
    }
    
    
    
}
