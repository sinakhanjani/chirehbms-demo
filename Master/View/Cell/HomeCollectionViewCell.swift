//
//  HomeCollectionViewCell.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 11/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(title: String) {
        self.titleLabel.text = title
    }
    
    func configureCellImage(image: UIImage) {
        self.imageView.image = image
    }
    

}
