//
//  ViewController.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {
    
    fileprivate let dispathGroup = DispatchGroup()

    @IBOutlet weak var passwordTextField: InsetTextField!
    @IBOutlet weak var userNameTextField: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        //
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dispathGroup.notify(queue: .main) {
            print("COMPLETE FETCH ALL DATA")
            //
        }
    }

    
    // Action
    @IBAction func enterButtonTapped(_ sender: Any) {
        guard let password = passwordTextField.text, let userName = userNameTextField.text else {
            return
        }
        guard !password.isEmpty && !userName.isEmpty else {
            let faMessage = "نام کاربری و رمز عبور را وارد کنید"
            let enMessage = "Please enter username and password"
            let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
            self.presentIOSAlertWarning(message: message) {
                //
            }
            return
        }
        view.endEditing(true)
        playSound()
        SocketService.instance.login(username: userName, password: password) { (status) in
            DispatchQueue.main.async {
                if status {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let faMessage = "نام کاربری یا رمز عبور اشتباه است"
                    let enMessage = "username or password is incorrect"
                    let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
                    self.presentIOSAlertWarning(message: message) {
                    }
                }
            }
        }
    }
    
    // Method
    func updateUI() {
        addChangedLanguagedToViewController()
        view.dismissedKeyboardByTouch()
    }
    
    static func showModal() -> LoaderViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoaderViewControllerID") as! LoaderViewController
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }

}

