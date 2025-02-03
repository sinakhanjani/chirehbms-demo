//
//  languageLabel.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 10/29/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class LanguageLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    @IBInspectable var enText: String = "" {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var faText: String = "" {
        didSet {
            setupView()
        }
    }
    
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//    }
    
    func setupView() {
        if DataManager.shared.isMultiLanguage {
            if DataManager.shared.applicationLanguage == .en {
                self.text = enText
            } else {
                self.text = faText
            }
        }
    }
    
//    override func setNeedsDisplay() {
//        super.setNeedsDisplay()
//        setupView()
//    }
    
//    override func setNeedsFocusUpdate() {
//        super.setNeedsFocusUpdate()
//        setupView()
//    }
    
//    override func reloadInputViews() {
//        super.reloadInputViews()
//        setupView()
//    }
    
//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//        setupView()
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setupView()
//    }
    
    
}
