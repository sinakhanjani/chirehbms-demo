//
//  HomeTheaterRemoteViewController.swift
//  Master
//
//  Created by Sinakhanjani on 11/6/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class HomeTheaterRemoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func downButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Method
    func updateUI() {
        addChangedLanguagedToViewController()
        if DataManager.shared.applicationLanguage == .fa {
            title = "سینما خانگی"
        } else {
            title = "Home Theater"
        }
    }
    

}
