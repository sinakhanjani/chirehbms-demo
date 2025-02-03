//
//  ScenarioCollectionViewCell.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 11/2/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
protocol ScenarioCollectionViewCellDelegate {
    func scenarioButtonTapped(cell: ScenarioCollectionViewCell, sender: RoundedButton)
}

class ScenarioCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scenarioButton: RoundedButton!
    @IBOutlet weak var tickImageView: UIImageView!
    
    var delegate:ScenarioCollectionViewCellDelegate?
    
    func configureCell(scenarioName: String) {
        self.scenarioButton.setTitle(scenarioName, for: .normal)
    }
    
    @IBAction func scenarioButtonTapped(_ sender: RoundedButton) {
        delegate?.scenarioButtonTapped(cell: self, sender: sender)
    }
    
    
    
}
