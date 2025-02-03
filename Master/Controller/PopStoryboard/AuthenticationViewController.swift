//
//  AuthenticationViewController.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 10/30/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var passwordTextField: InsetTextField!
    @IBOutlet weak var loginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func agreeButtonTapped(_ sender: Any) {
        guard let password = passwordTextField.text, password != "" else {
            let faMessage = "پسورد را وارد کنید"
            let enMessage = "Please Enter your password"
            let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
            self.presentIOSAlertWarning(message: message) {
                //
            }
            return
        }
        if DataManager.shared.applicationPassword == password {
            view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        } else {
            let faMessage = "پسورد اشتباه است"
            let enMessage = "Password is incorrect"
            let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
            presentIOSAlertWarning(message: message) {
                //
            }
        }
    }
    
    // Method
    func updateUI() {
        loginView.dismissedKeyboardByTouch()
    }
    
    static func showModal() -> AuthenticationViewController {
        let storyboard = UIStoryboard.init(name: "Pop", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewControllerID") as! AuthenticationViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
    
    
}
