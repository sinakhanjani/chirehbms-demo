//
//  UIViewControllerExtension.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import AVFoundation
import CDAlertView
import MaterialShowcase
import SideMenu
import Lottie
import AVKit
import AVFoundation
import LocalAuthentication

extension UIViewController {
    
    func backBarButtonAttribute(color: UIColor, name: String) {
        let backButton = UIBarButtonItem(title: name, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.persianFont(size: 15)], for: .normal)
        backButton.tintColor = color
        navigationItem.backBarButtonItem = backButton
    }
    
}

// MENU ANIMATION
extension UIViewController {
    
    func showAnimate() {
        self.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.4) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    func removeAnimate(boxView: UIView? = nil) {
        if let boxView = boxView {
            self.sideHideAnimate(view: boxView)
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            self.view.alpha = 0.0
        }) { (finished) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }
    
    func sideShowAnimate(view: UIView) {
        view.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
        UIView.animate(withDuration: 1.4) {
            view.transform = CGAffineTransform.identity
        }
    }
    
    func sideHideAnimate(view: UIView) {
        UIView.animate(withDuration: 1.4, animations: {
            view.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
        }) { (finished) in
            if finished {
                //
            }
        }
    }
    
}

extension UIViewController {
    
//    func presentMenuViewController() {
//        let vc =
//        self.addChild(vc)
//        vc.view.frame = self.view.frame
//        self.view.addSubview(vc.view)
//        vc.didMove(toParent: self)
//    }
    


    
}

extension UIViewController {
    
    func startIndicatorAnimate() {
        let vc = IndicatorViewController()
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func stopIndicatorAnimate() {
        NotificationCenter.default.post(name: Constant.Notify.dismissIndicatorViewControllerNotify, object: nil)
    }
    
}

extension UIViewController {
    
    func presentCDAlertWarningAlert(message: String, completion: @escaping () -> Void) {
        let titleAlertMsg = DataManager.shared.applicationLanguage == .fa ? "توجه !":"Alert !"
        let alert = CDAlertView(title: titleAlertMsg, message: message, type: CDAlertViewType.notification)
        alert.titleFont = UIFont(name: Constant.Fonts.fontTwo, size: 15)!
        alert.messageFont = UIFont(name: Constant.Fonts.fontOne, size: 13)!
        let doneAlertMsg = DataManager.shared.applicationLanguage == .fa ? "باشه":"Done"
        let done = CDAlertViewAction.init(title: doneAlertMsg, font: UIFont(name: Constant.Fonts.fontOne, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white) { (alert) -> Bool in
            completion()
            return true
        }
        alert.add(action: done)
        alert.show()
    }
    
    func presentIOSAlertWarning(message: String, completion: @escaping () -> Void) {
        let titleAlertMsg = DataManager.shared.applicationLanguage == .fa ? "توجه !":"Alert !"
        let title = NSAttributedString(string: titleAlertMsg, attributes: [NSAttributedString.Key.font : UIFont.init(name: Constant.Fonts.fontTwo, size: 15.0)!, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.08911790699, green: 0.08914073557, blue: 0.08911494166, alpha: 1)])
        let attributeMsg = NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.init(name: Constant.Fonts.fontOne, size: 13.0)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        let alertController = UIAlertController(title: titleAlertMsg, message: message, preferredStyle: .alert)
        alertController.setValue(attributeMsg, forKey: "attributedMessage")
        alertController.setValue(title, forKey: "attributedTitle")
        let doneAlertMsg = DataManager.shared.applicationLanguage == .fa ? "باشه":"Done"
        let doneAction = UIAlertAction.init(title: doneAlertMsg, style: .cancel) { (action) in
            completion()
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentIOSProblemWarning() {
        let titleAlertMsg = DataManager.shared.applicationLanguage == .fa ? "توجه !":"Alert !"
        let title = NSAttributedString(string: titleAlertMsg, attributes: [NSAttributedString.Key.font : UIFont.init(name: Constant.Fonts.fontTwo, size: 15.0)!, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.08911790699, green: 0.08914073557, blue: 0.08911494166, alpha: 1)])
        let falseFaAlert = "مشكل در برقراري ارتباط با سرور ابري"
        let falseEnAlert = "Problem with connecting to cloud"
        let message = DataManager.shared.applicationLanguage == .fa ? falseFaAlert:falseEnAlert
        let attributeMsg = NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.init(name: Constant.Fonts.fontOne, size: 13.0)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        let alertController = UIAlertController(title: titleAlertMsg, message: message, preferredStyle: .alert)
        
        alertController.setValue(attributeMsg, forKey: "attributedMessage")
        alertController.setValue(title, forKey: "attributedTitle")
        let doneAlertMsg = DataManager.shared.applicationLanguage == .fa ? "باشه":"Done"
        let doneAction = UIAlertAction.init(title: doneAlertMsg, style: .cancel) { (action) in
           // completion()
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentIOSOkWarning() {
//        let titleAlertMsg = DataManager.shared.applicationLanguage == .fa ? "توجه !":"Alert !"
//        let title = NSAttributedString(string: titleAlertMsg, attributes: [NSAttributedString.Key.font : UIFont.init(name: Constant.Fonts.fontTwo, size: 15.0)!, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.08911790699, green: 0.08914073557, blue: 0.08911494166, alpha: 1)])
//        let falseFaAlert = "عملیات با موفقیت انجام شد"
//        let falseEnAlert = "Process Done successfully"
//        let message = DataManager.shared.applicationLanguage == .fa ? falseFaAlert:falseEnAlert
//        let attributeMsg = NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.init(name: Constant.Fonts.fontOne, size: 13.0)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray])
//        let alertController = UIAlertController(title: titleAlertMsg, message: message, preferredStyle: .alert)
//        
//        alertController.setValue(attributeMsg, forKey: "attributedMessage")
//        alertController.setValue(title, forKey: "attributedTitle")
//        let doneAlertMsg = DataManager.shared.applicationLanguage == .fa ? "باشه":"Done"
//        let doneAction = UIAlertAction.init(title: doneAlertMsg, style: .cancel) { (action) in
//            // completion()
//        }
//        alertController.addAction(doneAction)
//        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentCDAlertWarningWithTwoAction(message: String, buttonOneTitle: String, buttonTwoTitle: String, handlerButtonOne: @escaping () -> Void, handlerButtonTwo: @escaping () -> Void) {
        let titleAlertMsg = DataManager.shared.applicationLanguage == .fa ? "توجه !":"Alert !"
        let alert = CDAlertView(title: titleAlertMsg, message: message, type: CDAlertViewType.notification)
        alert.titleFont = UIFont(name: Constant.Fonts.fontOne, size: 15)!
        alert.messageFont = UIFont(name: Constant.Fonts.fontOne, size: 13)!
        let buttonOne = CDAlertViewAction.init(title: buttonOneTitle, font: UIFont(name: Constant.Fonts.fontOne, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white) { (alert) -> Bool in
            handlerButtonOne()
            return true
        }
        let buttonTwo = CDAlertViewAction.init(title: buttonTwoTitle, font: UIFont(name: Constant.Fonts.fontOne, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white) { (alert) -> Bool in
            handlerButtonTwo()
            return true
        }
        alert.add(action: buttonOne)
        alert.add(action: buttonTwo)
        alert.show()
    }
    
    func presentIOSAlertWarningWithTwoButton(message: String, buttonOneTitle: String, buttonTwoTitle: String, handlerButtonOne: @escaping () -> Void, handlerButtonTwo: @escaping () -> Void) {
        let titleAlertMsg = DataManager.shared.applicationLanguage == .fa ? "توجه !":"Alert !"
        let title = NSAttributedString(string: titleAlertMsg, attributes: [NSAttributedString.Key.font : UIFont.init(name: Constant.Fonts.fontOne, size: 15.0)!, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.08911790699, green: 0.08914073557, blue: 0.08911494166, alpha: 1)])
        let attributeMsg = NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.init(name: Constant.Fonts.fontOne, size: 13.0)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        let alertController = UIAlertController(title: titleAlertMsg, message: message, preferredStyle: .alert)
        alertController.setValue(attributeMsg, forKey: "attributedMessage")
        alertController.setValue(title, forKey: "attributedTitle")
        let doneAction1 = UIAlertAction.init(title: buttonOneTitle, style: .default) { (action) in
            handlerButtonOne()
        }
        let doneAction2 = UIAlertAction.init(title: buttonTwoTitle, style: .default) { (action) in
            handlerButtonTwo()
        }
        alertController.addAction(doneAction1)
        alertController.addAction(doneAction2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func phoneNumberCondition(phoneNumber number: String) -> Bool {
        guard !number.isEmpty else {
            let faMessage = "شماره همراه خالی میباشد !"
            let enMessage = "Enter your phone number"
            let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
            presentCDAlertWarningAlert(message: message, completion: {})
            return false
        }
        let startIndex = number.startIndex
        let zero = number[startIndex]
        guard zero == "0" else {
            let faMessage = "شماره همراه خود را با صفر وارد کنید !"
            let enMessage = "Enter your phone number with zero first"
            let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
            presentCDAlertWarningAlert(message: message, completion: {})
            return false
        }
        guard number.count == 11 else {
            let faMessage = "شماره همراه میبایست یازده رقمی باشد !"
            let enMessage = "Your phone number must be eleven characters"
            let message = DataManager.shared.applicationLanguage == .fa ? faMessage:enMessage
            presentCDAlertWarningAlert(message: message, completion: {})
            return false
        }
        
        return true
    }
    
}

extension UIViewController {
    //
}

extension UIViewController: MaterialShowcaseDelegate {
    
    func showCase(view: UIView, header: String, text: String) {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: view) // always required to set targetView
        let customColor = UIColor(red: 23/255.0, green: 25/255.0, blue: 112/255.0, alpha: 1.0)
        showcase.primaryTextAlignment = .right
        showcase.secondaryTextAlignment = .right
        showcase.targetHolderRadius = view.frame.height
        showcase.backgroundViewType = .circle
        showcase.backgroundPromptColor = customColor
        showcase.targetHolderColor = .clear
        showcase.primaryText = header
        showcase.secondaryText = text
        showcase.show(completion: {
            // You can save showcase state here
            // Later you can check and do not show it again
        })
        showcase.delegate = self
    }
    
    
}

extension UIViewController {
    
    func configureTouchXibViewController(bgView: UIView) {
        self.view.endEditing(true)
        let touch = UITapGestureRecognizer(target: self, action: #selector(dismissTouchPressed))
        bgView.addGestureRecognizer(touch)
    }
    
    @objc private func dismissTouchPressed() {
        removeAnimate()
    }
    
    func configureStoryboardTouchViewController(bgView: UIView) {
        self.view.endEditing(true)
        let touch = UITapGestureRecognizer(target: self, action: #selector(dismissTouchStoryboardPressed))
        bgView.addGestureRecognizer(touch)
    }
    
    @objc private func dismissTouchStoryboardPressed() {
        dismiss(animated: true, completion: nil)
    }

}

extension UIViewController {
    
    func loadLottieJson(bundleName name: String, lottieView: UIView) {
        // Create Boat Animation
        let boatAnimation = LOTAnimationView(name: name)
        // Set view to full screen, aspectFill
        boatAnimation.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        boatAnimation.contentMode = .scaleAspectFill
        boatAnimation.frame = lottieView.bounds
        // Add the Animation
        lottieView.addSubview(boatAnimation)
        boatAnimation.loopAnimation = true
        boatAnimation.play()
    }
    
    func loadLottieFromURL(url: URL?, lottieView: UIView) {
        // Create Boat Animation
        guard let url = url else { return }
        let boatAnimation = LOTAnimationView.init(contentsOf: url)
        // Set view to full screen, aspectFill
        boatAnimation.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        boatAnimation.contentMode = .scaleAspectFill
        boatAnimation.frame = lottieView.bounds
        // Add the Animation
        lottieView.addSubview(boatAnimation)
        boatAnimation.loopAnimation = true
        boatAnimation.play()
    }
    
}

extension UIViewController {
    
    func configureSideBar() {
        // Define the menus
        SideMenuManager.default.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        //Set up a cool background image for demo purposes
        // SideMenuManager.default.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuBlurEffectStyle = .light
        SideMenuManager.default.menuFadeStatusBar = false
        // SideMenuManager.default.menuWidth = 0.7
        SideMenuManager.default.menuAnimationTransformScaleFactor = 1.0
        SideMenuManager.default.menuShadowOpacity = 0.7
        SideMenuManager.default.menuAnimationFadeStrength = 0.1
    }
    
}

extension UIViewController: AVPlayerViewControllerDelegate {
    
    func playVideo(url: URL) {
        let player = AVPlayer.init(url: url)
        let playerController = AVPlayerViewController()
        playerController.delegate = self
        playerController.player = player
        //self.addChildViewController(playerController)
        //self.view.addSubview(playerController.view)
        //playerController.view.frame = self.view.frame
        present(playerController, animated: true, completion: nil)
        player.play()
    }
    
    
}

extension UIViewController {
    
    func addChangedLanguagedToViewController() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Constant.Notify.LanguageChangedNotify, object: nil)
    }
    
    @objc private func languageChanged() {
        let parent = self.view.superview
        self.view.removeFromSuperview()
        self.view = nil
        parent?.addSubview(view)
    }
    
    
}

extension UIViewController {
    
    func authenticateWithTouchID() {
        let localAuthContext = LAContext()
        let enText = "Authentication is required to sign in Chireh BMS"
        let faText = "لطفا برای ورود پسورد را وارد کنید"
        let reasonText = DataManager.shared.applicationLanguage == .fa ? faText:enText
        var authError: NSError?
        if !localAuthContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            if let error = authError {
                print(error.localizedDescription)
            }
            self.present(AuthenticationViewController.showModal(), animated: true, completion: nil)
            return
        }
        localAuthContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonText, reply: { (success: Bool, error: Error?) -> Void in
            if !success {
                if let error = error {
                    switch error {
                    case LAError.authenticationFailed:
                        print("Authentication failed")
                    case LAError.passcodeNotSet:
                        print("Passcode not set")
                    case LAError.systemCancel:
                        print("Authentication was canceled by system")
                    case LAError.userCancel:
                        print("Authentication was canceled by the user")
                    case LAError.touchIDNotEnrolled:
                        print("Authentication could not start because Touch ID has no enrolled fingers.")
                    case LAError.touchIDNotAvailable:
                        print("Authentication could not start because Touch ID is not available.")
                    case LAError.userFallback:
                        print("User tapped the fallback button (Enter Password).")
                    default:
                        print(error.localizedDescription)
                    }
                }
                OperationQueue.main.addOperation({
                    self.present(AuthenticationViewController.showModal(), animated: true, completion: nil)
                })
            } else {
                //
            }
        })
    }
}
var bombSoundEffect: AVAudioPlayer?
let path = Bundle.main.path(forResource: "click", ofType: "mp3")!
let url = URL(fileURLWithPath: path)

extension UIViewController {
    
    func playSound() {
        guard DataManager.shared.sound else { return }
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.play()
        } catch {
            // couldn't load file :(
            print("cant find url")
        }
    }
    
    
    func presentTryLater() {
        presentIOSAlertWarning(message: "try later") {
            self.navigationController?.popViewController(animated: true)
            
        }
    }
}


