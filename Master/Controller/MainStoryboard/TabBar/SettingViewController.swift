//
//  SettingViewController.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 10/30/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, FileManagerDelegate {

    @IBOutlet weak var englishButton: RoundedButton!
    @IBOutlet weak var persianButton: RoundedButton!
    @IBOutlet weak var passwordButton: RoundedButton!
    @IBOutlet weak var passwordTextField: InsetTextField!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if DataManager.shared.isLoggedInWithPassowrd {
            authenticateWithTouchID()
            let faMessage = "حذف"
            let enMessage = "Delete"
            let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
            passwordButton.setTitle(message, for: .normal)
        }
    }
    
    // Action
    @IBAction func englishButtonTapped(_ sender: RoundedButton) {
        playSound()
        if DataManager.shared.applicationLanguage != .en {
            view.endEditing(true)
            self.startIndicatorAnimate()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.0) {
                self.stopIndicatorAnimate()
                DataManager.shared.applicationLanguage = .en
                self.englishButton.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.3019607843, blue: 0.3960784314, alpha: 1)
                self.persianButton.backgroundColor = #colorLiteral(red: 0.3875187635, green: 0.5710704923, blue: 0.7613347769, alpha: 1)
            }
        }
    }
    
    @IBAction func persianButtonTapped(_ sender: Any) {
        playSound()
        if DataManager.shared.applicationLanguage != .fa {
            view.endEditing(true)
            self.startIndicatorAnimate()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.0) {
                self.stopIndicatorAnimate()
                DataManager.shared.applicationLanguage = .fa
                self.persianButton.backgroundColor = #colorLiteral(red: 0.2063634992, green: 0.3046607673, blue: 0.4047507644, alpha: 1)
                self.englishButton.backgroundColor = #colorLiteral(red: 0.3875187635, green: 0.5710704923, blue: 0.7613347769, alpha: 1)
            }
        }
    }
    
    @IBAction func passwordAgreeButtonTapped(_ sender: Any) {
        if !DataManager.shared.isLoggedInWithPassowrd {
            guard let password = passwordTextField.text, password != "" else {
                let faMessage = "لطفا پسورد را انتخاب کنید"
                let enMessage = "Please enter your password"
                let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
                self.presentIOSAlertWarning(message: message) {
                    //
                }
                return
            }
            view.endEditing(true)
            DataManager.shared.applicationPassword = password
            let faMessage = "پسورد با موفقیت تعیین شد"
            let enMessage = "Password set complete"
            let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
            let faMessageq = "حذف"
            let enMessageq = "Delete"
            passwordTextField.text = ""
            let messageq = DataManager.shared.applicationLanguage == .fa ? faMessageq:enMessageq
            passwordButton.setTitle(messageq, for: .normal)
            self.presentIOSAlertWarning(message: message) {
                //
            }
        } else {
            guard let password = passwordTextField.text, password != "" else {
                let faMessage = "لطفا پسورد را وارد کنید"
                let enMessage = "Please enter your password"
                let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
                self.presentIOSAlertWarning(message: message) {
                    //
                }
                return
            }
            guard DataManager.shared.applicationPassword == passwordTextField.text, password != "" else {
                let faMessage = "پسورد وارد شده اشتباه است"
                let enMessage = "Incorrect Password"
                let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
                self.presentIOSAlertWarning(message: message) {
                    //
                }
                return
            }
            playSound()
            view.endEditing(true)
            DataManager.shared.applicationPassword = ""
            let faMessage = "پسورد با موفقیت حذف شد"
            let enMessage = "Password deleted successfully"
            let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
            let faMessageq = "تایید"
            let enMessageq = "Set"
            passwordTextField.text = ""
            let messageq = DataManager.shared.applicationLanguage == .fa ? faMessageq:enMessageq
            passwordButton.setTitle(messageq, for: .normal)
            self.presentIOSAlertWarning(message: message) {
                //
            }
        }
    }
    
    // Method
    func updateUI() {
        soundSwitch.isOn = DataManager.shared.sound
        addChangedLanguagedToViewController()
        view.dismissedKeyboardByTouch()
        if DataManager.shared.applicationLanguage == .fa {
            persianButton.backgroundColor = #colorLiteral(red: 0.2063634992, green: 0.3046607673, blue: 0.4047507644, alpha: 1)
        } else {
            englishButton.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.3019607843, blue: 0.3960784314, alpha: 1)
        }
    }

    
    @IBAction func soundSwitchValueChanged(_ sender: UISwitch) {
        DataManager.shared.sound = sender.isOn
    }
    
    @IBAction func syncButtonPressed(_ sender: Any) {
        playSound()
        startIndicatorAnimate()
        FileManager.default.delegate = self
        try? FileManager.default.removeItem(at: GetModules.archiveURL(module: .Curtain))
        try? FileManager.default.removeItem(at: GetModules.archiveURL(module: .Door))
        try? FileManager.default.removeItem(at: GetModules.archiveURL(module: .Irrigation))
        try? FileManager.default.removeItem(at: GetModules.archiveURL(module: .Socket))
        try? FileManager.default.removeItem(at: GetModules.archiveURL(module: .Switch))
        try? FileManager.default.removeItem(at: GetModules.archiveURL(module: .Thermostat))
        try? FileManager.default.removeItem(at: RoomDatas.archiveURL)
        try? FileManager.default.removeItem(at: Scenarios.archiveURL)

        SocketService.instance.getRooms { (rooms) in
            DispatchQueue.main.async {
                guard let rooms = rooms else { self.stopIndicatorAnimate() ; return }
                for room in rooms.data {
                    try? FileManager.default.removeItem(at: GetModules.archiveURL(module: .Curtain, roomID: room.roomID))
                    try? FileManager.default.removeItem(at: GetModules.archiveURL(module: .Door, roomID: room.roomID))
                    try? FileManager.default.removeItem(at: GetModules.archiveURL(module: .Irrigation, roomID: room.roomID))
                    try? FileManager.default.removeItem(at: GetModules.archiveURL(module: .Socket, roomID: room.roomID))
                    try? FileManager.default.removeItem(at: GetModules.archiveURL(module: .Switch, roomID: room.roomID))
                    try? FileManager.default.removeItem(at: GetModules.archiveURL(module: .Thermostat, roomID: room.roomID))
                }
                self.stopIndicatorAnimate()
            }
        }
    }
    
    func fileManager(_ fileManager: FileManager, shouldRemoveItemAt URL: URL) -> Bool {
        return true
    }
}
