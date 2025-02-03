


//
//  SideMenuTableViewCell.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 10/30/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(color: UIColor, title: String, image: UIImage) {
        self.backgroundColor = color
        self.titleLabel.text = title
        self.iconImageView.image = image
    }

}
