//
//  TvRemoteViewController.swift
//  Master
//
//  Created by Sinakhanjani on 11/6/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class TvRemoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Action
    @IBAction func downButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // Method
    func updateUI() {
        addChangedLanguagedToViewController()
        updateTabBarLanguage()
        if DataManager.shared.applicationLanguage == .fa {
            title = "تلویزیون"
        } else {
            title = "TV"
        }
    }
    
    func updateTabBarLanguage() {
        if let vcs = tabBarController?.viewControllers {
            let language = DataManager.shared.applicationLanguage
            for (i,vc) in vcs.enumerated() {
                switch i {
                case 0:
                    if language == .fa {
                        vc.tabBarItem.title = "تلویزیون"
                    } else {
                        vc.tabBarItem.title = "TV"
                    }
                case 1:
                    if language == .fa {
                        vc.tabBarItem.title = "اسپلیت"
                    } else {
                        vc.tabBarItem.title = "Split"
                    }
                case 2:
                    if language == .fa {
                        vc.tabBarItem.title = "سینما خانگی"
                    } else {
                        vc.tabBarItem.title = "Home Theater"
                    }
                case 3:
                    if language == .fa {
                        vc.tabBarItem.title = "ریسیور"
                    } else {
                        vc.tabBarItem.title = "Reciever"
                    }
                default:
                    break
                }
            }
        }
    }
    

}
