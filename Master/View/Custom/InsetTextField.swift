//
//  InsetTextField.swift
//  Pay Line
//
//  Created by Sinakhanjani on 9/23/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    @IBInspectable var enText: String = "" {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var enPlaceholder: String = "" {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var faText: String = "" {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var faPlaceholder: String = "" {
        didSet {
            setupView()
        }
    }

    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    func setupView() {
        if DataManager.shared.isMultiLanguage {
            if DataManager.shared.applicationLanguage == .en {
                self.text = enText
                self.textAlignment = .left
                self.attributedPlaceholder = NSAttributedString.init(string: enPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
            } else {
                self.text = faText
                self.textAlignment = .right
                self.attributedPlaceholder = NSAttributedString.init(string: faPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
            }
        }

    }
    
//    override func setNeedsDisplay() {
//        super.setNeedsDisplay()
//        setupView()
//    }
//    
//    override func reloadInputViews() {
//        super.reloadInputViews()
//        setupView()
//    }
//    
//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//        setupView()
//    }
//    
//    
//    override func setNeedsFocusUpdate() {
//        super.setNeedsFocusUpdate()
//        setupView()
//    }
    

}
